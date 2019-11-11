require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @my_grid = generate_grid(10)
    @letters = ''
    @my_grid.each do |letter|
      @letters += letter + ' '
    end
    @start_time = Time.now.to_i
  end

  def score
    @response = params[:myword]
    @my_grid = params[:mygrid].split('')
    @start_time = params[:startime].to_i
    @end_time = Time.now.to_i
    @time = @end_time - @start_time
    @dico_result = run_game(@response, @my_grid, @start_time, @end_time)
    @your_score = @dico_result[:score]
    @message =  @dico_result[:message]
  end
end

def generate_grid(grid_size)
  # TODO: generate random grid of letters
  my_grid = []
  my_grid << ('A'..'Z').to_a.sample while my_grid.size < grid_size
  my_grid
end

def run_game(attempt, grid, start_time, end_time)
  # TODO: runs the game and return detailed hash of result
  # game_result = { score: 0, message: "not in the grid !" }
  # je verifie que la saisie correspond bien a la grille
  my_grid = grid
  saisie = attempt.upcase.split('')
  saisie.each do |lettre|
    my_index = my_grid.index(lettre)
    my_grid.index(lettre).nil? ? (return { score: 0, message: 'not in the grid !' }) : my_grid.delete_at(my_index)
  end
  dico_consultation(attempt, start_time, end_time)
end

def dico_consultation(attempt, start_time, end_time)
  url = 'https://wagon-dictionary.herokuapp.com/' + attempt
  web_obj = open(url).read
  reponseweb = JSON.parse(web_obj)

  if reponseweb["found"]
    return { score: attempt.length - (end_time - start_time) / 30, message: 'Well Done!' }
  else
    return { score: 0, message: 'not an english word !' }
  end
end
