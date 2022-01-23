RSpec.describe 'Authentication' do
  describe 'POST /api/v1/auth/login' do

    before(:each) do
      @payload = OpenStruct.new
      @payload.consumes = 'application/json'
      @payload.produces = 'application/json'
      @payload.url = '/api/v1/users/'
    end

    it 'deve criar um usuário novo com sucesso' do
      @payload.body = OpenStruct.new
      @payload.body['name'] = Faker::Name.first_name
      @payload.body['email'] = "qa_tmp_#{rand(100_000..999_999)}@example.com"
      @payload.body['password'] = rand(100_000..999_999).to_s

      response = Flask_Finances_API().call_api(:post, @payload)

      aggregate_failures do
        expect(response.status).to eql(201)
        expect(response.body['id']).not_to be_nil
        expect(response.body['name']).to eql(@payload.body['name'])
        expect(response.body['email']).to eql(@payload.body['email'])
      end
    end

    it 'deve retornar um erro ao tentar criar um usuário sem informar o nome' do
      @payload.body = OpenStruct.new
      @payload.body['email'] = "qa_tmp_#{rand(100_000..999_999)}@example.com"
      @payload.body['password'] = rand(100_000..999_999).to_s

      response = Flask_Finances_API().call_api(:post, @payload)

      aggregate_failures do
        expected_error = api_data_load('default_errors', 'bad_request missing_user_parameters')
        expect(response.status).to eql(expected_error.status)
        expect(response.body['code']).to eql(expected_error.code)
        expect(response.body['message']).to eql(expected_error.message)
        expect(response.body['details'].first).to eql(expected_error.details)
      end
    end

    it 'deve retornar um erro ao tentar criar um usuário sem informar o email' do
      @payload.body = OpenStruct.new
      @payload.body['name'] = Faker::Name.first_name
      @payload.body['password'] = rand(100_000..999_999).to_s

      response = Flask_Finances_API().call_api(:post, @payload)

      aggregate_failures do
        expected_error = api_data_load('default_errors', 'bad_request missing_user_parameters')
        expect(response.status).to eql(expected_error.status)
        expect(response.body['code']).to eql(expected_error.code)
        expect(response.body['message']).to eql(expected_error.message)
        expect(response.body['details'].first).to eql(expected_error.details)
      end
    end

    it 'deve retornar um erro ao tentar criar um usuário sem informar a senha' do
      @payload.body = OpenStruct.new
      @payload.body['name'] = Faker::Name.first_name
      @payload.body['email'] = "qa_tmp_#{rand(100_000..999_999)}@example.com"

      response = Flask_Finances_API().call_api(:post, @payload)

      aggregate_failures do
        expected_error = api_data_load('default_errors', 'bad_request missing_user_parameters')
        expect(response.status).to eql(expected_error.status)
        expect(response.body['code']).to eql(expected_error.code)
        expect(response.body['message']).to eql(expected_error.message)
        expect(response.body['details'].first).to eql(expected_error.details)
      end
    end

    it 'deve retornar um erro ao tentar criar um usuário com um nome inválido' do
      @payload.body = OpenStruct.new
      @payload.body['name'] = Faker::Name.name
      @payload.body['email'] = "qa_tmp_#{rand(100_000..999_999)}@example.com"
      @payload.body['password'] = rand(100_000..999_999).to_s

      response = Flask_Finances_API().call_api(:post, @payload)

      aggregate_failures do
        expected_error = api_data_load('default_errors', 'bad_request invalid_user_name')
        expect(response.status).to eql(expected_error.status)
        expect(response.body['code']).to eql(expected_error.code)
        expect(response.body['message']).to eql(expected_error.message)
        expect(response.body['details'].first).to eql(expected_error.details)
      end
    end

    it 'deve retornar um erro ao tentar criar um usuário com um email inválido' do
      @payload.body = OpenStruct.new
      @payload.body['name'] = Faker::Name.first_name
      @payload.body['email'] = "qa_tmp_#{rand(100_000..999_999)}example.com"
      @payload.body['password'] = rand(100_000..999_999).to_s

      response = Flask_Finances_API().call_api(:post, @payload)

      aggregate_failures do
        expected_error = api_data_load('default_errors', 'bad_request invalid_user_email')
        expect(response.status).to eql(expected_error.status)
        expect(response.body['code']).to eql(expected_error.code)
        expect(response.body['message']).to eql(expected_error.message)
        expect(response.body['details'].first).to eql(expected_error.details)
      end
    end

    it 'deve retornar um erro ao tentar criar um usuário com um email já existente' do
      @payload.body = OpenStruct.new
      @payload.body['name'] = Faker::Name.first_name
      @payload.body['email'] = api_data_load('users', 'valid').email
      @payload.body['password'] = rand(100_000..999_999).to_s

      response = Flask_Finances_API().call_api(:post, @payload)

      aggregate_failures do
        expected_error = api_data_load('default_errors', 'conflict email_already_exists')
        expect(response.status).to eql(expected_error.status)
        expect(response.body['code']).to eql(expected_error.code)
        expect(response.body['message']).to eql(expected_error.message)
        expect(response.body['details'].first).to eql(expected_error.details)
      end
    end

    it 'deve retornar um erro ao tentar criar um usuário com um uma senha inválida' do
      @payload.body = OpenStruct.new
      @payload.body['name'] = Faker::Name.first_name
      @payload.body['email'] = "qa_tmp_#{rand(100_000..999_999)}@example.com"
      @payload.body['password'] = rand(100_00..999_99).to_s

      response = Flask_Finances_API().call_api(:post, @payload)

      aggregate_failures do
        expected_error = api_data_load('default_errors', 'bad_request invalid_user_password')
        expect(response.status).to eql(expected_error.status)
        expect(response.body['code']).to eql(expected_error.code)
        expect(response.body['message']).to eql(expected_error.message)
        expect(response.body['details'].first).to eql(expected_error.details)
      end
    end
  end
end
