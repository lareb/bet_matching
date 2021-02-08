# A test script to generate sample bet data and run matching algorythm
## Install following gems
  $>gem install awesome_print  
  $>gem install logger
  $>gem install whenever

## Run following file

$>whenever --update-crontab

## cross check if crontab is created or not
$>crontab -l

# above command will create 3 log files
  1. Generated bets
  2. Matched bets with explaination
  3. Cron job log

# How to update sample bets
  ## Refer bet_matching.rb, all_matches method and change following parameters
  GenerateBets.new(matches, max_markets, bets)

# TODOs
  ## Benchmark testing

# Warning
Cron job can not used for everyx seconds, to do that you need to write a shell script
https://stackoverflow.com/questions/9619362/running-a-cron-every-30-seconds#:~:text=Cron%20job%20cannot%20be%20used,sleep%205%20command%20in%20it.&text=This%20will%20keep%20executing%20the,you%20logout%20from%20your%20session.
