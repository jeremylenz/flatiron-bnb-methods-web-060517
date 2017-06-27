class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validate :has_checkin_and_checkout, :shenanigans_1, :availability

  def conflicts? (desired_checkin, desired_checkout)
    return nil if desired_checkin == nil || desired_checkout == nil
    if self.checkout < desired_checkin || self.checkin > desired_checkout
      # puts "Reservation for #{self.checkin} to #{self.checkout} is ok."
      return false
    else
      # puts "Reservation for #{self.checkin} to #{self.checkout} conflicts."
      return true
    end
  end

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    self.listing.price * self.duration
  end

  def has_checkin_and_checkout
    if self.checkin == nil
      errors.add(:checkin, "must have a checkin date")
    end
    if self.checkout == nil
      errors.add(:checkout, "must have a checkout date")
    end
  end

  def shenanigans_1
    if self.guest == self.listing.host
      errors.add(:guest, "You cannot make a reservation on your own listing")
    end
  end

  def availability
    all_except_self = self.listing.reservations.select { |res| res != self }
    has_conflicting = all_except_self.detect do |reservation|
      reservation.conflicts?(self.checkin, self.checkout)
    end
    if has_conflicting
      errors.add(:checkin, "Reservation conflicts with another reservation")
      errors.add(:checkout, "Reservation conflicts with another reservation")
    end
  end



end
