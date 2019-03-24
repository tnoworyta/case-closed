class CheckAvailabilityAndCreateLessonJob < ApplicationJob
  queue_as :default

  def perform(date:, time:, tutor_id:, student_id:)
    student = Student.find(student_id)
    tutor = Tutor.find(tutor_id)
    datetime = Time.parse("#{date} #{time}")
    if(tutor.calendar_type == 'uber')
      if UberCalendarClient.new.slot(datetime: datetime, calendar_id: tutor.calendar_id) == { available: true }
        Lesson.create(datetime: datetime, tutor_id: tutor_id, student_id: student_id)
      end
    end
  end
end
