class HolidayService
  def get_holiday
    get_url("api/v2/NextPublicHolidays/US")
  end

  def get_url(url)
    response = HTTParty.get("https://date.nager.at/#{url}")
    JSON.parse(response.body, symbolize_names: true)
  end


  # def get_url(url)
  #   response = HTTParty.get(url)
  #   JSON.parse(response.body, aymbolize_names: true)
  # end
  #
  # def all_holidays(year)
  #   get_url("https://date.nager.at/api/v3/PublicHolidays/#{year}/US")
  # end
end
