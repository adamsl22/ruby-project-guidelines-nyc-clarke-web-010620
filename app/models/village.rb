class Village < ActiveRecord::Base
    has_many :raids

    def self.nomads
        nomads = Village.create(name: "Nomads", population: 30, knights: 0, slayers: 0)
    end

    def self.population_growth(turn)
        new_pop = 0
        Village.all.each do |village|
            if turn < 50
                new_pop = village.population + 0.15 * village.population
            elsif turn > 49 && turn < 100
                new_pop = village.population + 0.25 * village.population
            elsif turn > 99 && turn < 300
                new_pop = village.population + 0.35 * village.population
            else
                new_pop = village.population + 0.45 * village.population
            end
            village.update(population: new_pop.round)
        end
    end

    def self.first_village
        nomad_pop = nomads.population - 15
        nomads.update(population: nomad_pop)
        first_village = Village.create(name: "Primeton", population: 15, knights: 0, slayers: 0)
        puts "The people have founded the village of Primeton."
    end

    def self.most_populous_village
        Village.all.max_by do |village|
            village.population
        end
    end

    def self.new_village(turn)
        village_dice = [1,2,3]
        population_dice = [10,11,12,13,14,15,16,17,18,19,20]
        settlers = population_dice.sample
        vowels = ["a","e","i","o","u","y"]
        consonants = ["b","c","d","f","g","h","j","k","l","m","n","p","q","r","s","t","v","w","x","z"]
        name_array = [consonants.sample, vowels.sample, consonants.sample, consonants.sample, vowels.sample, consonants.sample, vowels.sample]
        name = name_array.join
        if turn > 5 && self.most_populous_village.population > 25 && village_dice.sample == 3
            settlers.times do
                settler_home = Village.all.sample
                if settler_home.population > 1
                    new_pop = settler_home.population - 1
                    settler_home.update(population: new_pop)
                end
            end
            new_village = Village.create(name: name.capitalize, population: settlers, knights: 0, slayers: 0)
            puts "The people have founded the village of #{new_village.name}."
        end
    end

    def self.knights(turn)
        knights_dice = [1,2,3,4,5]
        Village.all.each do |village|
            if village.knights > 0
                new_knight = village.knights + 1
                second_knight = village.knights + 2
                third_knight = village.knights + 3
                if turn < 50
                    if knights_dice.sample == 4 || knights_dice.sample == 5
                        village.update(knights: new_knight)
                    end
                elsif turn > 49 && turn < 100
                    if knights_dice.sample == 2 || knights_dice.sample == 3 || knights_dice.sample == 4 || knights_dice.sample == 5
                        village.update(knights: new_knight)
                    end
                elsif turn > 99 && turn < 200
                    village.update(knights: new_knight)
                    if knights_dice.sample == 4 || knights_dice.sample == 5
                        village.update(knights: second_knight)
                    end
                elsif turn > 199 && turn < 300
                    village.update(knights: new_knight)
                    if knights_dice.sample == 2 || knights_dice.sample == 3 || knights_dice.sample == 4 || knights_dice.sample == 5
                        village.update(knights: second_knight)
                    end
                elsif turn > 299 && turn < 400
                    village.update(knights: second_knight)
                    if knights_dice.sample == 4 || knights_dice.sample == 5
                        village.update(knights: third_knight)
                    end
                else
                    village.update(knights: second_knight)
                    if knights_dice.sample == 2 || knights_dice.sample == 3 || knights_dice.sample == 4 || knights_dice.sample == 5
                        village.update(knights: third_knight)
                    end
                end
            end
        end
    end

    def self.new_slayer
        slayer_home = Village.all.sample
        new_slayers = slayer_home.slayers + 1
        slayer_home.update(slayers: new_slayers)
        puts "Another slayer has emerged among the people."
    end

    def self.slayers(turn)
        slayers_dice = [1,2,3,4,5]
        if turn == 20
            slayer_home = Village.all.sample
            new_slayers = slayer_home.slayers + 1
            slayer_home.update(slayers: new_slayers)
            puts "The people are learning how to better kill dragons. A slayer has emerged who poses a grave threat!"
        elsif turn == 30 || turn == 40
            self.new_slayer
        elsif turn > 49 && turn < 100 && slayers_dice.sample == 5
            self.new_slayer
        elsif turn > 99 && turn < 200
            if slayers_dice.sample == 3 || slayers_dice.sample == 4 || slayers_dice.sample == 5
                self.new_slayer
            end
        elsif turn > 199 && turn < 300
            if slayers_dice.sample == 2 || slayers_dice.sample == 3 || slayers_dice.sample == 4 || slayers_dice.sample == 5
                self.new_slayer
            end
        elsif turn > 299 && turn < 400
            if slayers_dice.sample == 2 || slayers_dice.sample == 3 || slayers_dice.sample == 4 || slayers_dice.sample == 5
                self.new_slayer
            end
            if slayers_dice.sample == 4 || slayers_dice.sample == 5
                self.new_slayer
            end
        elsif turn > 399
            self.new_slayer
            if slayers_dice.sample == 3 || slayers_dice.sample == 4 || slayers_dice.sample == 5
                self.new_slayer
            end
        end
    end

    def self.list_villages
    final_output = ""
        if self.all.count == 0
            final_output = "\n                You do not have any villages. \n      ".blue
        else
            self.all.each do |village|
                final_output = final_output + "___________________________________________________________\n   Name: #{village.name}    |   Population: #{village.population}  |   Knights: #{village.knights} | Slayers: #{village.slayers} \n ___________________________________________________________ \n  "
            end
        end
    final_output
    end
end