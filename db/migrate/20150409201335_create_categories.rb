class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
    end

    
    if Category.all.empty?
      Category.create(name: "ruby")
      Category.create(name: "rails")
      Category.create(name: "unknown")
    end
    

  end
end
