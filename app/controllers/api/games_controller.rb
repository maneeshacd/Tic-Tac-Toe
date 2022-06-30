
module Api
  class GamesController < ApplicationController

    def index
      @games = Game.includes(game_players: :player)
    end

    def create
      @game = Game.create()
    end

    def update
      @game = Game.find_by(id: game_params[:id])
    end

    private

    def game_params
      params.require(:game).permit(:id, :status)
    end
  end
end
