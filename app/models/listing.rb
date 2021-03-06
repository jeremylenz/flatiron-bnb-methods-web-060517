class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  before_save :make_host
  before_destroy :make_regular_user
  validate :all_fields

  def make_host
    self.host.host = true
  end

  def make_regular_user
    if self.host.listings.empty?
      self.host.host = false
    end
  end

  def all_fields
    if self.address == nil
      errors.add(:address, "can't be blank")
    end
    if self.listing_type == nil
      errors.add(:listing_type, "can't be blank")
    end
    if self.title == nil
      errors.add(:title, "can't be blank")
    end
    if self.description == nil
      errors.add(:description, "can't be blank")
    end
    if self.price == nil
      errors.add(:price, "can't be blank")
    end
    if self.neighborhood == nil
      errors.add(:neighborhood, "can't be blank")
    end
  end


end
