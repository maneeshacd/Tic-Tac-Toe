class FindWinnerService
  def initialize(params)
    @game_player = params[:game_player]
    @position_info_params = params[:position_info_params]
    @winner = nil
  end

  def call
    winner
  end

  private

  def winner
    @game_player.moves.push(@position_info_params)
    @game_player.save!
    return if @game_player.moves.count < 3

    diagonal_down_count = 0
    diagonal_up_count = 0
    for i in 0..2
      row_count = 0
      col_count = 0
      diagonal_up_index = 2 - i
      @game_player.moves.each do |move|
        diagonal_down_count += 1 if move['row'] == i && move['col'] == i
        diagonal_up_count += 1 if move['row'] == diagonal_up_index && move['col'] == i
        row_count += 1 if move['row'] == i
        col_count += 1 if move['col'] == i
                  # binding.pry
        if diagonal_up_count == 3 || diagonal_down_count == 3 || col_count == 3 || row_count == 3
          # binding.pry
          player = @game_player.player
          @winner = player
          @game_player.winner = true
        end
      end
    end
    @game_player.save!
    @winner
  end
end
