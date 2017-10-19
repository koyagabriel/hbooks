require 'rails_helper'

RSpec.describe 'User API', type: :request do
  let(:user) { attributes_for(:user) }
  let(:headers) { valid_header.except(:Authorization) }
  let(:validation_attributes) do
    user[:password_confirmation] = user[:password]
    user
  end

  # User signup test suite
  describe 'POST /register' do
    context 'when valid request' do
      before do
        post(
          '/users',
          params: validation_attributes.to_json,
          headers: headers
        )
      end

      it 'creates a new user' do
        expect(response).to have_http_status(201)
      end

      it 'returns success message' do
        expect(json['message']).to match(/Account created successfully/)
      end

      it 'returns an authentication token' do
        expect(json['auth-token']).not_to be_nil
      end
    end

    context 'when invalid request' do
      before { post '/register', params: {}, headers: headers }

      it 'does not create a new user' do
        expect(response).to have_http_status(422)
      end

      it 'returns failure message' do
        expect(json['message'])
          .to match(
            /Validation failed:
            Password can't be blank,
            Name can't be blank,
            Email can't be blank,
            Password digest can't be blank/
          )
      end
    end
  end
end