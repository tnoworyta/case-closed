class LessonsController < ApplicationController
  def create
    lesson_creation = CreateLesson.call(params[:lesson])
    if lesson_creation.errors.empty?
      head 202
    else
      head 400
    end
  end
end
