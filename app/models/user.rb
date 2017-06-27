class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    self.reservations.each_with_object([]) do |res, guestbook|
      guestbook << res.guest
    end
  end

  def hosts
    self.trips.each_with_object([]) do |trip, host_diary|
      host_diary << trip.listing.host
    end
  end

  def host_reviews
    self.reservations.each_with_object([]) do |res, review_list|
      review_list << res.review if res.review != nil
    end
  end


end
