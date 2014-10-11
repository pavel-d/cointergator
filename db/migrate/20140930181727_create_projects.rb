class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.string :docker_options
      t.references :repository, index: true

      t.timestamps null: false
    end
  end
end
