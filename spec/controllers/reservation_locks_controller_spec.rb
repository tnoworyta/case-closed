require 'rails_helper'

RSpec.describe 'ReservationLocks', type: :request do
  describe 'POST create' do
    context 'no prior reservations or locks created' do
      it 'reservation lock succefully created' do
        property = create(:property)

        expect(ApplicationController).to receive(:user_token) { 'abc123' }

        post '/reservation_locks', params: {
          'reservation' => {
            check_in_date: '2018-08-08',
            check_out_date: '2018-09-08',
            property_id: property.id
          }
        }

        expect(CheckReservationAvailability).to receive(:call).and_call_original
        expect(CreateReservationLock).to receive(:call).and_call_original

        expect(response).to have_http_status(200)
      end
    end

    context 'prior finalized overlapping reservation created' do
      it 'reservation lock is not created' do
        property = create(:property)
        create(:reservation, property: property,
        check_in_date: Date.parse('2018-08-10'),
        check_out_date: Date.parse('2018-09-08'))

        expect(ApplicationController).to receive(:user_token) { 'abc123' }

        post '/reservation_locks', params: {
          'reservation' => {
            check_in_date: '2018-08-08',
            check_out_date: '2018-09-08',
            property_id: property.id
          }
        }

        expect(CheckReservationAvailability).to receive(:call).and_call_original
        expect(CreateReservationLock).not_to receive(:call)

        expect(response).to have_http_status(422)
        expect(response).to redirect_to('/properties/1')
      end
    end

    context 'prior locked reservation created' do
      it 'reservation lock is not created' do
        property = create(:property)
        create(:reservation_lock, property: property,
        locked_unitl: 10.minutes.from_now,
        check_in_date: Date.parse('2018-08-10'),
        check_out_date: Date.parse('2018-09-08'),
        user_token: 'cde456')

        expect(ApplicationController).to receive(:user_token) { 'abc123' }

        post '/reservation_locks', params: {
          'reservation' => {
            check_in_date: '2018-08-08',
            check_out_date: '2018-09-08',
            property_id: property.id
          }
        }

        expect(CheckReservationAvailability).to receive(:call).and_call_original
        expect(CreateReservationLock).not_to receive(:call)

        expect(response).to have_http_status(422)
        expect(response).to redirect_to('/properties/1')
      end
    end
  end
end
