class CreateDragons < ActiveRecord::Migration[5.0]
    def change
        create_table :dragons do |t|
            t.string :name
            t.string :wing_span
            t.string :color
            t.string :pattern
            t.integer :hunger
            t.string :health
        end
    end
end