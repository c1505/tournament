class Tournament
  attr_reader :games
  def initialize(games)
    @games = games
  end
  
  def self.tally(games)
    Tournament.new(games)
    expected = <<-TALLY.gsub(/^ */, '')
      Team                           | MP |  W |  D |  L |  P
      Devastating Donkeys            |  3 |  2 |  1 |  0 |  7
      Allegoric Alaskans             |  3 |  2 |  0 |  1 |  6
      Blithering Badgers             |  3 |  1 |  0 |  2 |  3
      Courageous Californians        |  3 |  0 |  1 |  2 |  1
    TALLY
  end
  
  def team_list
    @games.split("\n").map do |game|
      game_arr = game.split(";")
      [ game_arr[0], game_arr[1] ]
    end.flatten.uniq
  end
  
  def create_teams
    team_list.each do |team|
      Team.new(team)
    end
  end
  
  
      
  
  # def process_games
  #   hash = {}
  #   @games.split("\n").each do |game|
  #     if game[2] == "win"
  #       hash[game[0] 
    
end

class Team
  attr_reader :name
  def initialize(name)
    @name = name
    @@teams ||= []
    @@teams << self
    # @wins
    # @losses
    # @draws
    # @points
    # @games_played
  end
  
  def self.teams
    @@teams
  end
  
  def self.team_names
    @@teams.map {|team| team.name}
  end
end
# handle input
# turn into something i want to use
# perform calculation

