class User < ApplicationRecord
  has_many :books

  validates :name,
    presence: true,
    length: { minimum: 1, maximum: 80 }

  validates :email,
    presence: true,
    uniqueness: { message: "指定した%{attribute}で登録済のユーザーが存在します" },
    format: { with: URI::MailTo::EMAIL_REGEXP, message: "%{attribute}の形式が不正です" }

  validates :birthday,
    presence: true

  validates :gender,
    presence: true,
    inclusion: { in: [ 1, 2 ], messsage: "%{attribute}は不正な値です" }

  validates :bio,
    length: { maximum: 400 }

  validates :amount_min,
    presence: true,
    numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 9999 }

  validates :amount_max,
    presence: true,
    numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 9999 }

  validate :valid_birthday
  validate :amount_min_less_than_or_equal_amount_max

  private
    def valid_birthday
      if errors[:birthday].empty? === false
        return
      end

      unless birthday =~ /\A\d{4}-\d{2}-\d{2}\z/
        errors.add(:birthday, :data_format)
        return
      end

      begin
        if Date.parse(birthday) > Date.today
          errors.add(:birthday, :date_invalid)
        end
      rescue ArgumentError
        errors.add(:birthday, :date_invalid)
      end
    end

    def amount_min_less_than_or_equal_amount_max
      if errors[:amount_min].empty? && errors[:amount_max].empty? && amount_min > amount_max
        errors.add(:amount_min, :greater_than_or_equal, other: "金額上限") # TODO: 金額上限をハードコードしたくない。属性名を取得したい
      end
    end
end
