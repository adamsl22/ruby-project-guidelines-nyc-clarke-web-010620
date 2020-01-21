class Dragon < ActiveRecord::Base
    has_many :raid_pairings
    has_many :raids, through: :raid_pairings

    def self.add_hunger
        Dragon.all.each do |dragon|
            new_hunger = dragon.hunger + 1
            dragon.update(hunger: new_hunger)
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
end