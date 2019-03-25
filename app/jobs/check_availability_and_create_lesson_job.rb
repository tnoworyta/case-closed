class CheckAvailabilityAndCreateLessonJob < ApplicationJob
  queue_as :default

  def perform(student_email:, tutor_id:, date:, hour:)
    tutor = Tutor.find(tutor_id)
    start_time = Time.parse("#{date} #{hour}")
    if WhatADayWrapper.timeslot_available?(start_time: start_time, calendar_id: tutor.calendar_id)
      Lesson.create(tutor: tutor, start_time: start_time, student_email: student_email)
    end
  end
end
