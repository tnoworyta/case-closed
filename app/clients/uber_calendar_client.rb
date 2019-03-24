class UberCalendarClient
  HOST_URL = 'www.example.com'

  def slot(datetime:, calendar_id:)
    response = HTTParty.get(
      URI::HTTP.build(host: HOST_URL,
                      path: "/ubercalendar/#{calendar_id}/#{datetime.strftime('%Y/%m/%d')}/slot",
                      query: {startAt: datetime.strftime('%H:%M'), endAt: (datetime+1.hour).strftime('%H:%M')}.to_query)
    )
    JSON.parse(response.body).deep_symbolize_keys!
  end
end
