class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
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
    result = Neighborhood.all.each_with_object({}) do |hood, ratio_list|
      num_of_listings = hood.listings.length
      if num_of_listings == 0
        ratio_list[hood] = 0.to_f
      else
        ratio_list[hood] = hood.num_of_reservations.to_f / num_of_listings.to_f
      end
    end
    result = result.key(result.values.max)
  end

  def self.most_res
    Neighborhood.all.inject(Neighborhood.all.first) do |champ, next_hood|
      next_hood.num_of_reservations > champ.num_of_reservations ? next_hood : champ
    end
  end

  def num_of_reservations
    self.listings.all.inject(0) do |memory, next_listing|
      memory + next_listing.reservations.length
    end
  end



end
