class RenameVoteCountToValue < ActiveRecord::Migration[6.1]
  def change
    rename_column :votes, :voute_count, :value
  end
end
