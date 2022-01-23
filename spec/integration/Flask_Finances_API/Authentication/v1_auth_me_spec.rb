RSpec.describe 'Authentication' do
  describe 'GET /api/v1/auth/me' do

    before(:each) do
      @payload = OpenStruct.new
      @payload.consumes = 'application/json'
      @payload.produces = 'application/json'
      @payload.url = '/api/v1/auth/me'
    end

    it 'deve retornar os dados do usuário logado' do
      user_data = api_data_load('users', 'valid')

      @payload.headers = OpenStruct.new
      @payload.headers['Authorization'] = "Bearer #{generate_bearer_token(user_data)}"

      response = Flask_Finances_API().call_api(:get, @payload)

      aggregate_failures do
        expect(response.status).to eql(200)
        expect(response.body['id']).to eql(user_data.id)
        expect(response.body['name']).to eql(user_data.name)
        expect(response.body['email']).to eql(user_data.email)
      end
    end

    it 'deve retornar um erro quando não informar o bearer token' do
      response = Flask_Finances_API().call_api(:get, @payload)

      expected_error = api_data_load('default_errors', 'missing_bearer_token')
      aggregate_failures do
        expect(response.status).to eql(expected_error.status)
        expect(response.body['msg']).to eql(expected_error.message)
      end
    end

    it 'deve retornar um erro quando informar um bearer token expirado' do
      @payload.headers = OpenStruct.new
      @payload.headers['Authorization'] = api_data_load('tokens', 'expired').value

      response = Flask_Finances_API().call_api(:get, @payload)

      expected_error = api_data_load('default_errors', 'expired_bearer_token')
      aggregate_failures do
        expect(response.status).to eql(expected_error.status)
        expect(response.body['msg']).to eql(expected_error.message)
      end
    end

    it 'deve retornar um erro quando informar um bearer token inválido' do
      @payload.headers = OpenStruct.new
      @payload.headers['Authorization'] = api_data_load('tokens', 'invalid_value').value

      response = Flask_Finances_API().call_api(:get, @payload)

      expected_error = api_data_load('default_errors', 'invalid_token_format')
      aggregate_failures do
        expect(response.status).to eql(expected_error.status)
        expect(response.body['msg']).to eql(expected_error.message)
      end
    end

    it 'deve retornar um erro quando informar um bearer token com formato incorreto' do
      @payload.headers = OpenStruct.new
      @payload.headers['Authorization'] = api_data_load('tokens', 'invalid_type').value

      response = Flask_Finances_API().call_api(:get, @payload)

      expected_error = api_data_load('default_errors', 'invalid_token_type')
      aggregate_failures do
        expect(response.status).to eql(expected_error.status)
        expect(response.body['msg']).to eql(expected_error.message)
      end
    end
  end
end
