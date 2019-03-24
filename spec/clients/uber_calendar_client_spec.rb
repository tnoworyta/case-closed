require 'rails_helper'

RSpec.describe UberCalendarClient do
  describe '#slot' do
    context 'timeslot available' do
      it 'returns availability' do
        stub_request(:get, 'www.example.com/ubercalendar/111/2019/05/01/slot?startAt=12:00&endAt=13:00')
          .to_return(body: { available: true }.to_json, status: 200)

        expect(UberCalendarClient.new.slot(datetime: Time.parse('2019-05-01 12:00'), calendar_id: '111')).to eq({ available: true })
      end
    end

    context 'timeslot not available' do
      it 'returns availability' do
        stub_request(:get, 'www.example.com/ubercalendar/111/2019/05/01/slot?startAt=12:00&endAt=13:00')
          .to_return(body: { available: false }.to_json, status: 200)

        expect(UberCalendarClient.new.slot(datetime: Time.parse('2019-05-01 12:00'), calendar_id: '111')).to eq({ available: false })
      end
    end
  end
end
