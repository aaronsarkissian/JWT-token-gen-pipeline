require 'jwt'

key = ENV['PRIVATE_KEY']
team_id = ENV['TEAM_ID']
client_id = ENV['CLIENT_ID']
key_id = ENV['KEY_ID']
ecdsa_key = OpenSSL::PKey::EC.new(key)

token = JWT.encode({
  iss: team_id,
  iat: Time.now.to_i,
  exp: Time.now.to_i + 86400 * 60,
  aud: 'https://sample.example.com',
  sub: client_id
}, ecdsa_key, 'ES256', { kid: key_id })

puts token
