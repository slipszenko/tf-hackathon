# myapp.rb
require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'dotenv'
require 'typeform'
require 'twilio-ruby'

Dotenv.load

Twilio.configure do |config|
  config.account_sid = ENV['TWILIO_SID']
  config.auth_token = ENV['TWILIO_AUTH_TOKEN']
end

get '/' do
    puts ENV['TYPEFORM_API_KEY']
    'Hello world!'
end

get '/twilio_test' do
    @client = Twilio::REST::Client.new

    @client.messages.create(
        from: '+34911061281',
        to: ENV['TEST_PHONE_NUMBER'],
        body: 'This is a test message!'
    )
    'Should have sent the message'
end