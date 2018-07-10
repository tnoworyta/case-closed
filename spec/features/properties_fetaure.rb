RSpec.describe 'Properties list' do
  scenario do
    behavior 'Guest browse properties list', using: 'PropertiesController#index' do
      create(:property, name: 'House 1', description: 'Some house description')

      visit '/properties'

      expect(page).to have_table_row('House 1', 'Show')
    end

    behavior 'Guest views details of chosen property', using: 'PropertiesController#show' do
      create(:property, name: 'House 1', description: 'Some house description')

      visit '/properties'

      expect(page).to have_table_row('House 1', 'Show')

      within '.property-1' do
        click_on 'Show'
      end

      expect(page.current_path).to eq('/properties/1')

      expect(page).to have_content('House 1')
      expect(page).to have_content('Some house description')
      expect(page).to have_field('Check-in date')
      expect(page).to have_field('Check-out date')
      expect(page).to have_button('Check availability and book property')
    end
  end
end
