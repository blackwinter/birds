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

require 'unicode'

class Birds::App

  get '/', render: :index do
    @page_title, @page_title_extra = 'Home',
      '%d documents' % count = settings.solr.count.to_i

    @page_title_query = settings.solr_match_all_query if count > 0
  end

  get '/search', render: :index do
    @page_title = 'Search'

    @query, @filter = params[:q] || params[:qq], Array(params[:fq])

    paginate_query(@query, :results,
      highlighting_params(facet_params(debug: 'results', fq: @filter)))

    @explain      = explain_result
    @facets       = facet_counts
    @highlighting = highlighting

    @spellcheck = spellcheck_collations(
      spell_query(@query, spellcheck_params(fq: @filter))).to_a
  end

  get '/browse', render: :browse do
    @page_title, @fields = 'Browse', settings.browse_fields
  end

  get '/browse/:field', render: :browse do
    @page_title, @field = 'Browse', params[:field]
    bad_request unless labels = settings.browse_fields[@field]

    @hierarchy, @page_title_extra = terms, labels.last
  end

  get '/browse/:field/*', render: :browse do
    @page_title, @field = 'Browse', params[:field]
    bad_request unless labels = settings.browse_fields[@field]

    category = params[:splat].join('/')
    bad_request if category.empty?

    @page_title_extra = "#{labels.first}: #{category}"

    @result = search_query(@field => category)
    not_found if @result.empty?
  end

  get '/scroll', render: :scroll do
    @page_title, @fields = 'Scroll', settings.scroll_fields
  end

  get '/scroll/:field', render: :scroll do
    @page_title, @field = 'Scroll', params[:field]
    bad_request unless label = settings.scroll_fields[@field]

    @letters = terms.group_by { |term,|
      Unicode.upcase(term[0])
    }.map { |letter, values|
      [letter, values.map(&:last).inject(:+)] if letter =~ /\p{Letter}/
    }.compact

    @page_title_extra = label
  end

  get '/scroll/:field/:letter', render: :scroll do
    @page_title, @field = 'Scroll', params[:field]
    bad_request unless label = settings.scroll_fields[@field]

    @letter = params[:letter]
    paginate_query({ @field => "#{@letter}*" }, :documents)

    @page_title_extra = "#{label}: #{@letter}"
  end

  get '/document/*', render: :document do
    id = params[:splat].join('/')

    bad_request if id.empty?
    not_found unless @document = search_document(id)

    mlt_fields, @similar, @explain = settings.mlt_fields, {}, {}
    mlt_fields = { nil => mlt_fields } unless mlt_fields.is_a?(Hash)

    mlt_fields.each { |key, fields|
      mlt = @document.more_like_this(fields,
        debug: 'results', mlt: { boost: true, mintf: 1, minwl: 4 })

      @similar[key], @explain[key] = mlt, explain_result(mlt) unless mlt.empty?
    }

    @page_title, @page_title_extra = 'Document', "##{id}"
  end

end
