class Player
  attr_reader(:wl, :party_id, :level, :name, :played_since, :god_ranks, :mastered)
  def initialize(params)
    @kda = params[:kda]
    @wl = params[:wl]
    @party_id = params[:party_id]
    @clan = params[:clan]
    @level = params[:level]
    @name = params[:name]
    @played_since = params[:played_since]
    @god_ranks = params[:god_ranks]
  end

  def god_info(god_id)
    index = @god_ranks.map {|e| e["god_id"]}.find_index(god_id)
    god = @god_ranks[index]
    kda = (god["Kills"].to_f + (god["Assists"]/2)) / god["Deaths"]
    wins = god['Wins']
    losses = god['Losses']
    {name: god["god"], rank: god["Rank"], worshippers: god["Worshippers"], kda: kda, wl: "#{wins}/#{losses} (#{(wins.to_f/(losses.to_f + wins.to_f) * 100).round(2)})%"}
  end

  def show_info
    {name: @name, wl: @wl, level: @level, clan: @clan, party_id: @party_id}
  end


end
