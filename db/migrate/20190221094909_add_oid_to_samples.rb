class AddOidToSamples < ActiveRecord::Migration[5.1]
  def change
    add_column :samples, :onsenid, :string
  end
end
