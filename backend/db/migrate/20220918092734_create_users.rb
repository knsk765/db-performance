class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.text :last_name, :null => false
      t.text :first_name, :null => false
      t.date :date_of_birth
      t.integer :strength, :null => false, :default => 0
      t.integer :defence, :null => false, :default => 0
      t.integer :agility, :null => false, :default => 0
      t.integer :intelligence, :null => false, :default => 0
      t.integer :luck, :null => false, :default => 0
      t.text :memo01
      t.text :memo02
      t.text :memo03
      t.text :memo04
      t.text :memo05
      t.text :memo06
      t.text :memo07
      t.text :memo08
      t.text :memo09
      t.text :memo10
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
