class Metric
    attr_reader :key, :label

    METRICS = {
        pm25: "PM 2.5",
        pm10: "PM 10",
        pm100: "PM 100",
        co2: "CO₂",
        relative_humidity: "Relative Humidity",
        temperature: "Temperature"
    }.freeze

    def initialize(key, label)
        @key = key
        @label = label
    end

    def self.find(key)
        return default if key.blank?
        key = key.to_sym
        return default unless METRICS.key?(key)
        new(key, METRICS[key])
    end

    def self.all
        METRICS.map { |key, label| new(key, label) }
    end

    def self.default
        find(:pm25)
    end
end