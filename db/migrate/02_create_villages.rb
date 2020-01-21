class CreateVillages < ActiveRecord::Migration[5.0]
    def change
        create_table :villages do |t|
            t.string :name
            t.integer :population
            t.integer :knights
            t.integer :slayers
        end
    end
end
