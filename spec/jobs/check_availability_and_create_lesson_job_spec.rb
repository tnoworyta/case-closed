require 'rails_helper'

RSpec.describe CheckAvailabilityAndCreateLessonJob do
  context 'checks availability for UberCalendar' do
    context 'timeslot available' do
      it 'creates lesson' do
        student = create(:student, email: 'student@example.com')
        tutor = create(:tutor, email: 'tutor@example.com', calendar_type: 'uber', calendar_id: '111')
        expect_any_instance_of(UberCalendarClient).to receive(:slot)
          .with(datetime: Time.parse('2019-05-01 12:00'), calendar_id: '111') { { available: true } }

        expect { CheckAvailabilityAndCreateLessonJob.perform_later(
          date: '2019-05-01',
          time: '12:00',
          student_id: student.id,
          tutor_id: tutor.id
          ) }.to change { Lesson.count }.by(1)
      end
    end

    context 'timeslot is not available' do
      it 'does not create lesson' do
        student = create(:student, email: 'student@example.com')
        tutor = create(:tutor, email: 'tutor@example.com', calendar_type: 'uber', calendar_id: '111')
        expect_any_instance_of(UberCalendarClient).to receive(:slot)
          .with(datetime: Time.parse('2019-05-01 12:00'), calendar_id: '111') { { available: false } }

        expect { CheckAvailabilityAndCreateLessonJob.perform_later(
          date: '2019-05-01',
          time: '12:00',
          student_id: student.id,
          tutor_id: tutor.id
          ) }.not_to change { Lesson.count }
      end
    end
  end
end

