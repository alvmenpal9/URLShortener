class CreateShorturls < ActiveRecord::Migration[7.1]
  def change
    create_table :shorturls do |t|
      t.string :original_url
      t.string :short_url
      t.integer :visits, default: 0
      t.timestamps
    end
  end
end
