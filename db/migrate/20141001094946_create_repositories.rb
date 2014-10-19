class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.integer :project_id
      t.string :remote_url

      t.timestamps null: false
    end
  end
end
