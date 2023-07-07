class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.references :votable, polymorphic: true
      t.references :user, null: false, foreign_key: true
      t.integer :voute_count, default: 0

      t.timestamps
    end
  end
end
