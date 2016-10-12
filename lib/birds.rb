# encoding: utf-8

#--
###############################################################################
#                                                                             #
# Birds -- Bibliographic information retrieval & document search              #
#                                                                             #
# Copyright (C) 2014-2015 Jens Wille                                          #
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

require 'rack'
require 'forwardable'

class Birds

  extend Forwardable

  DEFAULT_CONFIG = 'config.ru'

  class << self

    def app(path)
      app_class(path).new!
    end

    def rack_app
      new(__FILE__.sub(/\.rb\z/, '/rack_app'))
    end

    private

    def app_class(path)
      (@app_class ||= {})[path] ||= Rack::Builder.parse_file(path).first
    end

  end

  def initialize(path = DEFAULT_CONFIG)
    self.app = self.class.app(File.expand_path(path))
  end

  attr_accessor :app

  def_delegators 'app.settings', :solr, :solr_opts

  def count
    solr.count.to_i
  end

end

require_relative 'birds/version'
