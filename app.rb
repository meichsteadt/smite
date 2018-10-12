require 'rest-client'
require 'pry'
require 'dotenv'
require './lib/api'
require './lib/god'
require './lib/player'
require 'date'

def get_player_info(player_id, api, party_id, god_id)
  player_info = api.get_player(player_id)[0]
  played_since = player_info["Created_Datetime"].split(" ")[0]
  god_ranks = api.get_god_ranks(player_id)
  wl = "#{player_info['Wins']}/#{player_info['Losses']}"
  player = Player.new({name: player_info["Name"], wl: wl, level: player_info["Level"], mastered: player_info['MasteryLevel'], played_since: played_since, god_ranks: god_ranks, party_id: party_id, clan: player_info["Team_Name"]})
  {"player": player.show_info, "god_info": player.god_info(god_id.to_s)}
end

def init(player_name)
  api = Api.new()
  api.create_session
  gods = api.gods
  God.create_gods(gods)
  match_id = api.get_match_history(player_name)[0]["Match"]
  binding.pry
  match = api.get_match_details(match_id)
  players = []
  match.each do |player|
    players << get_player_info(player["playerId"], api, player["PartyId"], player["GodId"])
  end
  players
end

puts init("rascallywand6")
