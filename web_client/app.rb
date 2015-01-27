require 'sinatra/base'
require 'sinatra/reloader'

class WebApp < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    erb :index
  end

  get '/sessions' do
    erb :sessions
  end
end
