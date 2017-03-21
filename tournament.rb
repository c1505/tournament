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
  

  
  def process_games
    create_teams
    @games.split("\n").each do |game|
      game = game.split(";")
      team_1 = Team.find_by_name(game[0])
      team_2 = Team.find_by_name(game[1])
      if game[2] == "win"
        team_1.win
        team_2.loss
      elsif game[2] == "loss"
        team_1.loss
        team_2.win
      else
      end
    end
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
  
    
end

class Team
  @@teams ||= []
  attr_reader :name
  def initialize(name)
    @name = name
    @@teams << self
    @wins = 0
    @losses = 0
    # @draws
    # @points
    # @games_played
  end
  
  def win
    @wins += 1
  end
  
  def loss
    @losses += 1
  end
  
  def self.all
    @@teams
  end
  
  def self.team_names
    @@teams.map {|team| team.name}
  end
  
  def self.find_by_name(name)
    @@teams.find {|team| team.name == name}
  end
end
# handle input
# turn into something i want to use
# perform calculation

