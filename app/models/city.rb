class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    t1 = Date.parse(start_date)
    t2 = Date.parse(end_date)
    squirrel = Listing.all.select do |listing|
      acorn = listing.reservations.select do |reservation|
        reservation.checkout < t1 || reservation.checkin > t2
        binding.pry
      end
      !acorn.empty?
    end
    squirrel << Listing.all.select do |listing|
      listing.reservations.empty?
    end
    squirrel.flatten
    binding.pry
  end
end
