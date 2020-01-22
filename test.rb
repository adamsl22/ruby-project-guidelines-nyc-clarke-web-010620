require_relative './config/environment'
require 'pry'




b = Dragon.create(name: "Barius", wing_span: "12", color: "Blue", pattern: "Test", health: "Healthy", hunger: 16 )
c = Dragon.create(name: "Charius", wing_span: "12", color: "Blue", pattern: "Test", health: "Healthy", hunger: 16 )
a = Dragon.create(name: "Darius", wing_span: "12", color: "Blue", pattern: "Test", health: "Healthy", hunger: 16 )
#v = Village.create(name: "Village 1", population: 30, knights: 15, slayers: 1)
test_raid13 = Raid.create(village_id: 1, dice_roll: 3)
rg = RaidPairing.create(dragon_id: 5, raid_id: 13)





create_raid_ui = SelectionMenu.new("create_raid_ui")
create_raid_ui.menu_items = ["", ""]
create_raid_ui.header = "                          CREATE RAID"
create_raid_ui.body = "\n   You have not created any dragons.\n".blue
create_raid_ui.has_border =  true
create_raid_ui.border_type = "carrot-md"
create_raid_ui.has_divider = true
create_raid_ui.layout_type = "vertical"
create_raid_ui.question_prompt = "Choose dragons for your raid. "

binding.pry
create_raid_ui.update_menu_items(Dragon.available_dragons)

create_raid_ui.prompt
#test_raid6.result
binding.pry