# myapp.rb
require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'dotenv'
require 'typeform'

Dotenv.load

get '/' do
    puts ENV['TYPEFORM_API_KEY']
    'Hello world!'
end