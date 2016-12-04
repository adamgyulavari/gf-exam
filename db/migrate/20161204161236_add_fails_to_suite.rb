class AddFailsToSuite < ActiveRecord::Migration[5.0]
  def change
    add_column :suites, :failures, :text
  end
end
