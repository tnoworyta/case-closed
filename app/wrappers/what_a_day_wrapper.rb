class WhatADayWrapper
  include Singleton

  def initialize
    @what_a_day_client = WhatADayClient.new
  end

  class << self
    delegate :timeslot_available?, to: :instance
  end

  def timeslot_available?(calendar_id:, start_time:)
    event_data = what_a_day_client.create_event(calendar_id: calendar_id, start_time: start_time)
    event_id = event_data[:event_id]
    what_a_day_client.delete_event(calendar_id: calendar_id, event_id: event_id) if event_id
    !!event_id
  end

  private

  attr_reader :what_a_day_client
end
