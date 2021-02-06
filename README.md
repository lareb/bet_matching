# A test script to generate sample bet data and run matching algorythm
## Install following gems
  $>gem install awesome_print
  
  $>gem install logger
  
## Run following file 

$>ruby bet_matching.rb

# above command will create 2 log files
  1. Generated bets
  2. Matched bets with explaination
  
  
# How to update sample bets
  ## Refer bet_matching.rb, all_matches method and change following parameters
  GenerateBets.new(matches, max_markets, bets)
