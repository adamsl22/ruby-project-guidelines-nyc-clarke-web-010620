class Dragon < ActiveRecord::Base
    has_many :raid_pairings
    has_many :raids, through: :raid_pairings

    def self.hunger
        Dragon.all.each do |dragon|
            dragon.update(hunger += 1)
            if dragon.hunger == 18
                puts "#{dragon.name} is getting restless."
            elsif dragon.hunger == 19
                puts "#{dragon.name} is very hungry."
            elsif dragon.hunger == 20
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
            elsif dragon.health == "Recovering"
                dragon.update(health: "Healthy")
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
end