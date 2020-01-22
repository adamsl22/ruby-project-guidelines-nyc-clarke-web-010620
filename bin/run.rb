require_relative '../config/environment'
require 'pry'

ActiveRecord::Base.logger = nil




def begin_game


#clear database
Dragon.delete_all
RaidPairing.delete_all
Raid.delete_all
Village.delete_all

##Setup Turn Clock
turn = GameEvent.gameclock

## BUILD MENUS HERE
main_menu_ui = UI.new("main_menu_ui")
main_menu_ui.menu_items =["[1] - Create a Dragon", "[2] - View Dragons      ", "[3] - Check Human Population", "   [4] - Create a Raid", "[5] - Pass", ""]
main_menu_ui.header = "                     Dragon Maker - Turn # #{turn}"
main_menu_ui.body = "           Number of Dragons:".blue
main_menu_ui.has_border = true
main_menu_ui.has_divider = true
main_menu_ui.border_type = "dash-lg"
main_menu_ui.parent_menu = main_menu_ui
#1 create_dragon method creates this menu

#2
view_dragons_ui = UI.new("view_dragons_ui")
view_dragons_ui.menu_items = ["[back] to go back", ""]
view_dragons_ui.header = "                          YOUR DRAGONS".blue
view_dragons_ui.body = "\n   No dragons have been created...\n".blue
view_dragons_ui.has_border =  true
view_dragons_ui.border_type = "squiggles-md"
view_dragons_ui.has_divider = true
view_dragons_ui.parent_menu = main_menu_ui

#3
view_humans_ui = UI.new("view_humans_ui")
view_humans_ui.menu_items = ["[back] to go back", ""]
view_humans_ui.header = "                          VILLAGES".blue
view_humans_ui.body = "\n   No humans exist...\n".blue
view_humans_ui.has_border =  true
view_humans_ui.border_type = "squiggles-md"
view_humans_ui.has_divider = true
view_humans_ui.parent_menu = main_menu_ui

#4
create_raid_ui = SelectionMenu.new("create_raid_ui")
create_raid_ui.menu_items = ["", ""]
create_raid_ui.header = "                          CREATE RAID"
create_raid_ui.body = "\n   You have not created any dragons.\n".blue
create_raid_ui.has_border =  true
create_raid_ui.border_type = "carrot-md"
create_raid_ui.has_divider = true
create_raid_ui.layout_type = "vertical"
create_raid_ui.parent_menu = main_menu_ui
create_raid_ui.question_prompt = "Choose dragons for your raid. "





## put this into UI





##CREATE LOGIC HERE
pass = lambda {UI.announce("You chose to rest for a turn.")}
main_menu_ui.set_logic(method(:create_dragon), view_dragons_ui.method(:prompt), view_humans_ui.method(:prompt) , create_raid_ui.method(:prompt), pass)

test = lambda {make_choice(1, create_raid_ui,chosen)}
test2 = lambda {make_choice(2, create_raid_ui,chosen)}
test3 = lambda {make_choice(3, create_raid_ui,chosen)}
test4 = lambda {make_choice(4, create_raid_ui,chosen)}
test5 = lambda {make_choice(5, create_raid_ui,chosen)}
test6 = lambda {make_choice(6, create_raid_ui,chosen)}
test7 = lambda {make_choice(7, create_raid_ui,chosen)}
test8 = lambda {make_choice(8, create_raid_ui,chosen)}
test9 = lambda {make_choice(9, create_raid_ui,chosen)}
create_raid_ui.set_logic(test, test2, test3, test4, test5, test6, test7, test8, test9)  

## make choice, once you make that choice that choice either turns green or turns black again.. also adds it to your chosen
## dragons that will be carried to the next part of the raid.



##SETUP GAME EVENTS HERE
GameEvent.new(Village.method(:first_village), 3, "")
# GameEvent.new(nil, 3, ) #will need to run the method "Village.first_village"
# GameEvent.new(nil, 30, "THE VILLAGES ARE GETTING STRONGER... better watch yourself.")
# GameEvent.new(nil, 40, "Testing")





## begin game  
system("clear")
Village.nomads

UI.billboard("WELCOME TO DRAGON MAKER!")
UI.ask_for_enter

## MAIN GAME LOOP
i = 0
while i < 999
    Village.population_growth(turn)
    Village.new_village(turn)
    Village.knights(turn)
    Village.slayers(turn)
    Dragon.add_hunger
    Dragon.recovery
    create_raid_ui.clear_chosen
    create_raid_ui.clear_menu_items 
    create_raid_ui.update_menu_items(Dragon.available_dragons)


    ## REGENERATE MENUS
    turn = GameEvent.gameclock
    main_menu_ui.header = "                     Dragon Maker - Turn # #{turn}"  
    main_menu_ui.body = "       Number of Dragons: #{Dragon.all.count}      Number of Villages: #{Village.all.count} \n".blue
    view_dragons_ui.body = Dragon.list_dragons
    view_humans_ui.body = Village.list_villages


    ##THIS WILL EVENTUALLY BE A CLASS METHOD

    ###############


    ## START TURN
    main_menu_ui.prompt

    #binding.pry
    ###calculate game

    ##RECAP TURN
    UI.blank_space(5)
    #UI.announce("Turn #{turn} is over! Let's see how you fared...")
    UI.blank_space(5)
    GameEvent.weeks_summary(turn) #function that puts out the weeks events
    UI.ask_for_enter
    UI.blank_space(5)


    ##INCREMENT GAME CLOCK AND MOVE TO NEXT WEEK
    GameEvent.increment_game_clock(1)
    i += 1
end

puts "Thanks for playing Dragon Maker!"
end

def create_dragon
    
    dragon_name = UI.simple_question("Name your dragon:")
    UI.blank_space(5)
    dragon_wingspan = UI.simple_question("What is your dragon's wingspan?")
    UI.blank_space(5)
    dragon_color = UI.simple_question("What color is your dragon?")
    UI.blank_space(5)
    dragon_pattern = UI.simple_question("What pattern is your dragon?")


    Dragon.create(name: dragon_name, wing_span: dragon_wingspan, color: dragon_color, pattern: dragon_pattern, hunger: 0, health: "Healthy")
    ## create instance of boris here
    ## create game event here #will need a week 
    puts "#{dragon_name} has been created!"
end

def create_raid(dragon_selections)
    ##dragon_selections is an array of dragon objects
    ##create a raid object
end

begin_game