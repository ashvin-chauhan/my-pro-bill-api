# require boot & environment for a Rails app
require_relative "../config/boot"
require_relative "../config/environment"

require 'clockwork'

module Clockwork

  handler do |job|
    puts "Running #{job}"
  end

  configure do |config|
    config[:sleep_timeout] = 5
    config[:logger] = Logger.new("log/cron_log.log")
    config[:tz] = 'EST'
    config[:max_threads] = 15
    config[:thread] = true
  end

  # handler receives the time when job is prepared to run in the 2nd argument
  # handler do |job, time|
  #   puts "Running #{job}, at #{time}"
  # end

  # Kick off a bunch of jobs early in the morning
  every 1.day, 'Mark invoice to overdue', :at => "00:01" do
    ::Invoice.mark_as_overdue
  end
end