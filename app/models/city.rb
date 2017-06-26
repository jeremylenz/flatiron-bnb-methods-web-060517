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

  def self.highest_ratio_res_to_listings #testing
    result = City.all.each_with_object({}) do |city, ratio_list|
      # for each city,
      # count the number of listings
      # then count the number of reservations on each listing and add them up
      # then assign a score which is reservations divided by listings
      num_of_listings = city.listings.length
      num_of_reservations = city.listings.all.inject(0) do |memory, next_listing|
        memory + next_listing.reservations.length
      end
      ratio_list[city] = num_of_reservations.to_f / num_of_listings.to_f
    end
    result.key(result.values.max)
  end


end
