class CreateSamples < ActiveRecord::Migration[5.1]
  def change
    create_table :samples do |t|
      t.string :title
      t.text :body
      t.integer :onsenid, null: false
      t.timestamps
    end
  end
end
