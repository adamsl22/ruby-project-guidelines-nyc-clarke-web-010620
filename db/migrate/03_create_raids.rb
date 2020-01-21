class CreateRaids < ActiveRecord::Migration[5.0]
    def change
        create_table :raids do |t|
            t.integer :village_id
            t.integer :dice_roll
        end
    end
end