class WhatADayCalendarClient
  HOST_URL = 'www.example.com'


  #at=2019-03-11T16:01:17
#duration=60
#description=breakfast at tiffanys

  def create_event(calendar_id:, datetime:)
    response = HTTParty.post(URI::HTTP.build(host: HOST_URL, path: "/whataday/#{calendar_id}/events"), {
      body: "at=#{datetime.strftime('%Y-%M-5dT%H:%M:%S')}&duration=60&description=breakfast at tiffanys",
      headers: {
        'Content-Type' => 'application/x-www-form-urlencoded',
        'charset' => 'utf-8'
      }
    })
    response.success? ? JSON.parse(response.body).deep_symbolize_keys : {}
  end

  def delete_event(calendar_id:, event_id:)
    HTTParty.delete(URI::HTTP.build(host: HOST_URL, path: "/whataday/#{calendar_id}/events/#{event_id}"))
  end
end
