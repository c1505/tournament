class Tournament
  attr_reader :games
  def initialize(games)
    @games = games
  end
  
  def self.tally(games)
    Team.reset
    tournament = Tournament.new(games)
    tournament.process_games
    tournament.format_table
  end
  
  def format_table
    teams = Team.all.sort_by {|team| team.points}.reverse
    table = teams.map do |team|
      padding_length = 31 - team.name.length
      padding = " " * padding_length
      "#{team.name}#{padding}|  #{team.games_played} |  #{team.wins} |  #{team.draws} |  #{team.losses} |  #{team.points}"
    end
    table.unshift("Team                           | MP |  W |  D |  L |  P")
    table[-1] = table[-1] + "\n"
    table.join("\n")
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
  
  def self.reset
    @@teams =[]
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

module BookKeeping
  VERSION = 1
end