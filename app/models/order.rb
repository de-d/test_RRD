class Order < ApplicationRecord
  validates :first_name, :last_name, :middle_name, :phone, :email,
    :weight, :length, :width, :height, :from, :to,
    presence: true
  def self.ransackable_attributes(auth_object = nil)
    %w[
      id first_name last_name middle_name phone email
      weight length width height from to distance price
      created_at updated_at
    ]
  end
end
