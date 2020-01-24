class Village < ActiveRecord::Base
    has_many :raids

    def self.nomads
        nomads = Village.create(name: "Nomads", population: 30, knights: 0, slayers: 0)
    end

    def self.population_growth(turn)
        new_pop = 0
        Village.all.each do |village|
            if village.name == "Nomads"
                if village.population > 24 && turn < 100
                    new_pop = village.population + 0.03 * village.population
                elsif village.population < 25 && turn < 100
                    new_pop = village.population + 0.30 * village.population
                end
            else
                if village.population < 25
                    if turn < 50
                        new_pop = village.population + 0.30 * village.population
                    elsif turn > 49 && turn < 100
                        new_pop = village.population + 0.40 * village.population
                    else
                        new_pop = village.population + 0.50 * village.population
                    end
                else
                    if turn < 50
                        new_pop = village.population + 0.15 * village.population
                    elsif turn > 49 && turn < 100
                        new_pop = village.population + 0.25 * village.population
                    elsif turn > 99 && turn < 300
                        new_pop = village.population + 0.35 * village.population
                    else
                        new_pop = village.population + 0.45 * village.population
                    end
                end
            end
            village.update(population: new_pop.round)
        end
    end

    def self.first_village
        if Village.all.count == 1
            nomads = Village.find_by(name: "Nomads")
            nomad_pop = nomads.population - 15
            nomads.update(population: nomad_pop)
            first_village = Village.create(name: "Primeton", population: 15, knights: 0, slayers: 0)
            UI.soft_announce("The people have founded the village of Primeton.", "blue")
        end
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
        if turn > 5 && self.most_populous_village.population > 25 && village_dice.sample == 3 && Village.all.count < 15
            home_pop = self.most_populous_village.population - settlers
            self.most_populous_village.update(population: home_pop)
            new_village = Village.create(name: name.capitalize, population: settlers, knights: 0, slayers: 0)
            UI.soft_announce("The people have founded the village of #{new_village.name}.", "blue")
        end
    end

    def self.knights(turn)
        knights_dice = [1,2,3,4,5]
        Village.all.each do |village|
            if village.knights > 0
                new_knight = village.knights + 1
                second_knight = village.knights + 2
                third_knight = village.knights + 3
                if village.name == "Nomads"
                    if turn % 10 == 0
                        village.update(knights: new_knight)
                    end
                else
                    if turn < 50
                        if village.knights < 15
                            village.update(knights: second_knight)
                        elsif knights_dice.sample == 3 || knights_dice.sample == 4 || knights_dice.sample == 5
                            village.update(knights: new_knight)
                        end
                    elsif turn > 49 && turn < 100
                        if village.knights < 20
                            village.update(knights: third_knight)
                        else
                            village.update(knights: new_knight)
                        end
                    elsif turn > 99 && turn < 200
                        if village.knights < 25
                            village.update(knights: third_knight)
                        elsif knights_dice.sample == 3 || knights_dice.sample == 4 || knights_dice.sample == 5
                            village.update(knights: second_knight)
                        else
                            village.update(knights: new_knight)
                        end
                    elsif turn > 199 && turn < 300
                        if village.knights < 25
                            village.update(knights: third_knight)
                        else
                            village.update(knights: second_knight)
                        end
                    elsif turn > 299 && turn < 400
                        if village.knights < 25 || knights_dice.sample == 4 || knights_dice.sample == 5
                            village.update(knights: third_knight)
                        else
                            village.update(knights: second_knight)
                        end
                    else
                        if village.knights < 25 || knights_dice.sample == 2 || knights_dice.sample == 3 || knights_dice.sample == 4 || knights_dice.sample == 5
                            village.update(knights: third_knight)
                        else
                            village.update(knights: second_knight)
                        end
                    end
                end
            end
        end
        unraided_villages = Village.all.select {|village| village.knights == 0}
        if turn % 5 == 0 && unraided_villages.count > 0
            if turn > 49 && unraided_villages.count > 1
                unraided_villages.each {|village| village.update(knights: 1)}
                UI.soft_announce("Fear of your dragons is spreading. More villages are beginning to train knights.", "red")
            else
                news_recipient = unraided_villages.sample
                news_recipient.update(knights: 1)
                UI.soft_announce("News of your dragon raids has spread to #{news_recipient.name}.\n The village has begun training knights in fear of your \nattacks.", "red")
            end
        end
    end

    def self.new_slayer
        slayer_home = Village.all.sample
        new_slayers = slayer_home.slayers + 1
        slayer_home.update(slayers: new_slayers)
        UI.soft_announce("Another slayer has emerged among the people.", "red")
    end

    def self.slayers(turn)
        slayers_dice = [1,2,3,4,5]
        if turn == 20
            slayer_home = Village.all.sample
            new_slayers = slayer_home.slayers + 1
            slayer_home.update(slayers: new_slayers)
            UI.soft_announce("The people are learning how to better kill dragons. A\nslayer has emerged who poses a grave threat!", "red")
        elsif turn == 30 || turn == 40
            self.new_slayer
        elsif turn > 49 && turn < 100
            if slayers_dice.sample == 4 || slayers_dice.sample == 5
                self.new_slayer
            end
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

    def self.attack(turn)
        attack_dice = [1,2,3,4,5,6]
        attack_chance = attack_dice.sample
        attack_roll = attack_dice.sample
        your_roll = attack_dice.sample
        attacking_village = Village.all.sample
        if attacking_village.knights > 25 && turn > 55 && attack_chance == 6
            #Attack
            UI.announce("Knights from #{attacking_village.name} are attacking!", "red")
            if turn < 100
                attacking_knights = 10
            elsif turn > 99 && turn < 200
                attacking_knights = 15
            else
                attacking_knights = 20
            end
            UI.announce("#{attacking_knights} knights approach your dragons.", "red")
            if attacking_village.slayers > 0
                if turn < 100
                    attacking_slayers = 1
                elsif turn > 99 && turn < 200 && attacking_village.slayers > 1
                    attacking_slayers = 2
                else
                    attacking_slayers = attacking_village.slayers
                end
                UI.announce("They are accompanied by #{attacking_slayers} slayers.", "red")
            end
            #Rolls
            if attack_roll < 3
                UI.announce("The attackers roll a #{attack_roll}.", "green")
            elsif attack_roll > 4
                UI.announce("The attackers roll a #{attack_roll}.", "red")
            else
                UI.announce("The attackers roll a #{attack_roll}.", "blue")
            end
            if your_roll < 3
                UI.announce("You roll a #{your_roll}.", "red")
            elsif your_roll > 4
                UI.announce("You roll a #{your_roll}.", "green")
            else
                UI.announce("You roll a #{your_roll}.", "blue")
            end
            #DV
            defending_dragons = Dragon.all.count
            outnumbered_ratio = attacking_knights.to_f / defending_dragons.to_f
            danger = outnumbered_ratio + 5.00 * attacking_slayers.to_f
            roll_difference = attack_roll.to_f - your_roll.to_f
            danger_value = danger + roll_difference
            if danger_value < 0.00
                UI.announce("Your dragons destroyed all attackers!", "green")
                new_knights = attacking_village.knights - attacking_knights
                new_slayers = attacking_village.slayers - attacking_slayers
                attacking_village.update(knights: new_knights, slayers: new_slayers)
            else
                #Knights
                dead_knights = attacking_knights.to_f - danger_value / 2.00
                if dead_knights < 0.00
                    dead_knights = 0
                end
                new_knights = attacking_village.knights - dead_knights.round
                attacking_village.update(knights: new_knights)
                UI.announce("Your dragons killed #{dead_knights.round} attacking knights!", "green")
                #Slayers
                if attacking_slayers > 0
                    slayer_hardiness = 6.25 + roll_difference
                    dead_slayers = attacking_slayers.to_f / slayer_hardiness
                    new_slayers = attacking_village.slayers - dead_slayers.round
                    attacking_village.update(slayers: new_slayers)
                    UI.announce("Your dragons killed #{dead_slayers.round} attacking slayers!", "green")
                end
                #Dragon Deaths
                if roll_difference > 1
                    death_chance = (danger_value - 5) / 20.00
                else
                    death_chance = 0
                end
                deaths = defending_dragons * death_chance
                dragons_killed = deaths.round
                if dragons_killed > defending_dragons
                    dragons_killed = defending_dragons
                end
                dragons_killed.times do
                    dead_dragon = Dragon.all.sample
                    UI.announce("#{dead_dragon.name} was killed in the attack!", "red")
                    Dragon.kill_dragon(dead_dragon)
                end
                #Dragon Injuries
                if dragons_killed < defending_dragons
                    injure_chance = (danger_value - 3.5) / 10.00
                    injuries = defending_dragons * injure_chance
                    dragons_injured = injuries.round
                    if dragons_injured > (defending_dragons - dragons_killed)
                        dragons_injued = defending_dragons - dragons_killed
                    end
                    dragons_injured.times do
                        injured_dragon = Dragon.all.sample
                        if injured_dragon.health != "Hurt"
                            UI.announce("#{injured_dragon.name} was injured in the attack!", "red")
                            Dragon.injure_dragon(injured_dragon)
                        end
                    end
                end
            end
        end
    end
end