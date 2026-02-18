class CreateItems < ActiveRecord::Migration[8.1]
  def change
    create_table :items do |t|
      t.string :content
      t.boolean :done, default: false, null: false
      
      t.references :todo, null: false, foreign_key: true

      t.timestamps
    end
  end
end
