class CreateGamePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :game_players do |t|
      t.belongs_to :game
      t.belongs_to :player
      t.boolean :winner, default: false
      t.column :symbol, 'char(1)'
      t.json :moves, array: true, default: []
      t.timestamps
    end
  end
end
