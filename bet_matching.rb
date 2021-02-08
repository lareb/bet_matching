#  The core functionality of this script is to create multiple bets
# Each bet are present in a hierarchy
# Matches > Markets > Bets

require "/home/rails/workspace/matching_bets/feed_generate"
require "awesome_print"
require 'logger'
require 'json'

class BetMatching < GenerateBets
  def initialize
    @path = "/home/rails/workspace/matching_bets/"
    File.delete("#{@path}/logs/matching_results.log")
    @log = Logger.new("#{@path}/logs/matching_results.log")
  end

  # initiate porcess to get the data and run matching algorythm
  def proccess
    # data = get_data
    separate_bets
  end

  # filter bets based on back/lay and odds
  def separate_bets
    #  iterate each matches
    # ap all_matches
    start_time = Time.now
    total_markets = 0
    all_matches.each do |match|
      # interate each market
      logger_trace "@@@@@@@@@@@@#{match[:name]}@@@@@@@@@@@@@@@"

      match[:markets].each do |market|
        # ap market[:bets]
        logger_trace "==========#{market[:title]}================"
        split_bets(market[:bets])
          # match_bets(back, lays)
      end
    end
    end_time = Time.now
    markets = all_matches.map{|t| t[:markets] }.flatten
    bets = markets.flatten.map{ |t| t[:bets] }.flatten
    # puts markets
    puts "Total matches = #{all_matches.length}, Total Markets = #{markets.length} and Total Bets = #{bets.length} ---------------#{end_time - start_time} secs"
  end

  def split_bets(bets)
    # ap bets
    backs = bets.select{ |b| b[:type] == :back }
    lays = bets.select{ |b| b[:type] == :lay }
    puts "----backs = #{backs.length} and --- lays = #{lays.length}\n================="

    total_back_unmatched_amount = backs.map{|t| t[:unmatched_amount]}.sum
    total_lay_unmatched_amount = lays.map{|t| t[:unmatched_amount]}.sum
    @log.info "\n-------------------\n#{backs.length} back bets in total\nTotal back amount = #{total_back_unmatched_amount}\n\n#{JSON.pretty_generate(backs)}"
    @log.info "\n-------------------\n#{lays.length} lay bets in total\nTotal lay amount = #{total_lay_unmatched_amount}\n\n#{JSON.pretty_generate(lays)}"

    match_bets(backs, lays)
  end

  def match_bets(backs, lays)
    # get the smallest type bet to start matching
    if(backs.length < lays.length)
      primary_bets = backs
      secondary_bets = lays
    else
      primary_bets = lays
      secondary_bets = backs
    end

    final_matched_bet = []

    # iterate bets
    primary_bets.each_with_index do |bet, index|
      # primary bet is matched
      primary_bet_matched = false
      current_bet_odds = bet[:odds]
      # primary_bet_unmatched_amount = bet[:unmatched_amount]

      puts "current bet type is => #{bet[:type]}\ncurrent odds is ===========#{current_bet_odds}\nunmatched amount => #{bet[:unmatched_amount]}\nPrimary bet id = #{bet[:id]}"
      # get similar odds bets
      similar_odds_bets = secondary_bets.select{ |b| b[:odds] == current_bet_odds && b[:status] != 'fully_matched' }
      # ap similar_odds_bets
      # puts "---------------matching explained below------------------\n"

      primary_matched_with_opposit_bets = []
      matched_amount = 0
      similar_odds_bets.each do |matching_with_bet|

        # matching_with_bet_unmatched_amount = matching_with_bet[:unmatched_amount]
        if(matching_with_bet[:unmatched_amount] == bet[:unmatched_amount])
          # both current bet and matching bet will adjust, both will update will status matched with 0 un matched amount
          # in this case exit the loop
          puts "Primary bet amount is FULLY_MATCHED with id/amount #{matching_with_bet[:id]}/#{matching_with_bet[:unmatched_amount]}\nMatched with bet is also FULLY_MATCHED"
          matched_amount = bet[:unmatched_amount]
          bet[:unmatched_amount] = 0
          bet[:status] = "fully_matched"
          matching_with_bet[:unmatched_amount] = 0
          matching_with_bet[:status] = "fully_matched"
          primary_bet_matched = true

        elsif(bet[:unmatched_amount] > matching_with_bet[:unmatched_amount])
          # matching with bet will be settle
          # current bet will be partially settle
          # break the loop
          bet[:unmatched_amount] = bet[:unmatched_amount] - matching_with_bet[:unmatched_amount]
          matched_amount = matching_with_bet[:unmatched_amount]
          puts "Primary bet amount is PARTIALLY_MATCHED with id/amount #{matching_with_bet[:id]}/#{matching_with_bet[:unmatched_amount]}\nUnmatched amount is = #{bet[:unmatched_amount]}\nMatched with bet is also FULLY_MATCHED"
          bet[:status] = "partially_matched"
          matching_with_bet[:unmatched_amount] = 0
          matching_with_bet[:status] = "fully_matched"
          primary_bet_matched = false
        elsif(bet[:unmatched_amount] < matching_with_bet[:unmatched_amount])
          # current bet will settle
          # matching with bet remain partial_settle
          matched_amount = bet[:unmatched_amount]
          matching_with_bet[:unmatched_amount] = matching_with_bet[:unmatched_amount] - bet[:unmatched_amount]
          puts "Primary bet amount is FULLY_MATCHED with id/amount #{matching_with_bet[:id]}/#{matching_with_bet[:unmatched_amount]}\nMatched with bet is PARTIALLY_MATCHED with amount #{matching_with_bet[:unmatched_amount]}"
          matching_with_bet[:status] = "partially_matched"
          bet[:unmatched_amount] = 0
          bet[:status] = "fully_matched"
          primary_bet_matched = true
        end
        # puts "primary bet's amount left = #{bet[:unmatched_amount]}"
        # push settle bets against primary bet
        primary_matched_with_opposit_bets.push(matching_with_bet)
        final_matched_bet.push([bet[:id], matching_with_bet[:id], current_bet_odds, matched_amount].join("  |  "))
        break if primary_bet_matched
      end

      @log.info "\n\n\n<<<<<<<<<<<<<<Matching bet #{bet[:id]}>>>>>>>>>>>>>>>>>\n#{bet}\nabove bet is matched with following bets (beow)\n#{JSON.pretty_generate(primary_matched_with_opposit_bets)}"
      # @log.info primary_matched_with_opposit_bets
      @log.info "\n>>>>>>>>>>>>>>>>>Matching of bet #{bet[:id]} is completed<<<<<<<<<<<<<<<<<<\n\n"
      # remove below break, its only for debuggin one record
      # break
    end

    logger_trace "------------Final matched bets-----------"
    ap final_matched_bet
    @log.info "\n   bet_id |m_bet_id | odds | matched_amount\n------------------------------\n#{JSON.pretty_generate(final_matched_bet)}"
    logger_trace "------------Bets after match-----------"
    sorted_final_bets = primary_bets.concat(secondary_bets).sort{|x, y| x[:status] <=> y[:status]}.map{|x| [x[:id], x[:odds], x[:unmatched_amount], x[:status]].join("    |   ")  }
    @log.info "\n   bet_id   |  odds   | status  | unmatched_amount\n------------------------------\n#{JSON.pretty_generate(sorted_final_bets)}"
    ap sorted_final_bets

  end

  def logger_trace(str)
    @log.info (str)
    ap str
  end

  # get the sample data, this will create a new set of sample data at every run
  def all_matches
    b = GenerateBets.new(1, 1, 40)
    # ap b.generate_sameple
    return b.generate_sameple
    # return b.example_feed
  end

end


b = BetMatching.new()
b.proccess
