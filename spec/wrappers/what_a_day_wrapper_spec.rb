require 'rails_helper'

RSpec.describe WhatADayWrapper do
  describe '#timeslot_available?' do
    context 'timeslot is available' do
      it 'returns true' do
        expect_any_instance_of(WhatADayClient)
          .to receive(:create_event)
          .with(calendar_id: '111', start_time: Time.parse('2019-05-01 12:00')) { { event_id: 102 } }

        expect_any_instance_of(WhatADayClient)
          .to receive(:delete_event).with(calendar_id: '111', event_id: 102)

        expect(WhatADayWrapper.timeslot_available?(calendar_id: '111', start_time: Time.parse('2019-05-01 12:00'))).to be true
      end
    end

    context 'timeslot is available' do
      it 'returns false' do
        expect_any_instance_of(WhatADayClient)
          .to receive(:create_event)
          .with(calendar_id: '111', start_time: Time.parse('2019-05-01 12:00')) { {} }

        expect(WhatADayWrapper.timeslot_available?(calendar_id: '111', start_time: Time.parse('2019-05-01 12:00'))).to be false
      end
    end
  end
end

