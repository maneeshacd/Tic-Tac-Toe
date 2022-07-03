FactoryBot.define do
  factory(:player) do
    status { 0 }
    name { Faker::Name.name }
  end

  factory(:game) do
    status { 0 }
  end

  factory(:game_player) do
    association :player
    association :game
    game_id { Faker::Number.decimal }
    player_id { Faker::Number.decimal }
  end
end
