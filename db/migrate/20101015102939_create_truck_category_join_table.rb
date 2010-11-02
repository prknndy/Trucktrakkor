class CreateTruckCategoryJoinTable < ActiveRecord::Migration
  def self.up
    create_table :categories_trucks, :id => false do |t|
      t.integer :category_id
      t.integer :truck_id
    end
  end

  def self.down
    drop_table :categories_trucks
  end
end
