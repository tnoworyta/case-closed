class WhatADayClient
  HOST_URL = 'www.whataday.com'

  def create_event(calendar_id:, start_time:)
    response = HTTParty.post(URI::HTTP.build(host: HOST_URL, path: "/whataday/#{calendar_id}/events"), {
      body: "at=#{start_time.strftime('%Y-%m-%dT%H:%M:%S&duration=60&description=test event')}",
      headers: {
        'Content-Type' => 'application/x-www-form-urlencoded',
        'charset' => 'utf-8'
      }
    })
    response.success? ? JSON.parse(response.body).symbolize_keys : {}
  end

  def delete_event(calendar_id:, event_id:)
    response = HTTParty.delete(URI::HTTP.build(host: HOST_URL, path: "/#{calendar_id}/events/#{event_id}"))
    response.success?
  end
end
