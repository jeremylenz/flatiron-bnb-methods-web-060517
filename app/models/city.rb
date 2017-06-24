class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    t1 = Date.parse(start_date)
    t2 = Date.parse(end_date)
    puts "Checking #{self.name} availability for #{t1} through #{t2}..."
    squirrel = self.listings.to_a
    squirrel.select! do |listing|
      acorn = listing.reservations.select do |reservation|  # List all the reservations that conflict
        reservation.conflicts?(t1, t2)
      end
      # binding.pry
      acorn.empty?  # If the list is empty, add the listing to the array of available listings.
    end
    squirrel.flatten!
    puts "Returning #{squirrel.length} listings."
    squirrel
  end


end
