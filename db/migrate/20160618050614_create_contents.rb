class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.integer :user_id
      t.integer :book_id
      t.string  :url
      t.string  :url_title
      t.string  :content
      
      t.timestamps null: false
    end
  end
end
