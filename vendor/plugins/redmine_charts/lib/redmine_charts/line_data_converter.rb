module RedmineCharts
  module LineDataConverter

    if defined?(Redmine::I18n)
      include Redmine::I18n
    else
      extend ChartsI18nPatch
    end

    def self.convert(chart, data)
      index = 0

      data[:sets].each do |set|
        line = OpenFlashChart::LineDot.new
        line.text = set[0]
        line.width = 2
        line.colour = RedmineCharts::Utils.color(index)
        line.dot_size =  2

        j = -1

        vals = set[1].collect do |v|
          j += 1
          if v.is_a? Array
            d = OpenFlashChart::Base.new
            d.set_value(v[0])
            if v[2]
              d.dot_size = 4
            end
            d.set_colour(RedmineCharts::Utils.color(index))
            d.set_tooltip("#{v[1]}<br>#{data[:labels][j]}") unless v[1].nil?
            d
          else
            v
          end
        end

        line.values = vals

        chart.add_element(line)
        index += 1
      end
    end

  end
end
