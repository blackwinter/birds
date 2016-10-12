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

class Birds::App

  set :site_title,
    'Birds – Bibliographic information retrieval & document search'

  set :bootstrap_url,
    '//netdna.bootstrapcdn.com/bootstrap/3.1.1'

  set :solr_client do
    require 'solr4r'
    Solr4R::Client
  end

  solr_opts = Hash[%w[host port path core].map { |key| [key, "solr_#{key}"] }]

  set :solr_opts do
    Hash[solr_opts.map { |key, opt| [key.to_sym, settings.send(opt)] }]
  end

  solr_opts.each { |key, opt| set(opt) {
    settings.solr_client.const_get("DEFAULT_#{key.upcase}") } }

  set :solr do
    settings.solr_client.new(settings.solr_opts)
  end

  set :solr_select_path do
    settings.solr_client::DEFAULT_SELECT_PATH
  end

  set :solr_spell_path do
    settings.solr_client::DEFAULT_SPELL_PATH
  end

  set :solr_match_all_query do
    settings.solr_client::MATCH_ALL_QUERY
  end

  set_hash :display_fields1, %w[
    editor author title issue source imprint year pages isbn series
    abstract content footnote theme field form object location area aid
  ], %w[_txt] do |f, l| [f, l.capitalize] end

  set_hash :display_fields2, %w[
    compass lcsh precis rswk bk asb ddc sbb sfb ghbs kab lcc ssd rvk
  ], %w[_txt] do |f, l| [f, l.upcase] end

  set :display_fields do
    settings.display_fields1.merge(settings.display_fields2)
  end

  set_hash :linkable_fields, %w[
    editor author
    theme field object
    compass lcsh precis rswk bk asb ddc sbb sfb ghbs kab lcc ssd rvk
  ], %w[_txt _ss]

  set_hash :facet_fields, %w[
    author language type theme subject classification
  ].insert(1,
    [:year, start: 1900, end: 2100, gap: 10, other: 'before']
  ) do |f, o| ["#{f}_#{o ? :i : :ss}", ["#{f}s".capitalize, o]] end

  set :mlt_fields,
    author:  %w[author_txt],
    content: %w[title_txt abstract_txt subject_txt]

  set :browse_fields, {
#TODO     'cat'        => %w[Category     Categories],
#TODO     'manu_exact' => %w[Manufacturer Manufacturers]
  }

  set :scroll_fields, {
#TODO     'author_s' => 'Author'
  }

  set :highlighting_fields, '*'

  set :highlighting_snippets, 4

  set :highlighting_fragsize, 0

  set :highlighting_prefix, '<mark>'

  set :highlighting_postfix, '</mark>'

  set :sample_queries do
    { 'All documents' => settings.solr_match_all_query }
  end

  set :document_label, '{author_txt:%s: }{title_txt( : )}{year_txt: (%s)}'

  set :default_per_page, 20

end
