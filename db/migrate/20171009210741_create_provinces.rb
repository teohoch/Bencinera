class CreateProvinces < ActiveRecord::Migration[5.1]
  def change
    create_table :provinces do |t|
      t.integer :code
      t.string :name
      t.st_point :location, geographic: true
      t.integer :parent_code
      t.integer :parent_code
      t.references :region, foreign_key: true

      t.timestamps
    end
  end
end
