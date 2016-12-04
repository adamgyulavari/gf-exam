class CreateSuites < ActiveRecord::Migration[5.0]
  def change
    create_table :suites do |t|
      t.string :owner
      t.text :messages
      t.integer :rate

      t.timestamps
    end
  end
end
