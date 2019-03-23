class AddFkeysToLessons < ActiveRecord::Migration[5.1]
  def change
    add_column :lessons, :student_id, :integer
    add_column :lessons, :tutor_id, :integer
  end
end
