class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  def conflicts? (desired_checkin, desired_checkout)
    if self.checkout < desired_checkin || self.checkin > desired_checkout
      puts "Reservation for #{self.checkin} to #{self.checkout} is ok."
      return false
    else
      puts "Reservation for #{self.checkin} to #{self.checkout} conflicts."
      return true
    end
  end

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    self.listing.price * self.duration
  end

end
