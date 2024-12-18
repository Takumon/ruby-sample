class RequestGetUsers
  include ActiveModel::Model
  attr_accessor :page, :limit_value

  validates :page, presence: false, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :limit_value, presence: false, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  def initialize(params)
    @page = params[:page] || 1
    @limit_value = params[:limit_value] || 10
  end
end
