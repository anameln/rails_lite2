require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      @params = route_params.merge(parse_www_encoded_form(req.query_string))
      .merge(parse_www_encoded_form(req.body))
    end


    def [](key)
      @params[key.to_s]
    end

    # this will be useful if we want to `puts params` in the server log
    def to_s
      @params.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      return {} if www_encoded_form.nil?
      # hash = Hash[URI::decode_www_form(www_encoded_form)]
      arr = URI::decode_www_form(www_encoded_form)
      arr.map! { |el| [ parse_key(el[0]), el[1] ]}

      result = {}

      arr.each do |el|
        key, val = el[0], el[1]
        i = 0
        hash = result
        while i < key.length - 1
          if !hash[key[i]].nil?
            hash = hash[key[i]]
            i += 1
          else
            hash[key[i]] = to_hhash(key[(i+1)..-1], val)
            break
          end
        end
        hash[key[-1]] = el[1]
      end

      result
    end

    def to_hhash(key, val)
      return Hash[key[0], val] if key.size == 1
      hash = {}
      hash[key[0]] = to_hhash(key[1..-1], val)
      hash
    end



    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end
