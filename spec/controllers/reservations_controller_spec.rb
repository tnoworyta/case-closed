require 'rails_helper'

RSpec.describe 'Reservations', type: :request do
  describe 'POST create' do
    context 'no prior reservations created' do
      it 'reservation succefully created' do
        property = create(:property)

        expect(ApplicationController).to receive(:user_token) { 'abc123' }

        reservation_lock = create(:reservation_lock,
        property: property,
        locked_unitl: 10.minutes.from_now,
        check_in_date: Date.parse('2018-08-10'),
        check_out_date: Date.parse('2018-09-08'),
        user_token: 'abc123')

        expect(CreateReservation).to receive(:call).and_call_original

        params = {
          reservation_lock_id: reservation_lock.id,
          reservation: {
            first_name: 'John',
            last_name: 'Doe',
            email: 'john@example.com'
          }
        }
        expect { post '/reservations', params: params }.to change { Reservation.count }.by(1)

        expect(response).to have_http_status(200)

        expect(response).to redirect_to('/properties/1/reservation/1')
      end
    end

    context 'prior reservation created' do
      it 'reservation failed to be created' do
        property = create(:property)

        expect(ApplicationController).to receive(:user_token) { 'abc123' }

        reservation_lock = create(:reservation_lock,
        property: property,
        locked_unitl: 10.minutes.from_now,
        check_in_date: Date.parse('2018-08-10'),
        check_out_date: Date.parse('2018-09-08'),
        user_token: 'abc123')

        create(:reservation,
        property: property,
        check_in_date: Date.parse('2018-08-13'),
        check_out_date: Date.parse('2018-09-01'))

        expect(CreateReservation).to receive(:call).and_call_original

        params = {
          reservation_lock_id: reservation_lock.id,
          reservation: {
            first_name: 'John',
            last_name: 'Doe',
            email: 'john@example.com'
          }
        }

        expect { post '/reservations', params: params }.not_to change { Reservation.count }

        expect(response).to have_http_status(422)

        expect(response).to redirect_to('/properties/1')
      end
    end
  end
end
