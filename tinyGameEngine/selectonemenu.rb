class SelectOneMenu < UI
    
def initialize(menu_title)
        super
        @chosen = []
        @village_chosen = ""
end

def visual 
    i = 0
    while i < (menu_items.count)
        
        puts "   #{menu_items[i]}"
        i += 1
    end 
end

def prompt  
    update_menu_items_village(Village.all)
    ##will reprompt the menu this time with all villages
    ## then will create the raid finally
        UI.blank_space(5)
        build_border
        if @has_border 
            puts border_visual
        end
        puts @header
        if @has_divider
            puts border_visual
        end
        if @body.class == Method
        puts @body.call
        else
        puts @body
        end
        self.visual
        if @has_border
            puts border_visual
        end
        if @question_prompt.class == String
        puts @question_prompt
        elsif @question_prompt.class == Array
            @question_prompt.each do |ele|
                puts ele
            end
        end
        # get input from player

        input = gets.chomp

            if input == "back" || input == "quit" || input == "h" || input == "help"||input == "-h"
                #get_input(input)
            elsif input.to_i == 0 || input.to_i > menu_items.count || input == nil || input == ""
                puts "Option not available.".red
                self.prompt
            else
                input = input.to_i
                make_one_choice(input)
                # clear_chosen
                # empty_array_menu_items
            end


            #raid created
            dice = [1,2,3,4,5,6]
            new_raid = Raid.create(village_id: @village_chosen.id, dice_roll: dice.sample)
            SelectionMenu.selected.each do |dragon|
                new_pairing = RaidPairing.create(raid_id: new_raid.id, dragon_id: dragon.id)
            end
            UI.announce("Your raid has begun!", "blue")
            if new_raid.dice_roll < 3
                UI.announce("Dice roll: #{new_raid.dice_roll}", "red")
            elsif new_raid.dice_roll > 4
                UI.announce("Dice roll: #{new_raid.dice_roll}", "green")
            else
                UI.announce("Dice roll: #{new_raid.dice_roll}", "blue")
            end
            new_raid.result
            SelectionMenu.clear_selected
        end
end


def make_one_choice(num_input)
    if num_input > self.menu_items.count || num_input == "" || num_input == nil || num_input == 0
        self.prompt
    else
    village_string = self.menu_items[num_input - 1 ].split(" - ")[1]
        @village_chosen = Village.all.find do |village| 
            village_string == village.name
        end
    end
end


def update_menu_items_village(new_items_array)
    ##regenerate same menu with the village items...
    if new_items_array == nil
        @body = "There are no Villages to attack." 
    else
        @menu_items.each_with_index do |item, index|
            menu_items[index] = ""
        end
        @body = "\nSelect the Village you want to attack.\n "
        @question_prompt = "Choose a Village for your raid."
        new_items_array.each_with_index do |new_item, index|
            menu_items[index] = "[#{index + 1}] - #{new_item.name}"
        end
    end


    
end