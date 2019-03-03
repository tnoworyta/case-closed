require 'spec_helper'

RSpec.describe 'SchoolAbcWrapper', type: :wrapper do
  describe '#create_booking' do
    context 'no prior booking is created' do
      it 'creates booking' do
        expect_any_instance_of(SchoolAbcClient).to receive(:student)
          .with(pincode: '1234') { {data: { student: { id: "586f7275d01dd3040033e6eb", name: 'John Doe' } }}  }

        expect_any_instance_of(SchoolAbcClient).to receive(:create_booking)
          .with(student_id: '586f7275d01dd3040033e6eb',
                start_time: '2019-01-01 08:00:00',
                end_time: '2019-01-01 15:00:00',
                topic_id: '1') { {data: { booking: { id: "5c7a75ff3b72c706a37e9477" } } } }

        booking = SchoolAbcWrapper.create_booking(pincode: '1234',
          start_time: '2019-01-01 08:00:00',
          end_time: '2019-01-01 15:00:00',
          topic_id: '1')

        expect(booking.id).to eq('5c7a75ff3b72c706a37e9477')
      end
    end

    context 'prior overlaping booking is created' do
      it 'does not create booking' do
        expect_any_instance_of(SchoolAbcClient).to receive(:student)
          .with(pincode: '1234') { {data: { student: { id: "586f7275d01dd3040033e6eb", name: 'John Doe' } }}  }

        expect_any_instance_of(SchoolAbcClient).to receive(:create_booking)
          .with(student_id: '586f7275d01dd3040033e6eb',
                start_time: '2019-01-01 08:00:00',
                end_time: '2019-01-01 15:00:00',
                topic_id: '1') { {} }

        booking = SchoolAbcWrapper.create_booking(pincode: '1234',
          start_time: '2019-01-01 08:00:00',
          end_time: '2019-01-01 15:00:00',
          topic_id: '1')

        expect(booking.id).to be_nil
      end
    end
  end
end
