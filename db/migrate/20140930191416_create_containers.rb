class CreateContainers < ActiveRecord::Migration
  def change
    create_table :containers do |t|
      t.string :image_id
      t.string :docker_container_id
      t.string :name
      t.string :branch_name
      t.references :project, index: true

      t.timestamps null: false
    end
  end
end
