module Search
  def self.distance(from_x, from_y, to_x, to_y)
    from_x = from_x * Math::PI / 180
    from_y = from_y * Math::PI / 180
    to_x = to_x * Math::PI / 180
    to_y = to_y * Math::PI / 180
    earth_r = 6378140
    
    deg = Math::sin(from_y) * Math::sin(to_y) + Math::cos(from_y) * Math::cos(to_y) * Math::cos(to_x - from_x)
    distance = earth_r * (Math::atan(-deg / Math::sqrt(-deg * deg + 1)) + Math::PI / 2) / 1000
  end
end