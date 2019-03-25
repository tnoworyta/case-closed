require 'rails_helper'

RSpec.describe CreateLesson do
  describe '.call' do
    context 'lesson data is valid' do
      it 'enqueues availability check' do
        tutor = create(:tutor, email: 'tutor@example.com')

        expect_any_instance_of(LessonForm).to receive(:valid?).and_call_original
        expect(CheckAvailabilityAndCreateLessonJob)
        .to receive(:perform_later).with(
          student_email: 'student@example.com',
          tutor_id: tutor.id,
          date: '2019-05-01',
          hour: '12:00'
        )

        CreateLesson.call({
          student_email: 'student@example.com',
          tutor_email: 'tutor@example.com',
          date: '2019-05-01',
          hour: '12:00'
        })
      end
    end

    context 'lesson data is not valid' do
      it 'does not enqueue availability check' do
        create(:tutor, email: 'tutor@example.com')

        expect_any_instance_of(LessonForm).to receive(:valid?).and_call_original
        expect(CheckAvailabilityAndCreateLessonJob).not_to receive(:perform_later)

        CreateLesson.call({
          student_email: 'student@example.com',
          tutor_email: 'tutor@example.com',
          date: '20190501',
          hour: '12:00'
        })
      end
    end
  end
end
