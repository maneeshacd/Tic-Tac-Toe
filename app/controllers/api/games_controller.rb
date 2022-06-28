
module Api
  class GamesController < ApplicationController
    def create
      @game = Game.create()
      if @game.persisted?
        render_success_json(@game)
      else
        render_error_state(@game.errors, :bad_request)
      end
    end

    def update
      @game = Game.find_by(id: game_params[:id])
      if @game.update(game_params)
        render_success_json(@game)
      else
        render_error_state(@game.errors, :bad_request)
      end
    end

    private

    def game_params
      params.require(:game).permit(:id, :status)
    end
  end
end
