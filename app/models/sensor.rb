class Sensor < ApplicationRecord
    attr_accessor :latitude, :longitude

    belongs_to :user
    has_many :readings, dependent: :destroy
    has_one :latest_reading, -> { order(timestamp: :desc) }, class_name: 'Reading'

    validates :name, presence: true
    validates :sender_id, presence: true, uniqueness: true, format: { with: /\A![0-9a-fA-F]{8}\z/, message: "must be a valid Meshtastic node ID (e.g., !a1b2c3d4)" }
    validates :coordinates, presence: true
    validates :latitude, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
    validates :longitude, presence: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }

    before_validation :set_coordinates
    after_initialize :set_lat_lon_attributes

    private

    def set_coordinates
        if latitude.present? && longitude.present?
            self.coordinates = RGeo::Geos.factory.point(longitude.to_f, latitude.to_f)
        end
    end

    def set_lat_lon_attributes
        if coordinates.present?
            self.latitude ||= coordinates.y
            self.longitude ||= coordinates.x
        end
    end
end
