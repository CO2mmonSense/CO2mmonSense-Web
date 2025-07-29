class User < ApplicationRecord
  include HasValidatedImage

  has_many :sensors, dependent: :destroy
  has_many :api_keys, as: :bearer, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, presence: true
  validates :last_name, presence: true

  has_one_attached :avatar
  validates_image :avatar, max_size: 5.megabytes
end
