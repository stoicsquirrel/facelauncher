class CreateProgramsAccessibleByUsers < ActiveRecord::Migration
  def change
    create_table :programs_accessible_by_users do |t|
      t.integer :program_id
      t.integer :user_id

      t.timestamps
    end
  end
end
