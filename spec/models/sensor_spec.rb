require 'rails_helper'

RSpec.describe Sensor, type: :model do
  let(:sensor) { build(:sensor) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(sensor).to be_valid
    end

    it 'is not valid without a name' do
      sensor.name = nil
      expect(sensor).not_to be_valid
      expect(sensor.errors[:name]).to include("can't be blank")
    end

    it 'is not valid without a sender_id' do
      sensor.sender_id = nil
      expect(sensor).not_to be_valid
      expect(sensor.errors[:sender_id]).to include("can't be blank")
    end

    it 'is not valid with a duplicate sender_id' do
      create(:sensor, sender_id: sensor.sender_id)
      expect(sensor).not_to be_valid
      expect(sensor.errors[:sender_id]).to include('has already been taken')
    end

    it 'is not valid with an invalid sender_id format' do
      sensor.sender_id = "invalid"
      expect(sensor).not_to be_valid
      expect(sensor.errors[:sender_id]).to include("must be a valid Meshtastic node ID (e.g., !a1b2c3d4)")
    end

    it 'is not valid if sender_id does not start with !' do
      sensor.sender_id = "a1b2c3d4"
      expect(sensor).not_to be_valid
      expect(sensor.errors[:sender_id]).to include("must be a valid Meshtastic node ID (e.g., !a1b2c3d4)")
    end

    it 'is not valid if sender_id has less than 8 hex characters' do
      sensor.sender_id = "!a1b2c3d"
      expect(sensor).not_to be_valid
      expect(sensor.errors[:sender_id]).to include("must be a valid Meshtastic node ID (e.g., !a1b2c3d4)")
    end

    it 'is not valid if sender_id has more than 8 hex characters' do
      sensor.sender_id = "!a1b2c3d4e"
      expect(sensor).not_to be_valid
      expect(sensor.errors[:sender_id]).to include("must be a valid Meshtastic node ID (e.g., !a1b2c3d4)")
    end

    it 'is not valid if sender_id contains non-hex characters' do
      sensor.sender_id = "!a1b2c3g4"
      expect(sensor).not_to be_valid
      expect(sensor.errors[:sender_id]).to include("must be a valid Meshtastic node ID (e.g., !a1b2c3d4)")
    end

    it 'is not valid without a latitude' do
      sensor.latitude = nil
      expect(sensor).not_to be_valid
      expect(sensor.errors[:latitude]).to include("can't be blank")
    end

    it 'is not valid without a longitude' do
      sensor.longitude = nil
      expect(sensor).not_to be_valid
      expect(sensor.errors[:longitude]).to include("can't be blank")
    end

    it 'is not valid with a latitude less than -90' do
      sensor.latitude = -91
      expect(sensor).not_to be_valid
      expect(sensor.errors[:latitude]).to include("must be greater than or equal to -90")
    end

    it 'is not valid with a latitude greater than 90' do
      sensor.latitude = 91
      expect(sensor).not_to be_valid
      expect(sensor.errors[:latitude]).to include("must be less than or equal to 90")
    end

    it 'is not valid with a longitude less than -180' do
      sensor.longitude = -181
      expect(sensor).not_to be_valid
      expect(sensor.errors[:longitude]).to include("must be greater than or equal to -180")
    end

    it 'is not valid with a longitude greater than 180' do
      sensor.longitude = 181
      expect(sensor).not_to be_valid
      expect(sensor.errors[:longitude]).to include("must be less than or equal to 180")
    end

    it 'sets the coordinates from latitude and longitude before validation' do
      sensor.latitude = 45.0
      sensor.longitude = -75.0
      sensor.valid?
      expect(sensor.coordinates.y).to eq(45.0)
      expect(sensor.coordinates.x).to eq(-75.0)
    end
  end
end