class AddCalendarToTutors < ActiveRecord::Migration[5.1]
  def change
    add_column :tutors, :calendar_id, :string
  end
end
