class AddFirstWordToLocation < ActiveRecord::Migration
  def self.up
    change_table :locations do |t|
      t.string :keyword
      t.string :reg_match
    end
  end

  def self.down
    change_table :locations do |t|
      t.remove :keyword
      t.remove :reg_match
    end
  end
end
