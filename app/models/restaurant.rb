class Restaurant < ActiveRecord::Base
  validates :ref, uniqueness: true
  
  has_many :reviews
  accepts_nested_attributes_for :reviews
  
  def to_param
    "#{id}-#{name}"
  end
end
