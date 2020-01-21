class Village < ActiveRecord::Base
    has_many :raids

    def self.nomads
        nomads = Village.create(name: "Nomads", population: 30, knights: 0, slayers: 0)
    end

    def self.population_growth
        new_pop = 0
        Village.all.each do |village|
            if turn < 50
                new_pop = village.population + 0.03 * village.population
            elsif turn > 49 && turn < 100
                new_pop = village.population + 0.06 * village.population
            else
                new_pop = village.population + 0.09 * village.population
            end
            village.update(population: new_pop.round)
        end
    end

    def self.first_village
        if turn == 3
            nomad_pop = nomads.population - 15
            nomads.update(population: nomad_pop)
            first_village = Village.create(name: "Primeton", population: 15, knights: 0, slayers: 0)
            puts "The people have founded the village of Primeton."
        end
    end

    def self.most_populous_village
        Village.all.max_by do |village|
            village.population
        end
    end

    def self.new_village
        village_dice = [1,2,3]
        population_dice = [15,16,17,18,19,20]
        settlers = population_dice.sample
        vowels = ["a","e","i","o","u","y"]
        consonants = ["b","c","d","f","g","h","j","k","l","m","n","p","q","r","s","t","v","w","x","z"]
        name_array = [consonants.sample, vowels.sample, consonants.sample, consonants.sample, vowels.sample, consonants.sample, vowels.sample]
        name = name_array.join
        if turn > 5 && self.most_populous_village.population > 30 && village_dice.sample == 3
            settlers.times do
                settler_home = Village.all.sample
                if settler_home.population > 1
                    new_pop = settler_home.population - 1
                    settler_home.update(population: new_pop)
                end
            end
            name = Village.create(name: name.capitalize, population: settlers, knights: 0, slayers: 0)
            puts "The people have founded the village of #{name.capitalize}."
        end
    end

    def self.knights
        knights_dice = [1,2,3,4,5]
        Village.all.each do |village|
            if village.knights > 0
                new_knights = village.knights + 1
                if turn < 50 && knights_dice.sample == 5
                    village.update(knights: new_knights)
                elsif turn > 49 && turn < 100
                    if knights_dice.sample == 3 || knights_dice.sample == 4 || knights_dice.sample == 5
                        village.update(knights: new_knights)
                    end
                else
                    village.update(knights: new_knights)
                end
            end
        end
    end

    def self.slayers
        slayers_dice = [1,2,3,4,5]
        if turn == 30 || turn == 40
            slayer_home = Village.all.sample
            new_slayers = slayer_home.slayers + 1
            slayer_home.update(slayers: new_slayers)
        elsif turn > 49 && turn < 100 && slayers_dice.sample == 5
            slayer_home = Village.all.sample
            new_slayers = slayer_home.slayers + 1
            slayer_home.update(slayers: new_slayers)
        elsif turn > 99
            if slayers_dice.sample == 4 || slayers_dice.sample == 5
                slayer_home = Village.all.sample
                new_slayers = slayer_home.slayers + 1
                slayer_home.update(slayers: new_slayers)
            end
        end
    end
end