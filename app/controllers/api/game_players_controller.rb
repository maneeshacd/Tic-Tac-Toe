
module Api
  class GamePlayersController < ApplicationController
    def create
      @player = Player.find_or_create_by(player_params)
      @player.active!
      @game_player =
        GamePlayer.create(game_player_params.merge(player: @player))
      if @game_player.persisted?
        activate_game
        data = { player: @player, game_player: @game_player }
        render_success_json(data)
      else
        render_error_state(@game_player.errors, :bad_request)
      end
    end

    def movement
      @game_player = GamePlayer.find(params[:id])
      @winner = FindWinnerService.new(
        game_player: @game_player, position_info_params: position_info_params
      ).call
      data: { winner: @winner, played_columns_count: played_columns_count }
      render_success_json(data)
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

    def played_columns_count
      game = @game_player.game
      players = game.players
      GamePlayer.where(player_id: players.pluck(:id), game: game).pluck(:moves).flatten.count
    end

    def activate_game
      @game = Game.find_by(id: game_player_params[:game_id])
      @game.activate
    end

    def position_info_params
      params.require(:position_info).permit(:row, :col, :player)
    end
  end
end
