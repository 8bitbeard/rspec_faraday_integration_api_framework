RSpec.describe 'Authentication' do
  describe 'POST /api/v1/auth/login' do

    before(:each) do
      @payload = OpenStruct.new
      @payload.consumes = 'application/json'
      @payload.produces = 'application/json'
      @payload.url = '/api/v1/auth/login'
    end

    it 'deve realizar o login de um usuário válido com sucesso' do
      user_data = api_data_load('users', 'valid')

      @payload.body = OpenStruct.new
      @payload.body['email'] = user_data.email
      @payload.body['password'] = user_data.password

      response = Flask_Finances_API().call_api(:post, @payload)

      aggregate_failures do
        expect(response.status).to eql(201)
        expect(response.body['name']).to eql(user_data.name)
        expect(response.body['email']).to eql(user_data.email)
        expect(response.body['access']).not_to be_nil
        expect(response.body['refresh']).not_to be_nil
      end
    end

    it 'deve retornar um erro quando tentar logar com um usuário inexistente' do
      user_data = api_data_load('users', 'invalid')

      @payload.body = OpenStruct.new
      @payload.body['email'] = user_data.email
      @payload.body['password'] = user_data.password

      response = Flask_Finances_API().call_api(:post, @payload)

      expected_error = api_data_load('default_errors', 'wrong_credentials')
      aggregate_failures do
        expect(response.status).to eql(expected_error.status)
        expect(response.body['code']).to eql(expected_error.code)
        expect(response.body['message']).to eql(expected_error.message)
        expect(response.body['details'].first).to eql(expected_error.details)
      end
    end

    it 'deve retornar um erro quando tentar logar informando uma senha incorreta' do
      user_data = api_data_load('users', 'incorrect_password')

      @payload.body = OpenStruct.new
      @payload.body['email'] = user_data.email
      @payload.body['password'] = user_data.password

      response = Flask_Finances_API().call_api(:post, @payload)

      expected_error = api_data_load('default_errors', 'wrong_credentials')
      aggregate_failures do
        expect(response.status).to eql(expected_error.status)
        expect(response.body['code']).to eql(expected_error.code)
        expect(response.body['message']).to eql(expected_error.message)
        expect(response.body['details'].first).to eql(expected_error.details)
      end
    end

    it 'deve retornar um erro quando realizar uma requisição sem informar o e-mail' do
      user_data = api_data_load('users', 'valid')

      @payload.body = OpenStruct.new
      @payload.body['password'] = user_data.password

      response = Flask_Finances_API().call_api(:post, @payload)

      expected_error = api_data_load('default_errors', 'missing_parameters')
      aggregate_failures do
        expect(response.status).to eql(expected_error.status)
        expect(response.body['code']).to eql(expected_error.code)
        expect(response.body['message']).to eql(expected_error.message)
        expect(response.body['details'].first).to eql(expected_error.details)
      end
    end

    it 'deve retornar um erro quando realizar uma requisição sem informar a senha' do
      user_data = api_data_load('users', 'valid')

      @payload.body = OpenStruct.new
      @payload.body['email'] = user_data.email

      response = Flask_Finances_API().call_api(:post, @payload)

      expected_error = api_data_load('default_errors', 'missing_parameters')
      aggregate_failures do
        expect(response.status).to eql(expected_error.status)
        expect(response.body['code']).to eql(expected_error.code)
        expect(response.body['message']).to eql(expected_error.message)
        expect(response.body['details'].first).to eql(expected_error.details)
      end
    end
  end
end
