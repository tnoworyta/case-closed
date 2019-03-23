class LessonsController < ApplicationController
  def create
    lesson_form = LessonForm.new(Lesson.new, params[:lesson])
    if lesson_form.save
      head 200
    else
      head 400
    end
  end
end
