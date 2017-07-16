class TennisSlot
  def initialize(tennis_name, date, hour, court, reservation_keys)
    @tennis_name = tennis_name
    @date = date
    @hour = hour
    @court = court
    @reservation_keys = reservation_keys
  end
end