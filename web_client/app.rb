require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/config_file'
require 'sinatra/reloader'

require_relative 'lib/xclient'
require_relative 'lib/xsigma'

class WebApp < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/*'
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
    s = { id: 1704 }

    sessions = [ s, s, s ]

    sessions.each do |ss|
      ss[:reports] = xclient.reports(ss[:id])
    end

    erb :sessions, locals: { title: 'Sessions', sessions: sessions }
  end

  get '/sessions/:session_id/reports/:report_name' do
    report = xclient.report(params[:session_id], params[:report_name])

    sigma = XSigma.from_all_in_one_json(report)

    erb :report, locals: { title: 'Report', g: sigma }
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
      session[:user] = user

      redirect to '/'
    else
      redirect to '/signin'
    end
  end

  private

  def xclient(api_key=nil)
    base_uri  = settings.xmanager[:server_addr]
    base_uri += ":#{settings.xmanager[:server_port]}" if settings.xmanager[:server_port]

    @xclient ||= XClient.new(base_uri: base_uri, api_key: api_key)
  end
end
