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

require 'sinatra/bells'

class Birds

  class App < Sinatra::Bells

    set_root __FILE__

    set :default_render, { json: :render_json }

    private

    def to_render_hash
      super(
        d: @document || @result.to_a,
        e: @error,
        q: @query
      )
    end

  end

end

require_relative 'app/helpers'
require_relative 'app/settings'
require_relative 'app/controllers'
