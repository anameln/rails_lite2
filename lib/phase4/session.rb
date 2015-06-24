require 'json'
require 'webrick'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      @req = req
      c = @req.cookies.find { |c| c.name == '_rails_lite_app' }

      if c
        @cookie = JSON.parse(c.value)
      else
        @cookie = {}
      end

      # @req = req
      #
      # if @req.cookies['_rails_lite_app']
      #   @cookie['_rails_lite_app'] = (@req.cookies['_rails_lite_app']).to_json
      # else
      #   @cookie = {}
      # end

    end

    def [](key)
      @cookie[key]
    end

    def []=(key, val)
      @cookie[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)

      res.cookies << WEBrick::Cookie.new('_rails_lite_app', @cookie.to_json)

    end
  end
end
