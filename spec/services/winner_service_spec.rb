require 'rails_helper'

RSpec.describe WinnerService, type: :service do
  describe '.call' do
    context 'player not won' do
      let(:game) { create(:game) }
      let(:player) { create(:player) }
      let(:game_player) { create(:game_player, game:, player:) }
      let(:position_info_params) do
        { row: 0, col: 0, player: 'X' }
      end

      it 'returns nil' do
        winner = WinnerService.new(game_player, position_info_params).call
        expect(winner).to eq(nil)
      end
    end
    context 'player won' do
      let(:game) { create(:game) }
      let(:player) { create(:player) }
      let(:game_player) { create(:game_player, game:, player:) }
      let(:position_info_params) do
        { row: 0, col: 0, player: 'X' }
      end

      it 'returns true if player won' do
        game_player.moves <<
          { row: 1, col: 1, player: 'X' } << { row: 2, col: 2, player: 'X' }
        winner = WinnerService.new(game_player, position_info_params).call
        expect(winner).to eq(player)
      end
    end

    # it 'provides the readings in queue' do
    #   expect(result.readings).to be_an_instance_of(Array)
    #   expect(result.readings).to eql([reading_params.as_json])
    #   Sidekiq::Queue.new('testing').clear
    # end

    # context 'when items empty in queue' do
    #   it 'fails' do
    #     expect(result).to be_a_failure
    #   end

    #   it 'provides a empty readings array' do
    #     expect(result.readings).to be_empty
    #   end
    # end
  end
end
