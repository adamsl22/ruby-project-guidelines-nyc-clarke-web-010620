class Dragon < ActiveRecord::Base
    has_many :raid_pairings
    has_many :raids, through: :raid_pairings

    def self.add_hunger
        Dragon.all.each do |dragon|
            new_hunger = dragon.hunger + 1
            dragon.update(hunger: new_hunger)
            if dragon.hunger == 8
                puts "#{dragon.name} is getting restless."
            elsif dragon.hunger == 9
                puts "#{dragon.name} is very hungry."
            elsif dragon.hunger == 10
                puts "#{dragon.name} has abandoned you in search of food."
                dragon.destroy
            end
        end
    end

    def self.recovery
        Dragon.all.each do |dragon|
            if dragon.health == "Hurt"
                dragon.update(health: "Injured")
            elsif dragon.health == "Injured"
                dragon.update(health: "Recovering")
            elsif dragon.health == "Recovering" || dragon.health == "Resting"
                dragon.update(health: "Healthy")
            elsif dragon.health == "Tired"
                dragon.update(health: "Resting")
            end
        end
    end

    def self.list_dragons
    final_output = ""
        if Dragon.all.count == 0
            final_output = "\n                You do not have any dragons. \n      ".blue
        else
            Dragon.all.each do |dragon|
                final_output = final_output + "___________________________________________________________\n   Name: #{dragon.name}    |   Hunger: #{dragon.hunger}  |   Health: #{dragon.health} \n ___________________________________________________________ \n  "
            end
        end
    final_output
    end

    def self.available_dragons
        healthy_dragons = Dragon.all.select do |dragon|
            dragon.health == "Healthy"
        end
        if healthy_dragons.length == 0
            return nil
        else
            return healthy_dragons
        end
    end
end