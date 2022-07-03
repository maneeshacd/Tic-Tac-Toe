# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::GamesController, type: :controller do
  render_views

  describe '#create' do
    context 'when successful' do
      let(:game) { build(:game) }

      it 'returns success json response' do
        resp =
          post :create,
               params: {},
               format: :json
        expect(JSON.parse(resp.body)['success']).to eq(true)
      end
    end
  end

  describe '#update' do
    context 'when successful' do
      let(:game) { create(:game) }
      let(:game_params) do
        {
          id: game.id,
          status: 'active'
        }
      end

      it 'returns success json response' do
        resp =
          get :update,
              params: {
                id: game.id,
                game: game_params
              }, format: :json

        expect(resp).to have_http_status(:ok)
        expect(JSON.parse(resp.body)['success']).to eq(true)
      end
    end

    context 'when unsuccessful' do
      let(:game) { create(:game) }
      let(:game_params) do
        {
          id: 123,
          status: 'active'
        }
      end

      it 'returns success json response' do
        resp =
          get :update,
              params: {
                id: 123,
                game: game_params
              }, format: :json
        expect(resp).to have_http_status(:not_found)
        expect(JSON.parse(resp.body)).to eq(
          {
            'success' => false, 'error' => 'Not found'
          }
        )
      end
    end
  end
end
