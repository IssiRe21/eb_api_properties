require 'uri'
require 'net/http'
require 'JSON'

class Properties
	def initialize()
		@base_api_url_s = "https://api.stagingeb.com/v1"
		api_url = URI(@base_api_url_s)
		@http = Net::HTTP.new(api_url.host, api_url.port)
    @http.use_ssl = true
	end

	def list_url(page = 1, limit = 10)
		URI("#{@base_api_url_s}/properties?page=#{page}&limit=#{limit}")
	end

	def api_key
		ENV.fetch("API_KEY")
	end

	def get(url)
		request = Net::HTTP::Get.new(url)
		request["accept"] = 'application/json'
		request["X-Authorization"] = api_key
		@http.request(request)
	end
	
	def list(page: 1, limit: 10)
		response = get list_url(page, limit)

		# Raises an HTTP error if the response is not 2xx (success).
		# https://www.rubydoc.info/stdlib/net/Net/HTTPResponse
		response.value

		JSON.parse(response.read_body)
	end
end