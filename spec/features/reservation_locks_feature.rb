RSpec.describe 'Reservation locks' do
  scenario do
    behaviour 'Guest successfuly starts reservation process' do
      create(:property, name: 'House 1', description: 'Some house description')

      visit '/properties/1'

      fill_in 'Check-in date' with '2018-08-08'
      fill_in 'Check-out date' with '2018-09-08'

      click_on 'Check availability and book property'

      expect(page.current_path).to eq('/properties/1/reservations/new')
    end

    behaviour 'Guest cannot start reservation process if overlapping reservation exists' do
      property = create(:property, name: 'House 1', description: 'Some house description')
      create(:reservation, property: property,
                           check_in_date: Date.parse('2018-08-10'),
                           check_out_date: Date.parse('2018-10-01'),
                           state: 'finalized')

      visit '/properties/1'

      fill_in 'Check-in date' with '2018-08-08'
      fill_in 'Check-out date' with '2018-09-08'

      click_on 'Check availability and book property'

      expect(page.current_path).to eq('/properties/1')

      expect(page).to have_content('This property is already booked at this time.')
    end

    behaviour 'Guest cannot start reservation process if someone else already started it' do
      property = create(:property, name: 'House 1', description: 'Some house description')
      create(:reservation_lock, property: property,
                           check_in_date: Date.parse('2018-08-10'),
                           check_out_date: Date.parse('2018-10-01'),
                           locked_until: 10.minutes.from_now,
                           user_token: 'ABC')

      visit '/properties/1'

      fill_in 'Check-in date' with '2018-08-08'
      fill_in 'Check-out date' with '2018-09-08'

      click_on 'Check availability and book property'

      expect(page.current_path).to eq('/properties/1')

      expect(page).to have_content('This property is being booked by someone else.')
      expect(page).to have_content('Please wait 10 minutes and try again.')
    end
  end
end

