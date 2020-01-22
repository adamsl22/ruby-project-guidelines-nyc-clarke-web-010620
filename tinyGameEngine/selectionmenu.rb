class SelectionMenu < UI
    
    
    def initialize(menu_title)
        super
        @chosen = []
    end


    def prompt
        #this will puts out the visual
        #then will get input and return it
        #will make sure input is not blank
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
            get_input(input)
        elsif input == "done"
            ##This is where I need to return the array...
            ##If Dragon.health > 0
            ##Initialize 
            ##
            chosen.each {|chose| puts chose}
            selected = Dragon.all.select do |dragon|
                @chosen.each do |chose|
                    dragon.name == chose.uncolorize.split("[")[0]
                end
            end

            puts selected
            selected.each do |dragon|
                puts "You've chosen #{dragon.name} for your raid."
            end

            #Choose your village
            dice = [1,2,3,4,5,6]
            new_raid = Raid.create(village_id: selected_village.id, dice_roll = dice.sample)
            selected.each do |dragon|
                new_pairing = RaidPairing.create(raid_id: new_raid.id, dragon_id: dragon.id)
            end
            puts "Your raid has begun!"
            puts "Dice roll: #{new_raid.dice_roll}"
            new_raid.result
            
        elsif input == "clear"
            clear_choices
        else
            input = input.to_i
            make_choice(input)
        end
        
        # make decision using that input about what method to run
        # get_input(input)
        if @response
            puts @response
        end
        
        #self.get_input
    end

    def chosen
        @chosen
    end


def make_choice(num_input)
    #-1 from num input to get the element of the array
    self.menu_items[num_input - 1] = self.menu_items[num_input - 1].green
    ## also need to add this choice to the chosen dragons...

    @chosen << self.menu_items[num_input - 1 ].split(" - ")[1]
    @chosen.each {|c| puts c + " was added."}
    
    self.prompt
end

def update_menu_items(new_items_array)
    if new_items_array == nil
        @body = "You don't have any healthy dragons." 
    else
        new_items_array.each_with_index do |new_item, index|
            menu_items[index] = "[#{index + 1}] - #{new_item.name}"
        end
    end
end



def clear_choices
    self.menu_items = self.menu_items.map do |item|
        item = item.black
    end
    self.prompt
end

end