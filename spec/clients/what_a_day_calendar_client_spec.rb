require 'rails_helper'

RSpec.describe WhatADayCalendarClient do
  describe '#create_event' do
    context 'timeslot available' do
      it 'creates event' do
        stub = stub_request(:post, 'www.example.com/whataday/111/events')
          .with(body: {at: "2019-00-5dT12:00:00", description: "breakfast at tiffanys", duration: "60"})
          .to_return(body: { event_id: 102 }.to_json)

        expect(WhatADayCalendarClient.new.create_event(datetime: Time.parse('2019-05-01 12:00'), calendar_id: '111')).to eq({event_id: 102})
        expect(stub).to have_been_requested
      end
    end

    context 'timeslot not available' do
      it 'does not creates event' do
        stub = stub_request(:post, 'www.example.com/whataday/111/events')
          .with(body: {at: "2019-00-5dT12:00:00", description: "breakfast at tiffanys", duration: "60"})
          .to_return(body: { }.to_json, status: 500)

        expect(WhatADayCalendarClient.new.create_event(datetime: Time.parse('2019-05-01 12:00'), calendar_id: '111')).to eq({})
        expect(stub).to have_been_requested
      end
    end
  end

  describe '#delete_event' do
    it 'deletes event' do
      stub = stub_request(:delete, 'www.example.com/whataday/111/events/102')

      WhatADayCalendarClient.new.delete_event(calendar_id: '111', event_id: '102')
      expect(stub).to have_been_requested
    end
  end
end
