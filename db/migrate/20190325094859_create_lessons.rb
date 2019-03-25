class CreateLessons < ActiveRecord::Migration[5.1]
  def change
    create_table :lessons do |t|
      t.integer :tutor_id
      t.string :student_id
      t.datetime :start_time
    end
  end
end
