class RemoveOnsenidFromSamples < ActiveRecord::Migration[5.1]
  def change
    remove_column :samples, :onsenid, :int
  end
end
