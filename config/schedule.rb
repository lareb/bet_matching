require 'whenever'

path = "/home/rails/workspace/matching_bets"
set :output, "#{path}/logs/cron.log"
every 1.minutes do
  command "ruby '#{path}/bet_matching.rb'"
end
