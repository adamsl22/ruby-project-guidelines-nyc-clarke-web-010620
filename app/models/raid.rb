class Raid < ActiveRecord::Base
    has_many :raid_pairings
    has_many :dragons, through: raid_pairings
    belongs_to :village

    def hunger
        self.dragons.sum(:hunger)
    end

    def danger_value
        outnumbered_ratio = self.village.knights / self.raid_pairings.count
        danger = self.outnumbered_ratio + 3 * self.village.slayers
        danger_value = danger / self.dice_roll
    end

    def knights_killed
        massacre = self.village.knights * .15 * self.danger_value
        knights_killed = self.village.knights - massacre.round
    end

    def slayers_killed
        massacre = self.village.slayers * .4 * self.danger_value
        slayers_killed = self.village.slayer - massacre.round
    end

    def victims
        massacre = self.hunger / self.danger_value
        victims = massacre.round
    end

    def dragons_killed
        death_chance = (self.danger_value - 5) * .2
        deaths = self.raid_pairings.count * death_chance
        dragons_killed = deaths.round
        dragons_killed.times do
            kill = self.dragon.sample
            kill.destroy
            puts "#{kill.name} died during the raid!"
        end
    end

    def dragons_injured
        injure_chance = (self.danger_value - 3.5) * .65
        injuries = self.raid_pairings.count * injure_chance
        dragons_injured = injuries.round
        dragons_injured.times do
            injure = self.dragon.find_by(health: "Healthy")
            injure.update(health: "Hurt")
            puts "#{injure.name} was injured in the raid!"
        end
    end

    def result
        if self.danger_value == 0
            puts "Your dragons consumed #{self.hunger} people."
            self.village.update(population -= self.hunger)
            self.dragons.update(hunger: 0)
            if self.village.population < 1
                puts "#{self.village.name} was destroyed!"
                self.village.destroy
            end
        else
            puts "Your dragons killed #{self.knights_killed} knights in the raid!"
            self.village.update(knights -= self.knights_killed)
            if self.village.slayers > 0
                puts "Your dragons killed #{self.slayers_killed} slayers in the raid!"
                self.village.update(slayers -= self.slayers_killed)
            end
        end
    end



end