require 'pry'
class Tournament
  attr_reader :games
  def initialize(games)
    @games = games
  end
  
  def self.tally(games)
    tournament = Tournament.new(games)
    tournament.process_games
    tournament.format_table
    # binding.pry
    # expected = <<-TALLY.gsub(/^ */, '')
    #   Team                           | MP |  W |  D |  L |  P
    #   Devastating Donkeys            |  3 |  2 |  1 |  0 |  7
    #   Allegoric Alaskans             |  3 |  2 |  0 |  1 |  6
    #   Blithering Badgers             |  3 |  1 |  0 |  2 |  3
    #   Courageous Californians        |  3 |  0 |  1 |  2 |  1
    # TALLY
  end
  
  def format_table
    # result is sorted by points
    team = Team.find_by_name("Devastating Donkeys")
    table = <<-TABLE.gsub(/^ */, '')
      Team                           | MP |  W |  D |  L |  P
      Devastating Donkeys            |  3 |  2 |  1 |  0 |  7
      Allegoric Alaskans             |  3 |  2 |  0 |  1 |  6
      Blithering Badgers             |  3 |  1 |  0 |  2 |  3
      Courageous Californians        |  3 |  0 |  1 |  2 |  1
    TABLE
    [
     "Team                           | MP |  W |  D |  L |  P",
     "Devastating Donkeys            |  #{team.games_played} |  #{team.wins} |  #{team.draws} |  #{team.losses} |  #{team.points}"
    ]
    binding.pry
    # a = "Team                           | MP |  W |  D |  L |  P"
    # b = "Devastating Donkeys            |  #{team.games_played} |  #{team.wins} |  #{team.draws} |  #{team.losses} |  #{team.points}"
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
        team_1.draw
        team_2.draw
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
  attr_reader :name, :wins, :draws, :losses
  def initialize(name)
    @name = name
    @@teams << self
    @wins = 0
    @losses = 0
    @draws = 0
  end
  
  def win
    @wins += 1
  end
  
  def loss
    @losses += 1
  end
  
  def draw
    @draws += 1
  end
  
  def points
    @wins * 3 + @draws
  end
  
  def games_played
    @wins + @losses + @draws
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
# format output
