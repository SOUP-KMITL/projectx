require 'sinatra/base'
require 'sinatra/config_file'
require 'sinatra/reloader'

require_relative 'lib/xclient'

class WebApp < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  enable :sessions

  register Sinatra::ConfigFile

  config_file File.expand_path('../config.yml', __FILE__)

  before /^(?!\/signin).*$/ do
    redirect to '/signin' unless session[:user]
  end

  get '/' do
    erb :index
  end

  get '/sessions' do
    erb :sessions
  end

  get '/signin' do
    redirect to '/' if session[:user]

    erb :signin
  end

  get '/signout' do
    session.clear

    redirect to '/signin'
  end

  post '/signin' do
    redirect to '/' if session[:user]

    if user = xclient.signin(params[:username], params[:password])
      puts "user is #{user}"
      session[:user] = user

      redirect to '/'
    else
      redirect to '/signin'
    end
  end

  private

  def xclient
    base_uri  = settings.xmanager[:server_addr]
    base_uri += ":#{settings.xmanager[:server_port]}" if settings.xmanager[:server_port]

    @xclient ||= XClient.new(base_uri: base_uri)
  end
end
