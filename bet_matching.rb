#  The core functionality of this script is to create multiple bets
# Each bet are present in a hierarchy
# Matches > Markets > Bets

require "./feed_generate"
require "awesome_print"
require 'logger'
require 'json'

class BetMatching < GenerateBets
  def initialize
    File.delete("matching_results.log")
    @log = Logger.new("matching_results.log")
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
    all_matches.each do |match|
      # interate each market
      @log.info "@@@@@@@@@@@@#{match[:name]}@@@@@@@@@@@@@@@"
      match[:markets].each do |market|
        # ap market[:bets]
        puts "==========#{market[:title]}================"
        @log.info "=================#{market[:title]}======================"
        split_bets(market[:bets])
          # match_bets(back, lays)
      end
    end
  end

  def split_bets(bets)
    # ap bets
    backs = bets.select{ |b| b[:type] == :back }
    lays = bets.select{ |b| b[:type] == :lay }
    puts "----backs = #{backs.length} and --- lays = #{lays.length}"

    total_back_unmatched_amount = backs.map{|t| t[:unmatched_amount]}.sum
    total_lay_unmatched_amount = lays.map{|t| t[:unmatched_amount]}.sum
    @log.info "\n-----All back bets count => (#{backs.length})\nTotal back amount = #{total_back_unmatched_amount}------"
    @log.info JSON.pretty_generate(backs)
    @log.info "\n-----All lay bets count => (#{lays.length})\nTotal lay amount = #{total_lay_unmatched_amount}------"
    @log.info JSON.pretty_generate(lays)

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

    # iterate bets
    primary_bets.each_with_index do |bet, index|
      # primary bet is matched
      primary_bet_matched = false
      current_bet_odds = bet[:odds]
      # primary_bet_unmatched_amount = bet[:unmatched_amount]

      puts "#{index}. current bet type is => #{bet[:type]}\ncurrent odds is ===========#{current_bet_odds}\nunmatched amount => #{bet[:unmatched_amount]}"
      # get similar odds bets
      similar_odds_bets = secondary_bets.select{ |b| b[:odds] == current_bet_odds && b[:status] != 'fully_matched' }
      ap similar_odds_bets
      puts "---------------matching explained below------------------\n"

      primary_matched_with_opposit_bets = []
      similar_odds_bets.each do |matching_with_bet|

        # matching_with_bet_unmatched_amount = matching_with_bet[:unmatched_amount]
        if(matching_with_bet[:unmatched_amount] == bet[:unmatched_amount])
          # both current bet and matching bet will adjust, both will update will status matched with 0 un matched amount
          # in this case exit the loop
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
          bet[:status] = "partially_matched"
          matching_with_bet[:unmatched_amount] = 0
          matching_with_bet[:status] = "fuly_matched"
        elsif(bet[:unmatched_amount] < matching_with_bet[:unmatched_amount])
          # current bet will settle
          # matching with bet remain partial_settle
          matching_with_bet[:unmatched_amount] = matching_with_bet[:unmatched_amount] - bet[:unmatched_amount]
          matching_with_bet[:status] = "partially_matched"
          bet[:unmatched_amount] = 0
          bet[:status] = "fully_matched"
          primary_bet_matched = true
        end
        puts "primary bet's amount left = #{bet[:unmatched_amount]}"
        # push settle bets against primary bet
        primary_matched_with_opposit_bets.push(matching_with_bet)
        break if primary_bet_matched
      end

      @log.info "\n\n\n<<<<<<<<<<<<<<Matching details>>>>>>>>>>>>>>>>>\n"
      @log.info JSON.pretty_generate(bet)
      @log.info "above bet is matched with following bets (beow)"
      @log.info JSON.pretty_generate(primary_matched_with_opposit_bets)
      @log.info "\n\n\n\n\++++++++++++++++++++++++++++++++++++++++++++++++++\n\n\n\n"

      puts "settled with bets are following ==============="
      ap primary_matched_with_opposit_bets

      puts "-------------END---------------\n\n"
      # remove below break, its only for debuggin one record
      # break
    end
  end

  # get the sample data, this will create a new set of sample data at every run
  def all_matches
    b = GenerateBets.new(1, 1, 40)
    # ap b.generate_sameple
    return b.generate_sameple
  end

end


b = BetMatching.new()
b.proccess
