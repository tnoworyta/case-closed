class CreateLessons < ActiveRecord::Migration[5.1]
  def change
    create_table :lessons do |t|
      t.string :student_email
      t.string :tutor_email
      t.datetime :datetime
    end
  end
end
