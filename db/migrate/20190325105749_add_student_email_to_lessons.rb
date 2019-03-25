class AddStudentEmailToLessons < ActiveRecord::Migration[5.1]
  def change
    add_column :lessons, :student_email, :string
  end
end
