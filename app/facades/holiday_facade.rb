class HolidayFacade
  def holidays
    service.get_holiday.first(3).map do |data|
      Holiday.new(data)
    end
  end

  def service
    @_service ||= HolidayService.new
  end
end
