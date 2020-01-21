require_relative './config/environment'
require 'pry'



a = Dragon.create(name: "Darius", wing_span: "12", color: "Blue", pattern: "Test", health: "Healthy", hunger: 16 )
v = Village.create(name: "Village 1", population: 30, knights: 15, slayers: 1)
test_raid8 = Raid.create(village_id: 1, dice_roll: 4)
rg = RaidPairing.create(dragon_id: 5, raid_id: 8)

# test_raid.result
binding.pry