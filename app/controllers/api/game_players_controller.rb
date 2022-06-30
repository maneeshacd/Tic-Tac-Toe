
module Api
  class GamePlayersController < ApplicationController
    def create
      @player = Player.find_or_create_by(player_params)
      @player.active!
      @game_player =
        GamePlayer.create(game_player_params.merge(player: @player))
      @game_player.activate_game if @game_player.persisted?
    end

    def movement
      @game_player = GamePlayer.find(params[:id])
      @winner = FindWinnerService.new(
        game_player: @game_player, position_info_params: position_info_params
      ).call
    rescue ActiveRecord::ActiveRecordError => e
      render_error_state(e, :bad_request)
    end

    private

    def player_params
      params.permit(:name)
    end

    def game_player_params
      params.permit(:game_id, :symbol)
    end

    def position_info_params
      params.require(:position_info).permit(:row, :col, :player)
    end
  end
end
