class SchoolAbcClient
  HOST_URL = 'www.example.com'

  def student(pincode:)
    response = HTTParty.get(URI::HTTP.build(host: HOST_URL, path: '/student', query: {pincode: pincode.to_s}.to_query),
    { headers: { "Authorization" => "Bearer #{ENV.fetch('API_TOKEN')}" }  })
    response.success? ? JSON.parse(response.body).deep_symbolize_keys! : {}
  end

  def create_booking(student_id:, start_time:, end_time:, topic_id:)

  end
end
