#  The core functionality of this script is to create multiple bets
# Each bet are present in a hierarchy
# Matches > Markets > Bets

require "awesome_print"
require 'logger'
require 'json'
  # log.level = Logger::INFO

class GenerateBets
  TEAM_A = %w(IND pak aus SA SRL NL JP NDL SCT IT)
  TEAM_B = %w(BAN ZIM UAE HK US ENG ML INDS WE AFG)
  MATCH_TYPE = %W(football cricket hockey baseball)

  def initialize(matches = 1, markets = 1, bets = 1)
    @total_matches = matches
    @max_markets = markets
    @total_bets = bets
    @matches = []
  end

  def create_bets(match_index, market_index)
    # sample bet object
    # {id: 123, user_id: 456, bet_amount: 100, type: 'back', odds: 2.3}
    bets = []
    @total_bets.times do |i|
      user_id = (1..100).to_a.sample
      bet_amount = (10..100).to_a.sample
      odds = [2.3, 2.4, 2.5, 2.6]
      bets.push({
        id: "3#{match_index}#{market_index}00".to_i+i,
        user_id: user_id,
        bet_amount: bet_amount,
        type: [:back, :lay].sample,
        odds: odds.sample,
        unmatched_amount: bet_amount,
        status: "not_matched"
      })
    end

    return bets
  end

  # create sample markets between 1 to @max_market
  def create_markets(match_index)
    sample_total_market = (1..@max_markets).to_a.sample
    markets = []
    sample_total_market.times do |i|
      markets.push({id: "2#{match_index}0".to_i+i, title: "market_#{i}", bets: create_bets(match_index, i)})

    end

    return markets
  end

  # create sample matches
  def create_matches
    @total_matches.times do |i|
      @matches.push({id: 100+i,name: sample_matches, markets: create_markets(i)})
    end
    return @matches
  end

  def generate_sameple
    File.delete("bets.log")
    log = Logger.new("bets.log")
    log.level = Logger::INFO

    log.info "#{Time.now}============"
    all_matches = create_matches
    log.info JSON.pretty_generate(all_matches)

    return all_matches
  end

  # generate sample records
  def sample_matches
    return "#{TEAM_A.sample} vs #{TEAM_B.sample} #{MATCH_TYPE.sample} tournament"
  end

end
