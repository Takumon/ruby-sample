class CreateNovelties < ActiveRecord::Migration[7.2]
  def change
    create_table :novelties do |t|
      t.string :name
      t.references :book, null: false, foreign_key: true

      t.timestamps
    end
  end
end
