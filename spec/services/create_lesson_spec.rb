require 'rails_helper'

RSpec.describe CreateLesson do
  describe '.call' do
    context 'lesson data is valid' do
      it 'enques job to check the availability and creates lesson' do
        student = create(:student, email: 'student@example.com')
        tutor = create(:tutor, email: 'tutor@example.com')

        expect(CheckAvailabilityAndCreateLessonJob).to receive(:perform_later).with(
          date: '2019-05-08',
          time: '12:00',
          student_id: student.id,
          tutor_id: tutor.id)

        lesson_creation = CreateLesson.call({
          student_email: 'student@example.com',
          tutor_email: 'tutor@example.com',
          date: '2019-05-08',
          hour: '12:00'
        })
        expect(lesson_creation.errors).to be_empty
      end
    end

    context 'lesson data is invalid' do
      it 'does not enques job to check the availability and create lesson' do
        student = create(:student, email: 'student@example.com')
        tutor = create(:tutor, email: 'tutor@example.com')
        
        expect(CheckAvailabilityAndCreateLessonJob).to_not receive(:perform_later).with(
          date: '2019-05-08',
          time: '12:00',
          student_id: student.id,
          tutor_id: tutor.id)

        lesson_creation = CreateLesson.call({
          student_email: 'student@example.com',
          tutor_email: 'tutor@example.com',
          date: '20190508',
          hour: '12:00'
        })
        expect(lesson_creation.errors[:date]).to include('is invalid')
      end
    end
  end
end
