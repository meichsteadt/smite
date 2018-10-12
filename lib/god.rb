class God
  @@gods_hash = {}
  @@name_hash = {}
  @@gods = []

  attr_reader(:name, :abilities, :role, :id, :img)
  def initialize(params)
    @name = params[:name]
    @abilities = params[:abilities]
    @role = params[:role]
    @id = params[:id]
    @img = params[:img]
  end

  def num_roots
    count = 0
    self.abilities.each do |ability|
      if ability["Description"]["itemDescription"]["rankitems"].map {|e| e["description"]}.include?('Root Duration:')
        count += 1
      end
    end
    count
  end

  def num_stuns
    count = 0
    self.abilities.each do |ability|
      if ability["Description"]["itemDescription"]["rankitems"].map {|e| e["description"]}.include?('Stun Duration:')
        count += 1
      end
    end
    count
  end

  def num_slows
    count = 0
    self.abilities.each do |ability|
      if ability["Description"]["itemDescription"]["rankitems"].map {|e| e["description"]}.include?('Slow Duration:')
        count += 1
      end
    end
    count
  end

  def self.find(id)
    @@gods_hash[id]
  end

  def self.find_by_name(name)
    @@name_hash[name]
  end

  def self.all
    @@gods
  end

  def self.create_gods(gods)
    gods_hash = {}
    name_hash = {}
    gods.each do |god|
      abilities = [god["Ability_1"], god["Ability_2"], god["Ability_3"], god["Ability_4"]]
      new_god = God.new({name: god["Name"], abilities: abilities, role: god["Roles"].strip, id: god["id"], img: god["godCard_URL"]})
      gods_hash[god["id"]] = new_god
      name_hash[god["Name"]] = new_god
      @@gods << new_god
    end
    @@gods_hash = gods_hash
    @@name_hash = name_hash
  end
end
