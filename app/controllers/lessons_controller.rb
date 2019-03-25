class LessonsController < ApplicationController
  def create
    lesson_creation = CreateLesson.call(params[:lesson].to_unsafe_h)
    if lesson_creation.errors.empty?
      head 202
    elsif lesson_creation.errors[:tutor_email].any?
      head 404
    else
      head 400
    end
  end
end
