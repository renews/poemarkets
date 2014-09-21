RAILS_ENV = ENV['RAILS_ENV']
RAILS_ROOT = ENV['RAILS_ROOT'] || File.expand_path(File.dirname(__FILE__))
raise "Please specify RAILS_ENV." unless RAILS_ENV

require 'digest'

RESQUE_PROCESSORS = [
  #[queue_name, count]
  ["check_online_queue, check_messages_queue", 1],
  # ["check_messages_queue", 1],
  ["administration_queue, index_queue, verify_queue", 1],
  ["search_queue, account_queue, index_queue, verify_queue", 2],
  ["index_queue, destroy_shop_queue, verify_queue", 2]
]

RESQUE_PROCESSORS.each do |queue, number|
number.times do |num|
God.watch do |w|
  w.dir = RAILS_ROOT
  w.name = "resque-#{Digest::MD5.hexdigest(queue)}-#{num}"
  w.group = "resque"
  w.interval = 30.seconds
  w.env = {"RAILS_ROOT"=>RAILS_ROOT, "ROOT_URL"=>"http://www.poemarkets.com", "TERM_CHILD"=>1, "QUEUES"=>queue, "RESQUE_WORKER"=>'true', "RAILS_ENV"=>RAILS_ENV}
  w.start = "rake -f #{RAILS_ROOT}/Rakefile resque_environment resque:work"
  w.keepalive

  w.behavior(:clean_pid_file)

  # restart if memory gets too high
  #w.transition(:up, :restart) do |on|
  #  on.condition(:memory_usage) do |c|
  #    c.above = 350.megabytes
  #    c.times = 2
  #  end
  #end

  # determine the state on startup
  w.transition(:init, { true => :up, false => :start }) do |on|
    on.condition(:process_running) do |c|
      c.running = true
    end
  end

  # determine when process has finished starting
  w.transition([:start, :restart], :up) do |on|
    on.condition(:process_running) do |c|
      c.running = true
      c.interval = 5.seconds
    end

    # failsafe
    on.condition(:tries) do |c|
      c.times = 5
      c.transition = :start
      c.interval = 5.seconds
    end
  end

  # start if process is not running
  w.transition(:up, :start) do |on|
    on.condition(:process_running) do |c|
      c.running = false
    end
  end
end
end
end