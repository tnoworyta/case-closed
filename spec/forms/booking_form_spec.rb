require 'spec_helper'

RSpec.describe 'BookingForm', type: :form do
  describe '#save' do
    it 'new booking created' do
      params = { booking: { pincode: '1234',
      start_time: '2019-01-01 08:00:00',
      end_time: '2019-01-01 15:00:00',
      topic_id: '1' } }

      expect(SchoolAbcWrapper).to receive(:create_booking).with(pincode: '1234',
      start_time: '2019-01-01 08:00:00',
      end_time: '2019-01-01 15:00:00',
      topic_id: '1') { true }

      BookingForm.new(params).save
    end
  end
end
