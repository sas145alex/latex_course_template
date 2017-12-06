class Shelf < ActiveRecord::Base
  belongs_to :hall 
  accepts_nested_attributes_for :hall
  has_many :locations, dependent: :destroy
  accepts_nested_attributes_for :locations
  has_many :books, through: :locations
end
