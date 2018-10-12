require 'rest-client'
require 'pry'
require 'dotenv/load'
require 'json'

class Api
  attr_reader(:dev_id, :key, :session_id, :prefix)
  def initialize()
    @dev_id = ENV['devid']
    @key = ENV['authKey']
    @session_id = nil
    @prefix = "http://api.xbox.smitegame.com/smiteapi.svc"
  end

  def create_signature(method)
    string = "#{@dev_id}#{method}#{@key}#{self.timestamp}"
    md5 = Digest::MD5.new
    md5 << string
    md5.to_s
  end

  def create_session
    response = RestClient.get("#{@prefix}/createsessionJson/#{@dev_id}/#{self.create_signature('createsession')}/#{self.timestamp}")
    @session_id = JSON.parse(response)["session_id"]
  end

  def session_id=(session_id)
    @session_id = session_id
  end

  def timestamp
    return Time.now.getutc.strftime('%Y%m%d%H%M%S')
  end

  def get_match_ids_by_queue(queue_id = 426)
    response = RestClient.get("#{prefix}/getmatchidsbyqueueJson/#{@dev_id}/#{self.create_signature('getmatchidsbyqueue')}/#{@session_id}/#{self.timestamp}/#{queue_id}/#{self.date}/#{self.hour}")
    JSON.parse(response)
  end

  def get_match_details(match_id)
    response = RestClient.get("#{prefix}/getmatchdetailsJson/#{@dev_id}/#{self.create_signature('getmatchdetails')}/#{@session_id}/#{self.timestamp}/#{match_id}")
    JSON.parse(response)
  end

  def queue_id(name)
    queues = {"arena": 435, "conquest": 426, "clash": 466, "ranked": 451, "joust": 448}
    return queues[name]
  end

  def gods
    response = RestClient.get("#{prefix}/getgodsJson/#{@dev_id}/#{self.create_signature('getgods')}/#{@session_id}/#{self.timestamp}/1")
    gods = JSON.parse(response)
  end

  def get_player(player_name)
    response = RestClient.get("#{prefix}/getplayerJson/#{@dev_id}/#{self.create_signature('getplayer')}/#{@session_id}/#{self.timestamp}/#{player_name}")
    JSON.parse(response)
  end

  def get_god_ranks(player_name)
    response = RestClient.get("#{prefix}/getgodranksJson/#{@dev_id}/#{self.create_signature('getgodranks')}/#{@session_id}/#{self.timestamp}/#{player_name}")
    JSON.parse(response)
  end

  def get_match_history(player_name)
    response = RestClient.get("#{prefix}/getmatchhistoryJson/#{@dev_id}/#{self.create_signature('getmatchhistory')}/#{@session_id}/#{self.timestamp}/#{player_name}")
    JSON.parse(response)
  end

  def get_match_player_details(match_id)
    response = RestClient.get("#{prefix}/getmatchplayerdetailsJson/#{@dev_id}/#{self.create_signature('getmatchplayerdetails')}/#{@session_id}/#{self.timestamp}/#{match_id}")
    JSON.parse(response)
  end

  def date
    Time.now.strftime("%Y%m%d")
  end

  def hour
    Time.now.strftime("%H")
  end

end
