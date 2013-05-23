class CreateTodoList < ActiveRecord::Migration
  def change
    create_table :todo_lists do |t|
      t.string :title
      t.references :user
    end
  end
end
