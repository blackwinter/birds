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

      module View

        def nav_item(path, name, title = nil)
          li_(link_to(name, path, title: title), class: active?(path))
        end

        def hl(text)
          h(text)
            .gsub(h(settings.highlighting_prefix),  settings.highlighting_prefix)
            .gsub(h(settings.highlighting_postfix), settings.highlighting_postfix)
        end

        def cl(text)
          text
            .gsub(settings.highlighting_prefix,  '')
            .gsub(settings.highlighting_postfix, '')
        end

        def link_to_document(document, highlighting = {})
          label = format_label(settings.document_label) { |k|
            h, d = highlighting.delete(k), document[k]
            h ? d.map { |v| h.find { |w| cl(w) == v } || v } : d
          }

          label = "##{document.id}" if label.empty?

          link_to(hl(label), :document, document.id)
        end

        def link_to_search(text, query, *filters)
          options = filters.last.is_a?(Hash) ? filters.pop : {}

          link_to(text, :search, options.merge(params:
            query ? query_params(query, filters) : { q: filters.first }))
        end

        def link_to_filter(text, query, filter)
          link_to_search(hl(text), query, cl(filter), *@filter)
        end

        def link_to_field(field, value, query = nil)
          link_to_filter(value, query, field_query(field, value))
        end

        def link_to_facet(field, value, gap = nil)
          link_to_filter(
            gap ? range_label(value, gap) : value,
            @query, facet_query(field, value, gap))
        end

        def facet_query(field, value, gap = nil)
          gap ? range_query(field, value, gap) : field_query(field, value)
        end

        def field_query(field, value)
          %Q{#{field}:"#{value}"}
        end

        def range_query(field, value, gap)
          value < 0 ?
            %Q|#{field}:[* TO #{-value}}| :
            %Q|#{field}:[#{value} TO #{value + gap}}|
        end

        def range_label(value, gap)
          value < 0 ? "before #{-value}" : "#{value}–#{value + gap - 1}"
        end

        def query_params(q = @query, fq = @filter)
          { q: q, 'fq[]' => fq }
        end

        def pagination_for(*args)
          params = args.last.is_a?(Hash) ?
            args.pop.reject { |_, v| v.nil? } : {}

          ul_([
            [@prev_page, :first, 1],
            [@prev_page, :prev,  @prev_page],
            [@next_page, :next,  @next_page],
            [@next_page, :last,  @total_pages]
          ], class: 'pagination') { |condition, type, page|
            [link_to_if(condition, pagination_icon(type), *args, rel: type,
              params: params.merge(page: page)), class: disabled?(condition)]
          }
        end

        def pagination_icon(type)
          tag_(:span, glyphicon(*{
            first: [:fast_backward, title: 'First page'],
            prev:  [:backward,      title: 'Previous page'],
            next:  [:forward,       title: 'Next page'],
            last:  [:fast_forward,  title: 'Last page']
          }[type]))
        end

        def glyphicon(name, options = {})
          name, options = name.to_s.tr('_', '-'), options.dup

          options[:class] = %W[glyphicon glyphicon-#{name}]
            .push(*options.delete(:class)).compact.join(' ')

          tag_(:span, options)
        end

        def values_for(key, document = @document)
          Array(document[key = key.to_s]).dup.tap { |values|
            return if values.empty?

            if settings.browse_fields.include?(key)
              values.map! { |v| link_to(v = hl(v), :browse, key, v) }
            elsif field = settings.linkable_fields[key]
              values.map! { |v| link_to_field(field, v) }
            else
              values.map!(&method(:hl))
            end
          }
        end

      end

    end

  end

end
