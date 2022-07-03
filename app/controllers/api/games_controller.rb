# frozen_string_literal: true

module Api
  class GamesController < ApplicationController
    def index
      @games = Game.includes(game_players: :player)
    end

    def create
      @game = Game.create
    end

    def update
      @game = Game.find(game_params[:id])
      @updated = @game.update(game_params)
    end

    private

    def game_params
      params.require(:game).permit(:id, :status)
    end
  end
end
