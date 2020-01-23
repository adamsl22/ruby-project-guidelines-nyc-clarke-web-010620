class Dragon < ActiveRecord::Base
    has_many :raid_pairings
    has_many :raids, through: :raid_pairings

    @@eggs = 0
    def self.eggs
        @@eggs
    end
    def self.dec_eggs
        @@eggs -= 1
    end
    def self.inc_eggs
        @@eggs += 1
    end
    def self.eggs=(num)
        @@eggs = num
    end

    def self.add_hunger
        Dragon.all.each do |dragon|
            new_hunger = dragon.hunger + 1
            dragon.update(hunger: new_hunger)
            if dragon.hunger == 8
                UI.announce("#{dragon.name} is getting restless.", "red")
            elsif dragon.hunger == 9
                UI.announce("#{dragon.name} is very hungry.", "red")
            elsif dragon.hunger == 10
                UI.announce("#{dragon.name} has abandoned you in search of food.", "red")
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
                dragon.update(health: "Resting")
            elsif dragon.health == "Resting"
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
                final_output = final_output + "___________________________________________________________\n   Name: #{dragon.name}  |  Wing Span: #{dragon.wing_span}  |  Hunger: #{dragon.hunger}  \n   Color: #{dragon.color}     |  Pattern: #{dragon.pattern}  |  Health: #{dragon.health} \n ___________________________________________________________ \n  "
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

    def self.kill_dragon(dragon)
        dragon.update(health: "Dead")
        dragon.destroy
    end

    def self.injure_dragon(dragon)
        dragon.update(health: "Hurt")
    end

end