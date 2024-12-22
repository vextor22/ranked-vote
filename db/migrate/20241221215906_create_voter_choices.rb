class CreateVoterChoices < ActiveRecord::Migration[8.0]
  def change
    create_table :voter_choices do |t|
      t.references :voter, null: false, foreign_key: true
      t.references :poll_choice, null: false, foreign_key: true
      t.integer :rank

      t.timestamps
    end
  end
end
