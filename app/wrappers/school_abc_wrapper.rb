class SchoolAbcWrapper
  include Singleton

  class << self
    delegate :create_booking, to: :instance
  end

  def initialize
    @school_abc_client = SchoolAbcClient.new
  end

  def create_booking(pincode:, start_time:, end_time:, topic_id:)
    student_id = school_abc_client.student(pincode: pincode).fetch(:data, {}).fetch(:student, {}).fetch(:id, nil)
    booking = school_abc_client.create_booking(student_id: student_id,
    start_time: start_time,
    end_time: end_time,
    topic_id: topic_id)
    Booking.new(booking.fetch(:data, {}).fetch(:booking, {}))
  end

  private

  attr_reader :school_abc_client
end
