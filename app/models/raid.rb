class Raid < ActiveRecord::Base
    has_many :raid_pairings
    has_many :dragons, through: :raid_pairings
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
        massacre = self.village.knights * 0.15 * self.danger_value
        knights_killed = self.village.knights - massacre.round
        self.village.update(knights -= knights_killed)
        puts "Your dragons killed #{knights_killed} knights in the raid!"
    end

    def slayers_killed
        if self.village.slayers > 0
            massacre = self.village.slayers * 0.4 * self.danger_value
            slayers_killed = self.village.slayer - massacre.round
            self.village.update(slayers -= slayers_killed)
            puts "Your dragons killed #{slayers_killed} slayers in the raid!"
        end
    end

    def victims
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
        self.village.update(population -= victims)
        puts "Your dragons consumed #{victims} people."
    end

    def dragons_killed
        death_chance = (self.danger_value - 5) * 0.2
        deaths = self.raid_pairings.count * death_chance
        dragons_killed = deaths.round
        dragons_killed.times do
            kill = self.dragon.sample
            kill.destroy
            puts "#{kill.name} died during the raid!"
        end
    end

    def dragons_injured
        injure_chance = (self.danger_value - 3.5) * 0.65
        injuries = self.raid_pairings.count * injure_chance
        dragons_injured = injuries.round
        dragons_injured.times do
            injure = self.dragon.find_by(health: "Healthy")
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
    end
end