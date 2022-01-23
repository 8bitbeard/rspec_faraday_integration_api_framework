module ApiCommons
  def generate_bearer_token(user_data)
    payload = OpenStruct.new
    payload.url = '/api/v1/auth/login'
    payload.consumes = 'application/json'
    payload.produces = 'application/json'

    payload.body = OpenStruct.new
    payload.body['email'] = user_data.email
    payload.body['password'] = user_data.password

    response = Flask_Finances_API().call_api(:post, payload)
    expect(response.status).to eql(201)

    response.body['access']
  end
end

