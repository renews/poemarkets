require 'refresh_views'

task "refresh:views" => :environment do
  RefreshViews.perform
end