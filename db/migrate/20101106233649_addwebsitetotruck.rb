class Addwebsitetotruck < ActiveRecord::Migration
  def self.up
    change_table :trucks do |t|
      t.string :website
    end
  end

  def self.down
    change_table :trucks do |t|
     t.remove :website
    end
  end
end

