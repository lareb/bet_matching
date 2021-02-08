#  The core functionality of this script is to create multiple bets
# Each bet are present in a hierarchy
# Matches > Markets > Bets

require "awesome_print"
require 'logger'
require 'json'
require 'whenever'
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
    @path = "/home/rails/workspace/matching_bets"
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
    File.delete("#{@path}/logs/bets.log")
    log = Logger.new("#{@path}/logs/bets.log")
    log.level = Logger::INFO

    all_matches = create_matches
    # all_matches = example_feed
    log.info JSON.pretty_generate(all_matches)

    return all_matches
  end

  # generate sample records
  def sample_matches
    return "#{TEAM_A.sample} vs #{TEAM_B.sample} #{MATCH_TYPE.sample} tournament"
  end

  def example_feed

    return [
      {
        id: 100,
        name: "NDL vs BAN hockey tournament",
        markets: [
          {
            id: 200,
            title: "market_0",
            bets: [
              {
                id: 30000,
                user_id: 53,
                bet_amount: 98,
                type: :lay,
                odds: 2.4,
                unmatched_amount: 98,
                status: "not_matched"
              },
              {
                id: 30001,
                user_id: 97,
                bet_amount: 50,
                type: :back,
                odds: 2.3,
                unmatched_amount: 50,
                status: "not_matched"
              },
              {
                id: 30002,
                user_id: 50,
                bet_amount: 46,
                type: :back,
                odds: 2.3,
                unmatched_amount: 46,
                status: "not_matched"
              },
              {
                id: 30003,
                user_id: 30,
                bet_amount: 27,
                type: :back,
                odds: 2.4,
                unmatched_amount: 27,
                status: "not_matched"
              },
              {
                id: 30004,
                user_id: 82,
                bet_amount: 42,
                type: :back,
                odds: 2.5,
                unmatched_amount: 42,
                status: "not_matched"
              },
              {
                id: 30005,
                user_id: 10,
                bet_amount: 91,
                type: :back,
                odds: 2.4,
                unmatched_amount: 91,
                status: "not_matched"
              },
              {
                id: 30006,
                user_id: 99,
                bet_amount: 57,
                type: :back,
                odds: 2.5,
                unmatched_amount: 57,
                status: "not_matched"
              },
              {
                id: 30007,
                user_id: 51,
                bet_amount: 92,
                type: :lay,
                odds: 2.6,
                unmatched_amount: 92,
                status: "not_matched"
              },
              {
                id: 30008,
                user_id: 39,
                bet_amount: 47,
                type: :back,
                odds: 2.5,
                unmatched_amount: 47,
                status: "not_matched"
              },
              {
                id: 30009,
                user_id: 25,
                bet_amount: 37,
                type: :lay,
                odds: 2.5,
                unmatched_amount: 37,
                status: "not_matched"
              },
              {
                id: 30010,
                user_id: 45,
                bet_amount: 52,
                type: :lay,
                odds: 2.6,
                unmatched_amount: 52,
                status: "not_matched"
              },
              {
                id: 30011,
                user_id: 45,
                bet_amount: 51,
                type: :back,
                odds: 2.5,
                unmatched_amount: 51,
                status: "not_matched"
              },
              {
                id: 30012,
                user_id: 58,
                bet_amount: 32,
                type: :back,
                odds: 2.4,
                unmatched_amount: 32,
                status: "not_matched"
              },
              {
                id: 30013,
                user_id: 100,
                bet_amount: 68,
                type: :lay,
                odds: 2.4,
                unmatched_amount: 68,
                status: "not_matched"
              },
              {
                id: 30014,
                user_id: 20,
                bet_amount: 83,
                type: :lay,
                odds: 2.6,
                unmatched_amount: 83,
                status: "not_matched"
              },
              {
                id: 30015,
                user_id: 23,
                bet_amount: 83,
                type: :back,
                odds: 2.6,
                unmatched_amount: 83,
                status: "not_matched"
              },
              {
                id: 30016,
                user_id: 53,
                bet_amount: 53,
                type: :back,
                odds: 2.4,
                unmatched_amount: 53,
                status: "not_matched"
              },
              {
                id: 30017,
                user_id: 58,
                bet_amount: 36,
                type: :lay,
                odds: 2.5,
                unmatched_amount: 36,
                status: "not_matched"
              },
              {
                id: 30018,
                user_id: 17,
                bet_amount: 71,
                type: :lay,
                odds: 2.3,
                unmatched_amount: 71,
                status: "not_matched"
              },
              {
                id: 30019,
                user_id: 13,
                bet_amount: 16,
                type: :back,
                odds: 2.5,
                unmatched_amount: 16,
                status: "not_matched"
              },
              {
                id: 30020,
                user_id: 49,
                bet_amount: 61,
                type: :lay,
                odds: 2.4,
                unmatched_amount: 61,
                status: "not_matched"
              },
              {
                id: 30021,
                user_id: 73,
                bet_amount: 20,
                type: :back,
                odds: 2.6,
                unmatched_amount: 20,
                status: "not_matched"
              },
              {
                id: 30022,
                user_id: 4,
                bet_amount: 88,
                type: :lay,
                odds: 2.6,
                unmatched_amount: 88,
                status: "not_matched"
              },
              {
                id: 30023,
                user_id: 51,
                bet_amount: 77,
                type: :back,
                odds: 2.5,
                unmatched_amount: 77,
                status: "not_matched"
              },
              {
                id: 30024,
                user_id: 87,
                bet_amount: 99,
                type: :lay,
                odds: 2.5,
                unmatched_amount: 99,
                status: "not_matched"
              },
              {
                id: 30025,
                user_id: 40,
                bet_amount: 83,
                type: :lay,
                odds: 2.6,
                unmatched_amount: 83,
                status: "not_matched"
              },
              {
                id: 30026,
                user_id: 61,
                bet_amount: 70,
                type: :lay,
                odds: 2.5,
                unmatched_amount: 70,
                status: "not_matched"
              },
              {
                id: 30027,
                user_id: 93,
                bet_amount: 76,
                type: :lay,
                odds: 2.4,
                unmatched_amount: 76,
                status: "not_matched"
              },
              {
                id: 30028,
                user_id: 11,
                bet_amount: 27,
                type: :lay,
                odds: 2.4,
                unmatched_amount: 27,
                status: "not_matched"
              },
              {
                id: 30029,
                user_id: 61,
                bet_amount: 48,
                type: :lay,
                odds: 2.5,
                unmatched_amount: 48,
                status: "not_matched"
              },
              {
                id: 30030,
                user_id: 76,
                bet_amount: 43,
                type: :lay,
                odds: 2.6,
                unmatched_amount: 43,
                status: "not_matched"
              },
              {
                id: 30031,
                user_id: 79,
                bet_amount: 93,
                type: :back,
                odds: 2.6,
                unmatched_amount: 93,
                status: "not_matched"
              },
              {
                id: 30032,
                user_id: 55,
                bet_amount: 81,
                type: :back,
                odds: 2.5,
                unmatched_amount: 81,
                status: "not_matched"
              },
              {
                id: 30033,
                user_id: 30,
                bet_amount: 75,
                type: :lay,
                odds: 2.4,
                unmatched_amount: 75,
                status: "not_matched"
              },
              {
                id: 30034,
                user_id: 25,
                bet_amount: 10,
                type: :lay,
                odds: 2.4,
                unmatched_amount: 10,
                status: "not_matched"
              },
              {
                id: 30035,
                user_id: 93,
                bet_amount: 11,
                type: :back,
                odds: 2.4,
                unmatched_amount: 11,
                status: "not_matched"
              },
              {
                id: 30036,
                user_id: 30,
                bet_amount: 87,
                type: :back,
                odds: 2.3,
                unmatched_amount: 87,
                status: "not_matched"
              },
              {
                id: 30037,
                user_id: 3,
                bet_amount: 41,
                type: :lay,
                odds: 2.6,
                unmatched_amount: 41,
                status: "not_matched"
              },
              {
                id: 30038,
                user_id: 31,
                bet_amount: 28,
                type: :lay,
                odds: 2.3,
                unmatched_amount: 28,
                status: "not_matched"
              },
              {
                id: 30039,
                user_id: 14,
                bet_amount: 28,
                type: :back,
                odds: 2.5,
                unmatched_amount: 28,
                status: "not_matched"
              }
            ]
          }
        ]
      }
    ]


  end

end
