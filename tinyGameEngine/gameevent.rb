require_relative 'ui_design_module.rb'
include DesignModule
require 'colorize'
require 'pry'

class GameEvent

attr_accessor  :event_object, :week, :display, :color

@@gameclock = 1
@@all = []
def initialize(event_object, week, display, color = nil)
    @event_object = event_object
    @week = week
    if event_object
    @display = "#{event_object.name}" + " " + display
    else
        @display = display
    end
    @color = color

    @@all << self
end
def self.gameclock
    @@gameclock
end

def self.increment_game_clock(num)
    i = 0
    while i < num
    @@gameclock += 1 
    i += 1
    end
end

def self.all
    @@all
end

def self.weeks_events(week)
    @@all.select do |event|
        week == event.week
    end
end

def self.weeks_summary(week)
    
    weeks_events(week).each do |event|
        if event.event_object.class == Method
            event.event_object.call
            return
        end

        if event.event_object.class == Product
        puts LINE_SQUIGGLES_MEDIUM.blue
        puts event.display.blue
        puts LINE_SQUIGGLES_MEDIUM.blue
        else 
            if event.color == "red"
                puts LINE_SQUIGGLES_MEDIUM.red
                puts event.display.red
                puts LINE_SQUIGGLES_MEDIUM.red
            elsif event.color == "green"
                puts LINE_SQUIGGLES_MEDIUM.green
                puts event.display.green
                puts LINE_SQUIGGLES_MEDIUM.green
            else
                puts LINE_SQUIGGLES_MEDIUM.blue
                puts event.display.blue
                puts LINE_SQUIGGLES_MEDIUM.blue
            end
        end
        
    end
end

def self.check_for_loss
    if Dragon.all.count == 0 && Dragon.eggs == 0
        UI.announce("You have no dragons or dragon eggs! Game over!", "red")
        exit
    elsif Village.all == nil
        UI.announce("You have exhausted the food supply! Game over!", "red")
        exit
    end
end


def self.seed_database(num_of_dragons, num_of_villages)
    i = 0
    while i < num_of_dragons
    Dragon.create(name: "Barius#{i}", wing_span: "12", color: "Blue", pattern: "Test", health: "Healthy", hunger: 1 )
    i += 1
    end
    j = 0
    while j < num_of_villages
    Village.create(name: "Village#{j}", population: 30, knights: 15, slayers: 1)
    j += 1
    end
end

end