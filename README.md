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
