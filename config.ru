require './app'
Devcasts::App.env = ENV["RACK_ENV"] || :development
run Devcasts::App
