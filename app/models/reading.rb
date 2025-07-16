class Reading < ApplicationRecord
  belongs_to :sensor

  def value_for(metric_key)
    if self.respond_to?(metric_key)
      self.send(metric_key)
    else 
      self.send(:pm25)
    end
  end

  def color_for(metric_key)
    value = self.value_for(metric_key)

    case metric_key.to_sym
    when :pm25
      case value
      when 0..12 then :green
      when 12..35 then :yellow
      when 35..55 then :orange
      when 55..150 then :red
      else :purple
      end
    when :pm10
      case value
      when 0..54 then :green
      when 54..154 then :yellow
      when 154..254 then :orange
      when 254..354 then :red
      else :purple
      end
    when :pm100
      case value
      when 0..100 then :green
      when 100..250 then :yellow
      when 250..400 then :orange
      when 400..600 then :red
      else :purple
      end
    when :co2
      case value
      when 0..800 then :green
      when 800..1000 then :yellow
      when 1000..1500 then :orange
      when 1500..2000 then :red
      else :purple
      end
    when :relative_humidity
      if 40..50 then :green
      elsif 30..60 then :yellow
      elsif 20..70 then :orange
      elsif 10..80 then :red
      else :purple
      end
    when :temperature
      if value > 28 then :hot
      elsif 18..28 then :warm
      elsif 5..18 then :cool
      else :freezing
      end
    else
      :gray
    end
  end
end
