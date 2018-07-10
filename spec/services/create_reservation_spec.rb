Rspec.describe 'CreateReservation' do
  describe '.call' do
    context 'no prior overlapping reservation exists' do
      it 'creates reservation' do
        reservation_lock = create(:reservation_lock)
        reservation = CreateReservation.call(reservation_lock: reservation_lock,
                               first_name: 'John',
                               last_name: 'Doe',
                               email: 'john@example.com')

        expect(reservation).to be_persisted
        expect(reservation.property).to eq(reservation_lock.property)
        expect(reservation.check_in_date).to eq(reservation_lock.check_in_date)
        expect(reservation.check_out_date).to eq(reservation_lock.check_out_date)
        expect(reservation.first_name).to eq('John')
        expect(reservation.last_name).to eq('Doe')
        expect(reservation.email).to eq('john@example.com')
      end
    end

    context 'overlapping reservation exists' do
      it 'does not create reservation' do
        property = create(:property)
        create(:reservation,
                property: property,
                check_in_date: Date.parse('2018-08-08'),
                check_out_date: Date.parse('2018-09-08'))
        reservation_lock = create(:reservation_lock,
                                  property: property,
                                  check_in_date: Date.parse('2018-08-09'),
                                  check_out_date: Date.parse('2018-09-01'))
        reservation = CreateReservation.call(reservation_lock: reservation_lock,
                               first_name: 'John',
                               last_name: 'Doe',
                               email: 'john@example.com')

        expect(reservation).to be_new_record
        expect(reservation).to have(1).errors_on(:check_in_date)
        expect(reservation).to have(1).errors_on(:check_out_date)
      end
    end
  end
end
