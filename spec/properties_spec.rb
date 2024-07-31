require './properties'

describe Properties do

	let(:properties) { Properties.new }
	
	describe 'api_key' do

		let(:dummy_api_key) { '1234' }

		context 'when not provided' do
			it 'raises a KeyError' do
				expect{ properties.api_key }.to raise_error(KeyError)
			end
		end
	
		context 'when provided' do
			around(:example) do |ex|
				original_env = ENV.to_hash
				ENV['API_KEY'] = dummy_api_key
				ex.run
				ENV.replace(original_env)
			end
	
			it 'should not raise an error' do
				expect{ properties.api_key }.not_to raise_error
			end
	
			it 'contains the API_KEY environment variable' do
				expect(properties.api_key).to eq(dummy_api_key)
			end
		end
	end

	describe 'list' do
		context 'when the API returns a json' do
			let(:json_list_response_hash) {
				{
					"pagination"=>{
						"limit"=>10,
						"page"=>1,
						"total"=>1104,
						"next_page"=>"https://api.stagingeb.com/v1/properties?limit=10&page=2"
					},
					"content"=>[{
						"public_id"=>"EB-B5533",
						"title"=>"Casa en Venta Amorada en Santiago Nuevo Leon", 
						"title_image_full"=>"https://assets.stagingeb.com/property_images/25533/51552/EB-B5533.jpg?version=1555544668",
						"title_image_thumb"=>"https://assets.stagingeb.com/property_images/25533/51552/EB-B5533_thumb.jpg?version=1555544668",
						"location"=>"PRI, Santiago Papasquiaro, Durango",
						"operations"=>[{
							"type"=>"sale",
							"amount"=>5400000.0,
							"currency"=>"MXN",
							"formatted_amount"=>"$5,400,000",
							"commission"=>{"type"=>"percentage"},
							"unit"=>"total"
						}],
						"bedrooms"=>3,
						"bathrooms"=>3,
						"parking_spaces"=>2,
						"property_type"=>"Casa",
						"lot_size"=>262.0,
						"construction_size"=>324.0,
						"updated_at"=>"2024-01-04T20:10:28-07:00",
						"agent"=>"Pedro Kirkmans",
						"show_prices"=>true,
						"share_commission"=>false
					}]
				}
			}
			let(:json_list_response) {
				JSON.generate(json_list_response_hash)
			}

			before do
				response = double('HTTPResponse')
				allow(response).to receive(:value)
				allow(response).to receive(:read_body).and_return json_list_response
				allow(properties).to receive(:get).and_return response
			end

			it 'calls :get and returns a json' do
				expect(properties.list).to eq(json_list_response_hash)
			end
		end

		context 'when the API returns an invalid json' do
			before do
				response = double('HTTPResponse')
				allow(response).to receive(:value)
				allow(response).to receive(:read_body).and_return 'Invalid JSON'
				allow(properties).to receive(:get).and_return response
			end

			it 'raises a JSON::ParserError' do
				expect{ properties.list }.to raise_error(JSON::ParserError)
			end
		end

		context 'when the API returns an error' do
			before do
				response = Net::HTTPUnauthorized.new(1.0, 401, "Unauthorized")
				allow(properties).to receive(:get).and_return response
			end

			it 'raises a Net::HTTPClientException' do
				expect{ properties.list }.to raise_error(Net::HTTPClientException)
			end
		end
	end
end