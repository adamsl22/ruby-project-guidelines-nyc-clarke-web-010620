class Raid < ActiveRecord::Base
    has_many :raid_pairings
    has_many :dragons, through: :raid_pairings
    belongs_to :village

    def hunger
        self.dragons.sum(:hunger)
    end

    def danger_value
        outnumbered_ratio = self.village.knights / self.raid_pairings.count
        danger = outnumbered_ratio + 3 * self.village.slayers
        danger_value = danger / self.dice_roll
    end

    def knights_killed
        new_knights = self.village.knights * 0.15 * self.danger_value
        if new_knights.round > self.village.knights
            new_knights = self.village.knights
        end
        knights_killed = self.village.knights - new_knights.round
        self.village.update(knights: new_knights.round)
        puts "Your dragons killed #{knights_killed} knights in the raid!"
    end

    def slayers_killed
        if self.village.slayers > 0
            new_slayers = self.village.slayers * 0.4 * self.danger_value
            if new_slayers.round > self.village.slayers
                new_slayers = self.village.slayers
            end
            slayers_killed = self.village.slayers - new_slayers.round
            self.village.update(slayers: new_slayers.round)
            puts "Your dragons killed #{slayers_killed} slayers in the raid!"
        end
    end

    def victims
        victims = 0
        if self.danger_value > 1
            massacre = self.hunger / self.danger_value
            victims = massacre.round
            self.dragons.each do |dragon|
                own_vic = dragon.hunger / self.danger_value
                new_hunger = dragon.hunger - own_vic.round
                dragon.update(hunger: new_hunger)
            end
        else
            victims = self.hunger
            self.dragons.update(hunger: 0)
        end
        new_pop = self.village.population - victims
        self.village.update(population: new_pop)
        puts "Your dragons consumed #{victims} people."
        if self.village.population < 1
            puts "#{self.village.name} was destroyed!"
            self.village.destroy
        elsif self.village.knights == 0
            self.village.update(knights: 1)
            puts "A knight has appeared in #{self.village.name} to defend the people from further attacks."
        end
    end

    def dragons_killed
        death_chance = (self.danger_value - 5) * 0.2
        deaths = self.raid_pairings.count * death_chance
        dragons_killed = deaths.round
        dragons_killed.times do
            kill = self.dragons.sample
            puts "#{kill.name} died during the raid!"
            kill.destroy
        end
    end

    def dragons_injured
        injure_chance = (self.danger_value - 3.5) * 0.65
        injuries = self.raid_pairings.count * injure_chance
        dragons_injured = injuries.round
        dragons_injured.times do
            injure = self.dragons.find_by(health: "Healthy")
            injure.update(health: "Hurt")
            puts "#{injure.name} was injured in the raid!"
        end
    end

    def result
        if self.danger_value > 0
            self.knights_killed
            self.slayers_killed
            self.dragons_killed
            self.dragons_injured
        end
        self.victims
        self.dragons.each do |dragon|
            if dragon.health == "Healthy"
                dragon.update(health: "Tired")
            end
        end
    end
end