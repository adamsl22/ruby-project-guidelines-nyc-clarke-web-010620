class SelectionMenu < UI
    
    
    def initialize(menu_title)
        super
        @chosen = []
        @selected = []
        @village_chosen = ""
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

            @chosen.each {|chose| puts "your chosen items #{chose}"}
            @selected = []
            Dragon.all.each do |dragon|
               
                @chosen.each do |chose|
                    if dragon.name == chose.uncolorize.split("[")[0] #can I use .strip here?
                        @selected << dragon
                    end
                end
            end

            puts @selected
            @selected.each do |dragon|
                puts "You have chosen #{dragon.name} for your raid."
            end

            #need a Choose Village prompt...
            self.update_menu_items_village(Village.all)
            village_prompt

            #binding.pry
            
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


def make_one_choice(num_input)
    village_string = self.menu_items[num_input - 1 ].split(" - ")[1]
    
    @village_chosen = Village.all.find do |village| 
        village_string == village.name
     end
end


def update_menu_items(new_items_array)
    #binding.pry
    if new_items_array == nil
        @body = "You have no dragons available to raid." 
    else
        @body = "\nSelect your Dragons and then type 'done' to create your raid.\n "
        @question_prompt = "Choose your Dragons."
        @menu_items.each_with_index do |item, index|
            menu_items[index] = ""
        end
        new_items_array.each_with_index do |new_item, index|
            @menu_items[index] = "[#{index + 1}] - #{new_item.name}"
        end
        #binding.pry
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


def clear_menu_items
        @menu_items.each_with_index do |item, index|
            menu_items[index] = ""
        end
end

def clear_choices
    self.menu_items = self.menu_items.map do |item|
        item = item.black
    end
    self.prompt
end

def village_prompt
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
            get_input(input)
            
        else
            input = input.to_i
            make_one_choice(input)
        end


            #should create the raid.

            dice = [1,2,3,4,5,6]
            new_raid = Raid.create(village_id: @village_chosen.id, dice_roll: dice.sample)
            @selected.each do |dragon|
                new_pairing = RaidPairing.create(raid_id: new_raid.id, dragon_id: dragon.id)
            end
            puts "Your raid has begun!"
            puts "Dice roll: #{new_raid.dice_roll}"
            new_raid.result

        end

end