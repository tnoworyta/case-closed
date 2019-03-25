require 'rails_helper'

RSpec.describe WhatADayClient do
  describe '#create_event' do
    context 'timeslot available' do
      it 'returns event id' do
        stub = stub_request(:post, 'www.whataday.com/whataday/111/events')
          .with(body: {at: '2019-05-01T12:00:00', duration: '60', description: 'test event' })
          .to_return(body: { event_id: 102 }.to_json, status: 200)

        expect(WhatADayClient.new.create_event(calendar_id: '111', start_time: Time.parse('2019-05-01 12:00')))
          .to eq({ event_id: 102 })
        expect(stub).to have_been_requested
      end
    end

    context 'timeslot not available' do
      it 'returns blank response' do
        stub = stub_request(:post, 'www.whataday.com/whataday/111/events')
          .with(body: {at: '2019-05-01T12:00:00', duration: '60', description: 'test event' })
          .to_return(body: { }.to_json, status: 500)

        expect(WhatADayClient.new.create_event(calendar_id: '111', start_time: Time.parse('2019-05-01 12:00')))
          .to eq({})
        expect(stub).to have_been_requested
      end
    end
  end

  describe '#delete_event' do
    it 'removes event' do
      stub = stub_request(:delete, 'www.whataday.com/111/events/102').to_return(status: 200)

      WhatADayClient.new.delete_event(calendar_id: '111', event_id: 102)
      expect(stub).to have_been_requested
    end
  end
end
