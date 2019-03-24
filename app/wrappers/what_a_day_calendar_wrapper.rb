class WhatADayCalendarWrapper
  include Singleton

  class << self
    delegate :timeslot_available?, to: :instance
  end

  def initialize
    @what_a_day_calendar_client = WhatADayCalendarClient.new
  end

  def timeslot_available?(calendar_id:, datetime:)
    event_data = what_a_day_calendar_client.create_event(calendar_id: '111', datetime: Time.parse('2019-05-01 12:00'))
    event_id = event_data[:event_id]
    if event_id
      what_a_day_calendar_client.delete_event(calendar_id: '111', event_id: event_id)
      true
    end
  end

  private

  attr_reader :what_a_day_calendar_client
end
