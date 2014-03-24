class FixIdColumn < ActiveRecord::Migration
  def change
    rename_column :reviews, :r_id, :restaurant_id
  end
end
