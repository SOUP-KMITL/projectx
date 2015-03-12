require_relative 'app/helpers/scheduler_helper'

module XM
  class Scheduler < Sinatra::Base
    helpers SchedulerHelper

    get '/schedules/?' do
      json all_schedules
    end

    post '/schedules/?' do
      json create_schedule(params)
    end

    delete '/schedules/:id/?' do
      json remove_schedule(params[:id])
    end
  end
end
