class CreateProgramsAdditionalFields < ActiveRecord::Migration
  def change
    create_table :programs_additional_fields do |t|
      t.references :program, null: false
      t.string :short_name, null: false, limit: 100
      t.string :label
      t.boolean :is_required, null: false

      t.timestamps
    end
    add_index :programs_additional_fields, :program_id
  end
end
