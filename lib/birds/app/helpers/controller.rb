# encoding: utf-8

#--
###############################################################################
#                                                                             #
# Birds -- Bibliographic information retrieval & document search              #
#                                                                             #
# Copyright (C) 2014-2016 Jens Wille                                          #
#                                                                             #
# Birds is free software: you can redistribute it and/or modify it under the  #
# terms of the GNU Affero General Public License as published by the Free     #
# Software Foundation, either version 3 of the License, or (at your option)   #
# any later version.                                                          #
#                                                                             #
# Birds is distributed in the hope that it will be useful, but WITHOUT ANY    #
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS   #
# FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for     #
# more details.                                                               #
#                                                                             #
# You should have received a copy of the GNU Affero General Public License    #
# along with Birds. If not, see <http://www.gnu.org/licenses/>.               #
#                                                                             #
###############################################################################
#++

class Birds

  class App

    module Helpers

      module Controller

        def solr_query(path, params = {}, options = {}, &block)
          settings.solr.json_query(params, options, path, &block)
        end

        def search(params)
          solr_query(settings.solr_select_path, params)
        end

        def spell_query(query, params = {})
          solr_query(settings.solr_spell_path, params.merge(q: query))
        end

        def search_query(query, params = {})
          search(params.merge(q: query, fl: '*,score', defType: 'edismax'))
        end

        def search_document(id)
          search(q: { id: id }).first
        end

        def paginate_query(query, what, query_params = {})
          return unless query

          page, per_page = clip(params[:page].to_i),
            clip(Integer(params[:per_page] || settings.default_per_page))

          @prev_page, @next_page = page - 1, page + 1

          @result = search_query(query, query_params.merge(
            rows: per_page, start: @offset = @prev_page * per_page))

          @page_title_extra = '%d %s, page %d of %d' % [@result, what,
            page, @total_pages = clip(@result.to_i.fdiv(per_page).ceil)]

          @prev_page = nil if @prev_page < 1
          @next_page = nil if @next_page > @total_pages
        end

        def facet_params(params = {})
          params.merge(f: f = params[:f] || {}, facet: {
            field: fields = [], range: ranges = [], mincount: 1
          }).tap { settings.facet_fields.each { |facet, (_, options)|
            options.nil? ? fields << facet : begin ranges << facet
              ((f[facet] ||= {})[:facet] ||= {})[:range] = options
            end
          } }
        end

        def highlighting_params(params = {})
          params.merge(hl: {
            fl:              settings.highlighting_fields,
            snippets:        settings.highlighting_snippets,
            fragsize:        settings.highlighting_fragsize,
            mergeContiguous: true,
            preserveMulti:   true,
            simple: {
              pre:  settings.highlighting_prefix,
              post: settings.highlighting_postfix
            }
          })
        end

        def spellcheck_params(params = {})
          params.merge(spellcheck: { collate: true })
        end

        def terms(f = @field)
          settings.solr.json('terms', terms: { fl: f, limit: -1 }).to_h[f].sort
        end

        def explain_result(result = @result)
          result.debug_explain if result && result.debug?
        end

        def facet_counts(result = @result)
          return {} unless result && result.to_i > 1 && result.facet_counts?

          exclude, prepare = [@query, *@filter], lambda { |facet_hash, &block|
            facet_hash.delete_if { |key, hash|
              gap = block[hash] if block

              hash.delete_if { |term,|
                exclude.include?(facet_query(key, term, *gap)) }.size < 2
            }
          }

          prepare.(result.facet_fields.to_h).merge(
          prepare.(result.facet_ranges.to_h) { |hash|
            counts, before, start, gap = hash
              .values_at(*%w[counts before start gap])

            hash.clear
            hash[-start] = before if before && before > 1
            counts.each { |value, count| hash[value.to_i] = count }

            hash.singleton_class.send(:define_method, :gap) { gap }
            gap
          })
        end

        def highlighting(result = @result)
          result.highlighting if result && result.highlighting?
        end

        def spellcheck_collations(result = @result, limit = nil)
          result.spellcheck_collations(limit) if result && result.spellcheck?
        end

        private

        def clip(num, min = 1)
          num < min ? min : num
        end

      end

    end

  end

end
