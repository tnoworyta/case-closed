require 'rails_helper'

RSpec.describe CheckAvailabilityAndCreateLessonJob do
  describe '#perform' do
    context 'timeslot is available' do
      it 'creates lesson' do
        tutor = create(:tutor, calendar_id: '111')

        expect(WhatADayWrapper)
          .to receive(:timeslot_available?)
          .with(start_time: Time.parse('2019-05-01 12:00'), calendar_id: '111') { true }

        expect {
          CheckAvailabilityAndCreateLessonJob.perform_later(
            student_email: 'student@example.com',
            tutor_id: tutor.id,
            date: '2019-05-01',
            hour: '12:00'
          )
        }.to change { Lesson.count }.by(1)
      end
    end

    context 'timeslot is not available' do
      it 'does not create lesson' do
        tutor = create(:tutor, calendar_id: '111')

        expect(WhatADayWrapper)
          .to receive(:timeslot_available?)
          .with(start_time: Time.parse('2019-05-01 12:00'), calendar_id: '111') { false }

        expect {
          CheckAvailabilityAndCreateLessonJob.perform_later(
            student_email: 'student@example.com',
            tutor_id: tutor.id,
            date: '2019-05-01',
            hour: '12:00'
          )
        }.not_to change { Lesson.count }
      end
    end
  end
end
