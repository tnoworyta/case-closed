require 'rails_helper'

RSpec.describe WhatADayCalendarWrapper do
  describe '#timeslot_available?' do
    context 'timeslot is available' do
      it 'returns true' do
        expect_any_instance_of(WhatADayCalendarClient)
          .to receive(:create_event)
          .with(calendar_id: '111', datetime: Time.parse('2019-05-01 12:00')) { { event_id: 102 } }

        expect_any_instance_of(WhatADayCalendarClient)
          .to receive(:delete_event).with(calendar_id: '111', event_id: 102)

        expect(WhatADayCalendarWrapper.timeslot_available?(calendar_id: '111', datetime: Time.parse('2019-05-01 12:00'))).to be_truthy
      end
    end

    context 'timeslot is not available' do
      it 'returns false' do
        expect_any_instance_of(WhatADayCalendarClient)
          .to receive(:create_event)
          .with(calendar_id: '111', datetime: Time.parse('2019-05-01 12:00')) { { } }

        expect_any_instance_of(WhatADayCalendarClient)
          .not_to receive(:delete_event)

        expect(WhatADayCalendarWrapper.timeslot_available?(calendar_id: '111', datetime: Time.parse('2019-05-01 12:00'))).to be_falsey
      end
    end
  end
end
