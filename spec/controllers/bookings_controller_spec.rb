require 'spec_helper'

RSpec.describe 'BookingsController', type: :request do
  describe 'POST create' do
    context 'no prior booking exits' do
      it 'booking successfully created' do
        expect(SchoolAbcWrapper).to receive(:create_booking) { SchoolAbcWrapper::Booking.new(id: '1') }
        expect_any_instance_of(BookingForm).to receive(:save).and_call_original

        post '/bookings', params: { booking: { pincode: '1234',
                                               start_time: '2019-01-01 08:00:00',
                                               end_time: '2019-01-01 15:00:00',
                                               topic_id: '1' } }

        expect(response).to have_http_status(200)
      end
    end

    context 'prior overlapping booking exits' do
      it 'booking is not created' do
        expect(SchoolAbcWrapper).to receive(:create_booking) { SchoolAbcWrapper::Booking.new }
        expect_any_instance_of(BookingForm).to receive(:call).and_call_original

        post '/bookings', params: { booking: { pincode: '1234',
                                               start_time: '2019-01-01 08:00:00',
                                               end_time: '2019-01-01 15:00:00',
                                               topic_id: '1' } }

        expect(response).to have_http_status(422)
      end
    end
  end
end
