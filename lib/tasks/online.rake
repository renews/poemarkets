require 'check_online_job'

task "check:online" => :environment do
  Resque.enqueue(CheckOnlineJob)
end