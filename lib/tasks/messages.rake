require 'check_messages_job'
#require 'check_garena_messages_job'

task "check:messages" => :environment do
  Resque.enqueue(CheckMessagesJob)
  #Resque.enqueue(CheckGarenaMessagesJob)
end