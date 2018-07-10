RSpec.describe 'Reservations' do
  scenario do
    behaviour 'Guest successfully finalizes reservation' do
      create(:property, name: 'House 1', description: 'Some house description')

      visit '/properties/1'

      fill_in 'Check-in date' with '2018-08-08'
      fill_in 'Check-out date' with '2018-09-08'

      click_on 'Check availability and book property'

      expect(page.current_path).to eq('/properties/1/reservations/new')

      expect(page).to have_table_row('Property name' => 'House 1',
                                     'Check-in date' => '2018-08-08',
                                     'Check-out date' => '2018-09-08')

      expect(page).to have_field('First name')
      expect(page).to have_field('Last name')
      expect(page).to have_field('E-mail')
      expect(page).to have_button('Finalize')

      fill_in 'First name', with: 'John'
      fill_in 'Last name', with: 'Doe'
      fill_in 'E-mail', with: 'john@example.com'
      click_on 'Finalize'

      expect(page.current_path).to eq('/properties/1/reservations/1')

      expect(page).to have_content('Reservation successfully created.')

      expect(page).to have_table_row('Property name' => 'House 1',
                                      'Check-in date' => '2018-08-08',
                                      'Check-out date' => '2018-09-08')
    end

    behaviour 'Guest fails to finalize a reservation when other reservation was made' do
      property = create(:property, name: 'House 1', description: 'Some house description')

      visit '/properties/1'

      fill_in 'Check-in date' with '2018-08-08'
      fill_in 'Check-out date' with '2018-09-08'

      click_on 'Check availability and book property'

      expect(page.current_path).to eq('/properties/1/reservations/new?reservation_lock=1')

      expect(page).to have_table_row('Property name' => 'House 1',
                                     'Check-in date' => '2018-08-08',
                                     'Check-out date' => '2018-09-08')

      create(:reservation, property: property,
                           check_in_date: Date.parse('2018-08-08'),
                           check_out_date: Date.parse('2018-09-08'))

      fill_in 'First name', with: 'John'
      fill_in 'Last name', with: 'Doe'
      fill_in 'E-mail', with: 'john@example.com'
      click_on 'Finalize'

      expect(page.current_path).to eq('/properties/1')

      expect(page).to have_content('This property was booked by somebody else.')

    end
  end
end

