class Book < ApplicationRecord
  belongs_to :user

  has_many :novelties

  scope :ginga, -> { where(title: "銀河鉄道の夜") }
end
