module ApiCore
  class FaradayApiClient
    attr_accessor :base_uri

    def initialize(base_uri)
      self.base_uri = base_uri
    end

    def call_api(method, params)
      connection = create_new_connection(base_uri, params)
      package = build_package(method, params)
      perform_request(connection, package)
    end

    private

    def perform_request(connection, params)
      connection.send(params.http_method, params.http_path) do |req|
        req.body = params.parsed_body
        req.params = params.query
        req.headers = params.headers
      end
    end

    def create_new_connection(base_uri, params)
      Faraday.new(base_uri) do |faraday|
        if params.produces.include?('multipart/form-data')
          faraday.request :multipart
        else
          faraday.request :json
        end
        faraday.response :json, parser_options: { object_class: Hash } if params.produces.include?('application/json')
        faraday.response :logger, ::Logger.new($stdout), bodies: { request: true, response: false } if API_LOGS
      end
    end

    def build_package(method_name, params)
      params.http_method = method_name.to_s.split('_').first.to_sym
      params.http_path = build_path(params.url, params.path)
      params.headers = params.headers.to_h.transform_keys(&:to_s)
      params.query = params.query.to_h
      params.parsed_body = params.body.to_h.to_json
      params
    end

    def build_path(http_path, path_params)
      temp_path = http_path.split('/', http_path.count('/') + 1)
      temp_path.each_with_index do |variable, index|
        if /{(.*?)}/.match?(variable)
          name = variable[1..-2]
          temp_path[index] = path_params[name] || variable
        end
      end
      temp_path.join('/')
    end

    def parse_response_body(response)
      response.body = JSON.parse(response.body)
    rescue JSON::ParserError
      response.body = nil
    end
  end
end

