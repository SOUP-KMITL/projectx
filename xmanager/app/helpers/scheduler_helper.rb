require 'erb'
require 'tilt'

require_relative '../models/schedule'

module XM
  module SchedulerHelper
    def all_schedules
      Models::Schedule.all
    end

    def create_schedule(options)
      if ['daily', 'weekly', 'at'].include?(options[:type])
        @schedule = Models::Schedule.create(options)
      else
        raise 'Wrong schedule type provided'
      end

      send(:"create_#{options[:type]}", @schedule)
    end

    def remove_schedule(id)
      schedule      = Models::Schedule.find(id)
      schedule_path = schedule_path(schedule.id)

      `whenever -c -f #{schedule_path}` 
      `rm #{schedule_path}`

      schedule.destroy
    end

    private

    def create_daily(schedule)
      context = schedule.serializable_hash.with_indifferent_access
      create_and_run_schedule('daily', context)
    end

    def create_weekly(schedule)
      context = {} # FIXME
      create_and_run_schedule('weekly', context)
    end

    def create_at(schedule)
      context = {} # FIXME
      create_and_run_schedule('at', context)
    end

    def create_and_run_schedule(template_name, context)
      schedule_path = schedule_path(context[:id])

      create_from_template(schedule_path, template_name, context)

      `whenever -i -f #{schedule_path}`
    end

    def create_from_template(schedule_path, template_name, context={})
      template = Tilt.new(find_template(template_name))
      rendered = template.render(nil, context)

      File.write(schedule_path, rendered)
    end

    def find_template(template_name)
      File.expand_path("../../../schedules/templates/#{template_name}.erb", __FILE__)
    end

    def schedule_path(id)
      schedule_name = "schedule_#{id}.rb"

      File.expand_path("../../../schedules/#{schedule_name}", __FILE__)
    end
  end
end

