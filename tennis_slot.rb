class TennisSlot
  def initialize(tennis_name, date, hour, court, reservation_keys)
    @tennis_name = tennis_name
    @date = date
    @hour = hour
    @court = court
    @reservation_keys = reservation_keys
  end

  attr_reader :tennis_name
  attr_reader :date
  attr_reader :hour
  attr_reader :court
  attr_reader :reservation_keys

  def to_s
    "tennis_name #{@tennis_name}\n" \
        "hour #{hour}\n" \
        "date #{@date}\n" \
        "court #{@date}\n"
  end
end