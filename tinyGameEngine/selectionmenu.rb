class SelectionMenu < UI
    
    @@selected = []
    
    def initialize(menu_title)
        super
        @chosen = []
        @village_chosen = ""

    end

    def self.selected
        @@selected
    end

    def visual 
            i = 0
            while i < (menu_items.count)
                
                puts "   #{menu_items[i]}"
                i += 1
            end 
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
            if @chosen == nil || @chosen == []
                self.prompt
            end
            @chosen.each {|chose| puts "your chosen items #{chose}"}
            @@selected = []
            Dragon.all.each do |dragon|
               
                @chosen.each do |chose|
                    if dragon.name == chose.uncolorize.split("[")[0] #can I use .strip here?
                        @@selected << dragon
                    end
                end
            end

            puts @@selected
            @@selected.each do |dragon|
                puts "You have chosen #{dragon.name} for your raid."
            end

            #goes to the village menu
            choose_village_ui = UI.all.find do |item|
                item.menu_title == "choose_village_ui"
            end
            choose_village_ui.prompt
            
        elsif input == "clear"
            clear_choices
        elsif input == ""
            self.prompt
        elsif input.to_i > menu_items.count || input.to_i == 0
                puts "option not available".red
                self.prompt
        else
            input = input.to_i
            make_choice(input)
            
        end
        
        # make decision using that input about what method to run
        # get_input(input)
        if @response
            puts @response
        end
    end

    def chosen
        @chosen
    end


def make_choice(num_input)
    #-1 from num input to get the element of the array
    if num_input > self.menu_items.count || num_input == "" || num_input == nil || num_input == "\n"
        self.prompt
    else
        self.menu_items[num_input - 1] = self.menu_items[num_input - 1].green
        @chosen << self.menu_items[num_input - 1 ].split(" - ")[1]
    end
    self.prompt
end


def update_menu_items(new_items_array)
    
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
        
    end
end

def clear_menu_items
        @menu_items = []
        # @menu_items.each_with_index do |item, index|
        #     menu_items[index] = []]
        # end
end

def empty_array_menu_items
    @menu_items = []
end

def clear_choices
    self.menu_items = self.menu_items.map do |item|
        item = item.black
    end
    @chosen = []
    self.prompt
end

def clear_chosen
    @chosen = []
end

end