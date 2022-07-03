# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::GamePlayersController, type: :controller do
  render_views

  describe '#create' do
    context 'when successful' do
      let(:game) { create(:game) }
      let(:player) { build(:player) }
      let(:game_player) { build(:game_player, symbol: 'X') }

      let(:player_params) do
        {
          name: player.name
        }
      end

      let(:game_player_params) do
        {
          game_id: game.id,
          symbol: game_player.symbol
        }
      end

      it 'returns success json response' do
        resp =
          post :create,
               params: player_params.merge(game_player_params), format: :json
        expect(JSON.parse(resp.body).keys)
          .to eq(%w[game_player player success])
        expect(JSON.parse(resp.body)['player'].extract!('name', 'status'))
          .to eq({ 'name' => player.name, 'status' => 'active' })
        expect(
          JSON.parse(resp.body)['game_player']
              .extract!('game_id', 'symbol')
        ).to eq({ 'game_id' => game.id, 'symbol' => 'X' })
      end
    end

    context 'when unsuccessful' do
      let(:game) { create(:game) }
      let(:player) { build(:player) }
      let(:game_player) { build(:game_player, symbol: 'X') }

      let(:player_params) do
        {
          name: player.name
        }
      end

      let(:game_player_params) do
        {
          game_id: game.id,
          symbol: 'Y'
        }
      end

      it 'returns error as json response' do
        resp =
          post :create,
               params: player_params.merge(game_player_params), format: :json
        expect(JSON.parse(resp.body))
          .to eq(
            {
              'errors' => { 'symbol' => ['Y is not a valid symbol'] },
              'success' => false
            }
          )
      end
    end
  end
  describe '#movement' do
    context 'when successful' do
      let(:game) { create(:game) }
      let(:player) { create(:player) }
      let(:game_player) do
        create(:game_player, symbol: 'X', game:, player:)
      end

      let(:position_info_params) do
        {
          row: 1, col: 1, player: 'X'
        }
      end

      it 'returns success json response' do
        resp =
          post :movement,
               params: {
                 id: game_player.id,
                 position_info: position_info_params
               },
               format: :json
        expect(JSON.parse(resp.body))
          .to eq(
            { 'winner' => nil, 'played_columns_count' => 1, 'success' => true }
          )
      end
    end

    context 'when unsuccessful' do
      let(:game) { create(:game) }
      let(:player) { create(:player) }
      let(:game_player) do
        create(:game_player, symbol: 'X', game:, player:)
      end

      let(:position_info_params) do
        {
          row: 1, col: 1, player: 'X'
        }
      end

      it 'returns success json response' do
        resp =
          post :movement,
               params: {
                 id: 123,
                 position_info: position_info_params
               }, format: :json
        expect(JSON.parse(resp.body))
          .to eq(
            {
              'success' => false,
              'error' => "Couldn't find GamePlayer with 'id'=123"
            }
          )
      end
    end
  end
end
