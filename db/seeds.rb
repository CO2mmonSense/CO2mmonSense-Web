# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb

puts "Seeding database with sensors and all historical readings... 🛰️"

# 1. Define the core information for each sensor.
# The `id` here is used to link to the readings data below.
sensor_locations = [
  { id: 1, name: "Sather Gate",                               sender_id: "!a0000001", lat: 37.870233, long: -122.259516 },
  { id: 2, name: "Memorial Glade",                            sender_id: "!a0000002", lat: 37.873171, long: -122.25939  },
  { id: 3, name: "Cory Hall",                                 sender_id: "!a0000003", lat: 37.87505,  long: -122.257573 },
  { id: 4, name: "Recreational Sports Facility (RSF)",        sender_id: "!a0000004", lat: 37.868681, long: -122.26277  },
  { id: 5, name: "Valley Life Sciences Building (VLSB)",      sender_id: "!a0000005", lat: 37.871441, long: -122.262489 },
  { id: 6, name: "Memorial Stadium",                          sender_id: "!a0000006", lat: 37.870983, long: -122.25073  },
  { id: 7, name: "Sproul Hall",                               sender_id: "!a0000007", lat: 37.869591, long: -122.258758 },
  { id: 8, name: "The Campanile",                             sender_id: "!a0000008", lat: 37.872058, long: -122.257819 }
]

# 2. Define the historical readings, keyed by the original sensor ID.
# Note: The keys are strings ('1', '2', etc.) to match the JSON structure.
historical_readings = {
  '1' => [
    { timestamp: "2025-07-09T22:30:00Z", pm10: 12.1, pm100: 18.3, pm25: 6.5, relative_humidity: 88.2, temperature: 12.5 },
    { timestamp: "2025-07-09T23:00:00Z", pm10: 10.5, pm100: 15.1, pm25: 5.8, relative_humidity: 90.1, temperature: 12.1 },
    { timestamp: "2025-07-10T00:00:00Z", pm10: 9.8, pm100: 14.5, pm25: 5.2, relative_humidity: 92.5, temperature: 11.8 },
    { timestamp: "2025-07-10T01:00:00Z", pm10: 8.2, pm100: 12.9, pm25: 4.1, relative_humidity: 94.0, temperature: 11.5 },
    { timestamp: "2025-07-10T02:00:00Z", pm10: 7.5, pm100: 11.8, pm25: 3.9, relative_humidity: 94.8, temperature: 11.2 },
    { timestamp: "2025-07-10T03:00:00Z", pm10: 8.1, pm100: 12.2, pm25: 4.2, relative_humidity: 95.1, temperature: 11.0 },
    { timestamp: "2025-07-10T04:00:00Z", pm10: 8.9, pm100: 13.1, pm25: 4.5, relative_humidity: 93.7, temperature: 11.1 },
    { timestamp: "2025-07-10T05:00:00Z", pm10: 9.2, pm100: 14.0, pm25: 4.8, relative_humidity: 92.1, temperature: 11.4 },
    { timestamp: "2025-07-10T06:00:00Z", pm10: 11.3, pm100: 16.2, pm25: 5.9, relative_humidity: 90.5, temperature: 11.9 },
    { timestamp: "2025-07-10T07:00:00Z", pm10: 15.8, pm100: 22.1, pm25: 8.1, relative_humidity: 88.2, temperature: 12.8 },
    { timestamp: "2025-07-10T08:00:00Z", pm10: 20.1, pm100: 28.3, pm25: 11.2, relative_humidity: 85.1, temperature: 13.9 },
    { timestamp: "2025-07-10T09:00:00Z", pm10: 18.9, pm100: 25.4, pm25: 9.9, relative_humidity: 82.3, temperature: 15.0 },
    { timestamp: "2025-07-10T10:00:00Z", pm10: 17.2, pm100: 24.1, pm25: 9.1, relative_humidity: 78.5, temperature: 16.5 },
    { timestamp: "2025-07-10T11:00:00Z", pm10: 16.5, pm100: 23.0, pm25: 8.8, relative_humidity: 74.2, temperature: 18.0 },
    { timestamp: "2025-07-10T12:00:00Z", pm10: 15.8, pm100: 22.5, pm25: 8.1, relative_humidity: 69.8, temperature: 19.8 },
    { timestamp: "2025-07-10T13:00:00Z", pm10: 15.1, pm100: 21.9, pm25: 7.9, relative_humidity: 65.1, temperature: 21.5 },
    { timestamp: "2025-07-10T14:00:00Z", pm10: 14.8, pm100: 20.5, pm25: 7.5, relative_humidity: 62.3, temperature: 22.8 },
    { timestamp: "2025-07-10T15:00:00Z", pm10: 15.0, pm100: 21.0, pm25: 7.7, relative_humidity: 60.1, temperature: 23.5 },
    { timestamp: "2025-07-10T16:00:00Z", pm10: 15.5, pm100: 22.1, pm25: 8.0, relative_humidity: 59.9, temperature: 23.2 },
    { timestamp: "2025-07-10T17:00:00Z", pm10: 18.9, pm100: 26.8, pm25: 9.8, relative_humidity: 61.5, temperature: 22.1 },
    { timestamp: "2025-07-10T18:00:00Z", pm10: 22.3, pm100: 31.2, pm25: 12.3, relative_humidity: 64.8, temperature: 20.5 },
    { timestamp: "2025-07-10T19:00:00Z", pm10: 20.1, pm100: 28.1, pm25: 11.1, relative_humidity: 68.9, temperature: 18.7 },
    { timestamp: "2025-07-10T20:00:00Z", pm10: 18.5, pm100: 25.9, pm25: 9.9, relative_humidity: 73.2, temperature: 17.1 },
    { timestamp: "2025-07-10T21:00:00Z", pm10: 16.9, pm100: 23.8, pm25: 9.1, relative_humidity: 78.1, temperature: 15.9 },
    { timestamp: "2025-07-10T22:00:00Z", pm10: 15.2, pm100: 22.1, pm25: 8.5, relative_humidity: 82.4, temperature: 14.9 },
  ],
  '2' => [
    { timestamp: "2025-07-09T22:30:00Z", pm10: 5.1, pm100: 8.3, pm25: 2.5, relative_humidity: 90.2, temperature: 12.0 },
    { timestamp: "2025-07-09T23:00:00Z", pm10: 4.5, pm100: 7.1, pm25: 2.1, relative_humidity: 92.1, temperature: 11.8 },
    { timestamp: "2025-07-10T00:00:00Z", pm10: 3.8, pm100: 6.5, pm25: 1.8, relative_humidity: 94.5, temperature: 11.5 },
    { timestamp: "2025-07-10T01:00:00Z", pm10: 3.2, pm100: 5.9, pm25: 1.5, relative_humidity: 96.0, temperature: 11.2 },
    { timestamp: "2025-07-10T02:00:00Z", pm10: 2.5, pm100: 4.8, pm25: 1.2, relative_humidity: 96.8, temperature: 10.9 },
    { timestamp: "2025-07-10T03:00:00Z", pm10: 2.1, pm100: 4.2, pm25: 1.0, relative_humidity: 97.1, temperature: 10.7 },
    { timestamp: "2025-07-10T04:00:00Z", pm10: 2.9, pm100: 5.1, pm25: 1.3, relative_humidity: 95.7, temperature: 10.8 },
    { timestamp: "2025-07-10T05:00:00Z", pm10: 3.2, pm100: 6.0, pm25: 1.6, relative_humidity: 94.1, temperature: 11.1 },
    { timestamp: "2025-07-10T06:00:00Z", pm10: 4.3, pm100: 7.2, pm25: 2.1, relative_humidity: 92.5, temperature: 11.5 },
    { timestamp: "2025-07-10T07:00:00Z", pm10: 6.8, pm100: 9.1, pm25: 3.5, relative_humidity: 90.2, temperature: 12.4 },
    { timestamp: "2025-07-10T08:00:00Z", pm10: 8.1, pm100: 11.3, pm25: 4.2, relative_humidity: 87.1, temperature: 13.5 },
    { timestamp: "2025-07-10T09:00:00Z", pm10: 7.9, pm100: 10.4, pm25: 3.9, relative_humidity: 84.3, temperature: 14.6 },
    { timestamp: "2025-07-10T10:00:00Z", pm10: 7.2, pm100: 9.1, pm25: 3.6, relative_humidity: 80.5, temperature: 16.1 },
    { timestamp: "2025-07-10T11:00:00Z", pm10: 6.5, pm100: 8.0, pm25: 3.1, relative_humidity: 76.2, temperature: 17.6 },
    { timestamp: "2025-07-10T12:00:00Z", pm10: 5.8, pm100: 7.5, pm25: 2.8, relative_humidity: 71.8, temperature: 19.4 },
    { timestamp: "2025-07-10T13:00:00Z", pm10: 5.1, pm100: 6.9, pm25: 2.5, relative_humidity: 67.1, temperature: 21.1 },
    { timestamp: "2025-07-10T14:00:00Z", pm10: 4.8, pm100: 6.5, pm25: 2.2, relative_humidity: 64.3, temperature: 22.4 },
    { timestamp: "2025-07-10T15:00:00Z", pm10: 5.0, pm100: 7.0, pm25: 2.4, relative_humidity: 62.1, temperature: 23.1 },
    { timestamp: "2025-07-10T16:00:00Z", pm10: 5.5, pm100: 8.1, pm25: 2.7, relative_humidity: 61.9, temperature: 22.8 },
    { timestamp: "2025-07-10T17:00:00Z", pm10: 8.9, pm100: 11.8, pm25: 4.8, relative_humidity: 63.5, temperature: 21.7 },
    { timestamp: "2025-07-10T18:00:00Z", pm10: 10.3, pm100: 14.2, pm25: 5.9, relative_humidity: 66.8, temperature: 20.1 },
    { timestamp: "2025-07-10T19:00:00Z", pm10: 9.1, pm100: 12.1, pm25: 4.9, relative_humidity: 70.9, temperature: 18.3 },
    { timestamp: "2025-07-10T20:00:00Z", pm10: 8.5, pm100: 11.9, pm25: 4.2, relative_humidity: 75.2, temperature: 16.7 },
    { timestamp: "2025-07-10T21:00:00Z", pm10: 6.9, pm100: 9.8, pm25: 3.5, relative_humidity: 80.1, temperature: 15.5 },
    { timestamp: "2025-07-10T22:00:00Z", pm10: 5.2, pm100: 8.1, pm25: 2.9, relative_humidity: 84.4, temperature: 14.5 },
  ],
  '3' => [
    { timestamp: "2025-07-09T22:30:00Z", pm10: 45.1, pm100: 68.3, pm25: 22.5, relative_humidity: 85.2, temperature: 13.5 },
    { timestamp: "2025-07-09T23:00:00Z", pm10: 42.5, pm100: 65.1, pm25: 21.8, relative_humidity: 87.1, temperature: 13.1 },
    { timestamp: "2025-07-10T00:00:00Z", pm10: 40.8, pm100: 64.5, pm25: 20.2, relative_humidity: 89.5, temperature: 12.8 },
    { timestamp: "2025-07-10T01:00:00Z", pm10: 38.2, pm100: 59.9, pm25: 18.1, relative_humidity: 91.0, temperature: 12.5 },
    { timestamp: "2025-07-10T02:00:00Z", pm10: 35.5, pm100: 55.8, pm25: 17.9, relative_humidity: 91.8, temperature: 12.2 },
    { timestamp: "2025-07-10T03:00:00Z", pm10: 36.1, pm100: 56.2, pm25: 18.2, relative_humidity: 92.1, temperature: 12.0 },
    { timestamp: "2025-07-10T04:00:00Z", pm10: 38.9, pm100: 61.1, pm25: 19.5, relative_humidity: 90.7, temperature: 12.1 },
    { timestamp: "2025-07-10T05:00:00Z", pm10: 42.2, pm100: 64.0, pm25: 21.8, relative_humidity: 89.1, temperature: 12.4 },
    { timestamp: "2025-07-10T06:00:00Z", pm10: 48.3, pm100: 71.2, pm25: 25.9, relative_humidity: 87.5, temperature: 12.9 },
    { timestamp: "2025-07-10T07:00:00Z", pm10: 60.8, pm100: 85.1, pm25: 33.1, relative_humidity: 85.2, temperature: 13.8 },
    { timestamp: "2025-07-10T08:00:00Z", pm10: 75.1, pm100: 102.3, pm25: 41.2, relative_humidity: 82.1, temperature: 14.9 },
    { timestamp: "2025-07-10T09:00:00Z", pm10: 70.9, pm100: 95.4, pm25: 38.9, relative_humidity: 79.3, temperature: 16.0 },
    { timestamp: "2025-07-10T10:00:00Z", pm10: 65.2, pm100: 91.1, pm25: 35.1, relative_humidity: 75.5, temperature: 17.5 },
    { timestamp: "2025-07-10T11:00:00Z", pm10: 60.5, pm100: 88.0, pm25: 31.8, relative_humidity: 71.2, temperature: 19.0 },
    { timestamp: "2025-07-10T12:00:00Z", pm10: 55.8, pm100: 82.5, pm25: 28.1, relative_humidity: 66.8, temperature: 20.8 },
    { timestamp: "2025-07-10T13:00:00Z", pm10: 52.1, pm100: 78.9, pm25: 26.9, relative_humidity: 62.1, temperature: 22.5 },
    { timestamp: "2025-07-10T14:00:00Z", pm10: 50.8, pm100: 75.5, pm25: 25.5, relative_humidity: 59.3, temperature: 23.8 },
    { timestamp: "2025-07-10T15:00:00Z", pm10: 51.0, pm100: 76.0, pm25: 25.7, relative_humidity: 57.1, temperature: 24.5 },
    { timestamp: "2025-07-10T16:00:00Z", pm10: 55.5, pm100: 82.1, pm25: 28.0, relative_humidity: 56.9, temperature: 24.2 },
    { timestamp: "2025-07-10T17:00:00Z", pm10: 68.9, pm100: 96.8, pm25: 35.8, relative_humidity: 58.5, temperature: 23.1 },
    { timestamp: "2025-07-10T18:00:00Z", pm10: 78.3, pm100: 111.2, pm25: 42.3, relative_humidity: 61.8, temperature: 21.5 },
    { timestamp: "2025-07-10T19:00:00Z", pm10: 72.1, pm100: 100.1, pm25: 38.1, relative_humidity: 65.9, temperature: 19.7 },
    { timestamp: "2025-07-10T20:00:00Z", pm10: 65.5, pm100: 92.9, pm25: 33.9, relative_humidity: 70.2, temperature: 18.1 },
    { timestamp: "2025-07-10T21:00:00Z", pm10: 58.9, pm100: 85.8, pm25: 30.1, relative_humidity: 75.1, temperature: 16.9 },
    { timestamp: "2025-07-10T22:00:00Z", pm10: 55.9, pm100: 80.2, pm25: 28.7, relative_humidity: 79.4, temperature: 15.5 },
  ],
  '4' => [
    { timestamp: "2025-07-09T22:30:00Z", pm10: 22.1, pm100: 33.3, pm25: 11.5, relative_humidity: 80.2, temperature: 14.5 },
    { timestamp: "2025-07-09T23:00:00Z", pm10: 20.5, pm100: 30.1, pm25: 10.8, relative_humidity: 82.1, temperature: 14.1 },
    { timestamp: "2025-07-10T00:00:00Z", pm10: 19.8, pm100: 29.5, pm25: 10.2, relative_humidity: 84.5, temperature: 13.8 },
    { timestamp: "2025-07-10T01:00:00Z", pm10: 18.2, pm100: 27.9, pm25: 9.1, relative_humidity: 86.0, temperature: 13.5 },
    { timestamp: "2025-07-10T02:00:00Z", pm10: 17.5, pm100: 26.8, pm25: 8.9, relative_humidity: 86.8, temperature: 13.2 },
    { timestamp: "2025-07-10T03:00:00Z", pm10: 18.1, pm100: 27.2, pm25: 9.2, relative_humidity: 87.1, temperature: 13.0 },
    { timestamp: "2025-07-10T04:00:00Z", pm10: 18.9, pm100: 28.1, pm25: 9.5, relative_humidity: 85.7, temperature: 13.1 },
    { timestamp: "2025-07-10T05:00:00Z", pm10: 19.2, pm100: 29.0, pm25: 9.8, relative_humidity: 84.1, temperature: 13.4 },
    { timestamp: "2025-07-10T06:00:00Z", pm10: 21.3, pm100: 31.2, pm25: 10.9, relative_humidity: 82.5, temperature: 13.9 },
    { timestamp: "2025-07-10T07:00:00Z", pm10: 25.8, pm100: 37.1, pm25: 13.1, relative_humidity: 80.2, temperature: 14.8 },
    { timestamp: "2025-07-10T08:00:00Z", pm10: 30.1, pm100: 43.3, pm25: 16.2, relative_humidity: 77.1, temperature: 15.9 },
    { timestamp: "2025-07-10T09:00:00Z", pm10: 28.9, pm100: 40.4, pm25: 14.9, relative_humidity: 74.3, temperature: 17.0 },
    { timestamp: "2025-07-10T10:00:00Z", pm10: 27.2, pm100: 39.1, pm25: 14.1, relative_humidity: 70.5, temperature: 18.5 },
    { timestamp: "2025-07-10T11:00:00Z", pm10: 26.5, pm100: 38.0, pm25: 13.8, relative_humidity: 66.2, temperature: 20.0 },
    { timestamp: "2025-07-10T12:00:00Z", pm10: 25.8, pm100: 37.5, pm25: 13.1, relative_humidity: 61.8, temperature: 21.8 },
    { timestamp: "2025-07-10T13:00:00Z", pm10: 25.1, pm100: 36.9, pm25: 12.9, relative_humidity: 57.1, temperature: 23.5 },
    { timestamp: "2025-07-10T14:00:00Z", pm10: 24.8, pm100: 35.5, pm25: 12.5, relative_humidity: 54.3, temperature: 24.8 },
    { timestamp: "2025-07-10T15:00:00Z", pm10: 25.0, pm100: 36.0, pm25: 12.7, relative_humidity: 52.1, temperature: 25.5 },
    { timestamp: "2025-07-10T16:00:00Z", pm10: 25.5, pm100: 37.1, pm25: 13.0, relative_humidity: 51.9, temperature: 25.2 },
    { timestamp: "2025-07-10T17:00:00Z", pm10: 28.9, pm100: 41.8, pm25: 14.8, relative_humidity: 53.5, temperature: 24.1 },
    { timestamp: "2025-07-10T18:00:00Z", pm10: 32.3, pm100: 46.2, pm25: 17.3, relative_humidity: 56.8, temperature: 22.5 },
    { timestamp: "2025-07-10T19:00:00Z", pm10: 30.1, pm100: 43.1, pm25: 16.1, relative_humidity: 60.9, temperature: 20.7 },
    { timestamp: "2025-07-10T20:00:00Z", pm10: 28.5, pm100: 40.9, pm25: 14.9, relative_humidity: 65.2, temperature: 19.1 },
    { timestamp: "2025-07-10T21:00:00Z", pm10: 26.9, pm100: 38.8, pm25: 14.1, relative_humidity: 70.1, temperature: 17.9 },
    { timestamp: "2025-07-10T22:00:00Z", pm10: 25.2, pm100: 37.1, pm25: 13.5, relative_humidity: 74.4, temperature: 16.2 },
  ],
  '5' => [
    { timestamp: "2025-07-09T22:30:00Z", pm10: 90.1, pm100: 125.3, pm25: 50.5, relative_humidity: 84.2, temperature: 13.8 },
    { timestamp: "2025-07-09T23:00:00Z", pm10: 85.5, pm100: 120.1, pm25: 48.8, relative_humidity: 86.1, temperature: 13.4 },
    { timestamp: "2025-07-10T00:00:00Z", pm10: 82.8, pm100: 118.5, pm25: 45.2, relative_humidity: 88.5, temperature: 13.1 },
    { timestamp: "2025-07-10T01:00:00Z", pm10: 78.2, pm100: 110.9, pm25: 42.1, relative_humidity: 90.0, temperature: 12.8 },
    { timestamp: "2025-07-10T02:00:00Z", pm10: 75.5, pm100: 105.8, pm25: 40.9, relative_humidity: 90.8, temperature: 12.5 },
    { timestamp: "2025-07-10T03:00:00Z", pm10: 76.1, pm100: 106.2, pm25: 41.2, relative_humidity: 91.1, temperature: 12.3 },
    { timestamp: "2025-07-10T04:00:00Z", pm10: 78.9, pm100: 111.1, pm25: 43.5, relative_humidity: 89.7, temperature: 12.4 },
    { timestamp: "2025-07-10T05:00:00Z", pm10: 82.2, pm100: 114.0, pm25: 46.8, relative_humidity: 88.1, temperature: 12.7 },
    { timestamp: "2025-07-10T06:00:00Z", pm10: 98.3, pm100: 131.2, pm25: 55.9, relative_humidity: 86.5, temperature: 13.2 },
    { timestamp: "2025-07-10T07:00:00Z", pm10: 110.8, pm100: 145.1, pm25: 63.1, relative_humidity: 84.2, temperature: 14.1 },
    { timestamp: "2025-07-10T08:00:00Z", pm10: 125.1, pm100: 162.3, pm25: 71.2, relative_humidity: 81.1, temperature: 15.2 },
    { timestamp: "2025-07-10T09:00:00Z", pm10: 120.9, pm100: 155.4, pm25: 68.9, relative_humidity: 78.3, temperature: 16.3 },
    { timestamp: "2025-07-10T10:00:00Z", pm10: 115.2, pm100: 151.1, pm25: 65.1, relative_humidity: 74.5, temperature: 17.8 },
    { timestamp: "2025-07-10T11:00:00Z", pm10: 110.5, pm100: 148.0, pm25: 61.8, relative_humidity: 70.2, temperature: 19.3 },
    { timestamp: "2025-07-10T12:00:00Z", pm10: 105.8, pm100: 142.5, pm25: 58.1, relative_humidity: 65.8, temperature: 21.1 },
    { timestamp: "2025-07-10T13:00:00Z", pm10: 102.1, pm100: 138.9, pm25: 56.9, relative_humidity: 61.1, temperature: 22.8 },
    { timestamp: "2025-07-10T14:00:00Z", pm10: 100.8, pm100: 135.5, pm25: 55.5, relative_humidity: 58.3, temperature: 24.1 },
    { timestamp: "2025-07-10T15:00:00Z", pm10: 101.0, pm100: 136.0, pm25: 55.7, relative_humidity: 56.1, temperature: 24.8 },
    { timestamp: "2025-07-10T16:00:00Z", pm10: 105.5, pm100: 142.1, pm25: 58.0, relative_humidity: 55.9, temperature: 24.5 },
    { timestamp: "2025-07-10T17:00:00Z", pm10: 118.9, pm100: 156.8, pm25: 65.8, relative_humidity: 57.5, temperature: 23.4 },
    { timestamp: "2025-07-10T18:00:00Z", pm10: 128.3, pm100: 171.2, pm25: 72.3, relative_humidity: 60.8, temperature: 21.8 },
    { timestamp: "2025-07-10T19:00:00Z", pm10: 122.1, pm100: 160.1, pm25: 68.1, relative_humidity: 64.9, temperature: 20.0 },
    { timestamp: "2025-07-10T20:00:00Z", pm10: 115.5, pm100: 152.9, pm25: 63.9, relative_humidity: 69.2, temperature: 18.4 },
    { timestamp: "2025-07-10T21:00:00Z", pm10: 108.9, pm100: 145.8, pm25: 60.1, relative_humidity: 74.1, temperature: 17.2 },
    { timestamp: "2025-07-10T22:00:00Z", pm10: 105.9, pm100: 140.2, pm25: 58.7, relative_humidity: 78.4, temperature: 15.8 },
  ],
  '6' => [
    { timestamp: "2025-07-09T22:30:00Z", pm10: 65.1, pm100: 93.3, pm25: 32.5, relative_humidity: 86.2, temperature: 13.2 },
    { timestamp: "2025-07-09T23:00:00Z", pm10: 62.5, pm100: 90.1, pm25: 31.8, relative_humidity: 88.1, temperature: 12.8 },
    { timestamp: "2025-07-10T00:00:00Z", pm10: 60.8, pm100: 89.5, pm25: 30.2, relative_humidity: 90.5, temperature: 12.5 },
    { timestamp: "2025-07-10T01:00:00Z", pm10: 58.2, pm100: 84.9, pm25: 28.1, relative_humidity: 92.0, temperature: 12.2 },
    { timestamp: "2025-07-10T02:00:00Z", pm10: 55.5, pm100: 80.8, pm25: 27.9, relative_humidity: 92.8, temperature: 11.9 },
    { timestamp: "2025-07-10T03:00:00Z", pm10: 56.1, pm100: 81.2, pm25: 28.2, relative_humidity: 93.1, temperature: 11.7 },
    { timestamp: "2025-07-10T04:00:00Z", pm10: 58.9, pm100: 86.1, pm25: 29.5, relative_humidity: 91.7, temperature: 11.8 },
    { timestamp: "2025-07-10T05:00:00Z", pm10: 62.2, pm100: 89.0, pm25: 31.8, relative_humidity: 90.1, temperature: 12.1 },
    { timestamp: "2025-07-10T06:00:00Z", pm10: 68.3, pm100: 96.2, pm25: 35.9, relative_humidity: 88.5, temperature: 12.6 },
    { timestamp: "2025-07-10T07:00:00Z", pm10: 80.8, pm100: 110.1, pm25: 43.1, relative_humidity: 86.2, temperature: 13.5 },
    { timestamp: "2025-07-10T08:00:00Z", pm10: 95.1, pm100: 127.3, pm25: 51.2, relative_humidity: 83.1, temperature: 14.6 },
    { timestamp: "2025-07-10T09:00:00Z", pm10: 90.9, pm100: 120.4, pm25: 48.9, relative_humidity: 80.3, temperature: 15.7 },
    { timestamp: "2025-07-10T10:00:00Z", pm10: 85.2, pm100: 116.1, pm25: 45.1, relative_humidity: 76.5, temperature: 17.2 },
    { timestamp: "2025-07-10T11:00:00Z", pm10: 80.5, pm100: 113.0, pm25: 41.8, relative_humidity: 72.2, temperature: 18.7 },
    { timestamp: "2025-07-10T12:00:00Z", pm10: 75.8, pm100: 107.5, pm25: 38.1, relative_humidity: 67.8, temperature: 20.5 },
    { timestamp: "2025-07-10T13:00:00Z", pm10: 72.1, pm100: 103.9, pm25: 36.9, relative_humidity: 63.1, temperature: 22.2 },
    { timestamp: "2025-07-10T14:00:00Z", pm10: 70.8, pm100: 100.5, pm25: 35.5, relative_humidity: 60.3, temperature: 23.5 },
    { timestamp: "2025-07-10T15:00:00Z", pm10: 71.0, pm100: 101.0, pm25: 35.7, relative_humidity: 58.1, temperature: 24.2 },
    { timestamp: "2025-07-10T16:00:00Z", pm10: 75.5, pm100: 107.1, pm25: 38.0, relative_humidity: 57.9, temperature: 23.9 },
    { timestamp: "2025-07-10T17:00:00Z", pm10: 88.9, pm100: 116.8, pm25: 45.8, relative_humidity: 59.5, temperature: 22.8 },
    { timestamp: "2025-07-10T18:00:00Z", pm10: 98.3, pm100: 131.2, pm25: 52.3, relative_humidity: 62.8, temperature: 21.2 },
    { timestamp: "2025-07-10T19:00:00Z", pm10: 92.1, pm100: 122.1, pm25: 48.1, relative_humidity: 66.9, temperature: 19.4 },
    { timestamp: "2025-07-10T20:00:00Z", pm10: 85.5, pm100: 115.9, pm25: 43.9, relative_humidity: 71.2, temperature: 17.8 },
    { timestamp: "2025-07-10T21:00:00Z", pm10: 78.9, pm100: 108.8, pm25: 40.1, relative_humidity: 76.1, temperature: 16.6 },
    { timestamp: "2025-07-10T22:00:00Z", pm10: 75.9, pm100: 105.2, pm25: 38.7, relative_humidity: 80.4, temperature: 15.2 },
  ],
  '7' => [
    { timestamp: "2025-07-09T22:30:00Z", pm10: 38.1, pm100: 58.3, pm25: 19.5, relative_humidity: 87.2, temperature: 12.9 },
    { timestamp: "2025-07-09T23:00:00Z", pm10: 35.5, pm100: 55.1, pm25: 18.8, relative_humidity: 89.1, temperature: 12.5 },
    { timestamp: "2025-07-10T00:00:00Z", pm10: 33.8, pm100: 53.5, pm25: 17.2, relative_humidity: 91.5, temperature: 12.2 },
    { timestamp: "2025-07-10T01:00:00Z", pm10: 31.2, pm100: 49.9, pm25: 15.1, relative_humidity: 93.0, temperature: 11.9 },
    { timestamp: "2025-07-10T02:00:00Z", pm10: 28.5, pm100: 45.8, pm25: 14.9, relative_humidity: 93.8, temperature: 11.6 },
    { timestamp: "2025-07-10T03:00:00Z", pm10: 29.1, pm100: 46.2, pm25: 15.2, relative_humidity: 94.1, temperature: 11.4 },
    { timestamp: "2025-07-10T04:00:00Z", pm10: 31.9, pm100: 49.1, pm25: 16.5, relative_humidity: 92.7, temperature: 11.5 },
    { timestamp: "2025-07-10T05:00:00Z", pm10: 35.2, pm100: 54.0, pm25: 18.8, relative_humidity: 91.1, temperature: 11.8 },
    { timestamp: "2025-07-10T06:00:00Z", pm10: 41.3, pm100: 61.2, pm25: 21.9, relative_humidity: 89.5, temperature: 12.3 },
    { timestamp: "2025-07-10T07:00:00Z", pm10: 50.8, pm100: 75.1, pm25: 28.1, relative_humidity: 87.2, temperature: 13.2 },
    { timestamp: "2025-07-10T08:00:00Z", pm10: 55.1, pm100: 82.3, pm25: 31.2, relative_humidity: 84.1, temperature: 14.3 },
    { timestamp: "2025-07-10T09:00:00Z", pm10: 51.9, pm100: 75.4, pm25: 28.9, relative_humidity: 81.3, temperature: 15.4 },
    { timestamp: "2025-07-10T10:00:00Z", pm10: 48.2, pm100: 71.1, pm25: 26.1, relative_humidity: 77.5, temperature: 16.9 },
    { timestamp: "2025-07-10T11:00:00Z", pm10: 45.5, pm100: 68.0, pm25: 24.8, relative_humidity: 73.2, temperature: 18.4 },
    { timestamp: "2025-07-10T12:00:00Z", pm10: 42.8, pm100: 62.5, pm25: 22.1, relative_humidity: 68.8, temperature: 20.2 },
    { timestamp: "2025-07-10T13:00:00Z", pm10: 40.1, pm100: 58.9, pm25: 20.9, relative_humidity: 64.1, temperature: 21.9 },
    { timestamp: "2025-07-10T14:00:00Z", pm10: 38.8, pm100: 55.5, pm25: 19.5, relative_humidity: 61.3, temperature: 23.2 },
    { timestamp: "2025-07-10T15:00:00Z", pm10: 39.0, pm100: 56.0, pm25: 19.7, relative_humidity: 59.1, temperature: 23.9 },
    { timestamp: "2025-07-10T16:00:00Z", pm10: 42.5, pm100: 62.1, pm25: 22.0, relative_humidity: 58.9, temperature: 23.6 },
    { timestamp: "2025-07-10T17:00:00Z", pm10: 48.9, pm100: 71.8, pm25: 25.8, relative_humidity: 60.5, temperature: 22.5 },
    { timestamp: "2025-07-10T18:00:00Z", pm10: 53.3, pm100: 78.2, pm25: 29.3, relative_humidity: 63.8, temperature: 20.9 },
    { timestamp: "2025-07-10T19:00:00Z", pm10: 50.1, pm100: 73.1, pm25: 27.1, relative_humidity: 67.9, temperature: 19.1 },
    { timestamp: "2025-07-10T20:00:00Z", pm10: 46.5, pm100: 67.9, pm25: 24.9, relative_humidity: 72.2, temperature: 17.5 },
    { timestamp: "2025-07-10T21:00:00Z", pm10: 42.9, pm100: 62.8, pm25: 22.1, relative_humidity: 77.1, temperature: 16.3 },
    { timestamp: "2025-07-10T22:00:00Z", pm10: 40.1, pm100: 60.6, pm25: 20.3, relative_humidity: 82.9, temperature: 13.4 },
  ],
  '8' => [
    { timestamp: "2025-07-09T22:30:00Z", pm10: 5.1, pm100: 8.3, pm25: 2.5, relative_humidity: 90.2, temperature: 12.0 },
    { timestamp: "2025-07-09T23:00:00Z", pm10: 4.5, pm100: 7.1, pm25: 2.1, relative_humidity: 92.1, temperature: 11.8 },
    { timestamp: "2025-07-10T00:00:00Z", pm10: 3.8, pm100: 6.5, pm25: 1.8, relative_humidity: 94.5, temperature: 11.5 },
    { timestamp: "2025-07-10T01:00:00Z", pm10: 3.2, pm100: 5.9, pm25: 1.5, relative_humidity: 96.0, temperature: 11.2 },
    { timestamp: "2025-07-10T02:00:00Z", pm10: 2.5, pm100: 4.8, pm25: 1.2, relative_humidity: 96.8, temperature: 10.9 },
    { timestamp: "2025-07-10T03:00:00Z", pm10: 2.1, pm100: 4.2, pm25: 1.0, relative_humidity: 97.1, temperature: 10.7 },
    { timestamp: "2025-07-10T04:00:00Z", pm10: 2.9, pm100: 5.1, pm25: 1.3, relative_humidity: 95.7, temperature: 10.8 },
    { timestamp: "2025-07-10T05:00:00Z", pm10: 3.2, pm100: 6.0, pm25: 1.6, relative_humidity: 94.1, temperature: 11.1 },
    { timestamp: "2025-07-10T06:00:00Z", pm10: 4.3, pm100: 7.2, pm25: 2.1, relative_humidity: 92.5, temperature: 11.5 },
    { timestamp: "2025-07-10T07:00:00Z", pm10: 6.8, pm100: 9.1, pm25: 3.5, relative_humidity: 90.2, temperature: 12.4 },
    { timestamp: "2025-07-10T08:00:00Z", pm10: 8.1, pm100: 11.3, pm25: 4.2, relative_humidity: 87.1, temperature: 13.5 },
    { timestamp: "2025-07-10T09:00:00Z", pm10: 7.9, pm100: 10.4, pm25: 3.9, relative_humidity: 84.3, temperature: 14.6 },
    { timestamp: "2025-07-10T10:00:00Z", pm10: 7.2, pm100: 9.1, pm25: 3.6, relative_humidity: 80.5, temperature: 16.1 },
    { timestamp: "2025-07-10T11:00:00Z", pm10: 6.5, pm100: 8.0, pm25: 3.1, relative_humidity: 76.2, temperature: 17.6 },
    { timestamp: "2025-07-10T12:00:00Z", pm10: 5.8, pm100: 7.5, pm25: 2.8, relative_humidity: 71.8, temperature: 19.4 },
    { timestamp: "2025-07-10T13:00:00Z", pm10: 5.1, pm100: 6.9, pm25: 2.5, relative_humidity: 67.1, temperature: 21.1 },
    { timestamp: "2025-07-10T14:00:00Z", pm10: 4.8, pm100: 6.5, pm25: 2.2, relative_humidity: 64.3, temperature: 22.4 },
    { timestamp: "2025-07-10T15:00:00Z", pm10: 5.0, pm100: 7.0, pm25: 2.4, relative_humidity: 62.1, temperature: 23.1 },
    { timestamp: "2025-07-10T16:00:00Z", pm10: 5.5, pm100: 8.1, pm25: 2.7, relative_humidity: 61.9, temperature: 22.8 },
    { timestamp: "2025-07-10T17:00:00Z", pm10: 8.9, pm100: 11.8, pm25: 4.8, relative_humidity: 63.5, temperature: 21.7 },
    { timestamp: "2025-07-10T18:00:00Z", pm10: 10.3, pm100: 14.2, pm25: 5.9, relative_humidity: 66.8, temperature: 20.1 },
    { timestamp: "2025-07-10T19:00:00Z", pm10: 9.1, pm100: 12.1, pm25: 4.9, relative_humidity: 70.9, temperature: 18.3 },
    { timestamp: "2025-07-10T20:00:00Z", pm10: 8.5, pm100: 11.9, pm25: 4.2, relative_humidity: 75.2, temperature: 16.7 },
    { timestamp: "2025-07-10T21:00:00Z", pm10: 6.9, pm100: 9.8, pm25: 3.5, relative_humidity: 80.1, temperature: 15.5 },
    { timestamp: "2025-07-10T22:00:00Z", pm10: 5.8, pm100: 8.2, pm25: 2.1, relative_humidity: 95.3, temperature: 11.7 },
  ]
}

puts "Creating default user..."
default_user = User.create!(
  first_name: 'Admin',
  last_name:  'User',
  email:      'admin@example.com',
  password:   'password'
)

# 3. Loop and create everything.
puts "Creating sensors and readings..."
sensor_locations.each do |sensor_info|
  # Create each sensor.
  sensor = Sensor.create!(
    name:       sensor_info[:name],
    sender_id:  sensor_info[:sender_id],
    latitude:   sensor_info[:lat],
    longitude:  sensor_info[:long],
    user:       default_user
  )
  puts "Created sensor: #{sensor.name}"

  # Get the readings for this sensor.
  readings_for_sensor = historical_readings[sensor_info[:id].to_s]

  # Create all readings for this sensor, one by one.
  if readings_for_sensor
    readings_for_sensor.each do |reading_data|
      sensor.readings.create!(reading_data)
    end
    puts "  - Added #{readings_for_sensor.count} readings."
  end
end

puts "---"
puts "Seeding finished. ✅"