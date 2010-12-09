module RedmineCharts
  module RangeUtils

    include Redmine::I18n

    @@types = [ :months, :weeks, :days ]
    @@days_per_year = 366
    @@weeks_per_year = 53
    @@months_per_year = 12
    @@seconds_per_day = 86400

    def self.types
      @@types
    end

    def self.options
      @@types.collect do |type|
        [l("charts_show_last_#{type}".to_sym), type]

      end
    end

    def self.default_range
      { :range => :weeks, :limit => 20, :offset => 0 }
    end

    def self.from_params(params)
      if params[:range] and params[:offset] and params[:limit]
        range = {}
        range[:range] = params[:range] ? params[:range].to_sym : :weeks
        range[:offset] = Integer(params[:offset])
        range[:limit] = Integer(params[:limit])
        range
      else
        nil
      end
    end

    def self.propose_range_for_two_dates(start_date, end_date)
      diff = diff(format_day(start_date), format_day(end_date), @@days_per_year) + 1
      offset = ((Time.now - end_date.to_time)/@@seconds_per_day).floor
      { :range => :days, :offset => offset, :limit => diff}
    end

    def self.propose_range(start_date)
      if (diff = diff(start_date[:day], current_day, @@days_per_year)) <= 20
        type = :days
      elsif (diff = diff(start_date[:week], current_week, @@weeks_per_year)) <= 20
        type = :weeks
      else
        (diff = diff(start_date[:month], current_month, @@months_per_year))
        type = :months
      end

      diff = 10 if diff < 10

      { :range => type, :offset => 0, :limit => diff + 1}
    end

    def self.prepare_range(range)
      keys = []
      labels = []

      limit = range[:limit] - 1

      if range[:range] == :days
        current, label = subtract_day(current_day, range[:offset])

        keys << current
        labels << label

        limit.times do
          current, label = subtract_day(current, 1)
          keys << current
          labels << label
        end
      elsif range[:range] == :weeks
        current, label = subtract_week(current_week, range[:offset])

        keys << current
        labels << label

        limit.times do
          current, label = subtract_week(current, 1)
          keys << current
          labels << label
        end
      else
        current, label = subtract_month(current_month, range[:offset])

        keys << current
        labels << label

        limit.times do
          current, label = subtract_month(current, 1)
          keys << current
          labels << label
        end
      end

      keys.reverse!
      labels.reverse!

      range[:keys] = keys
      range[:labels] = labels
      range[:max] = keys.last
      range[:min] = keys.first

      range
    end

    private

    def self.format_week(date)
      date.strftime('%Y0%W')
    end

    def self.format_month(date)
      date.strftime('%Y0%m')
    end

    def self.format_day(date)
      date.strftime('%Y%j')
    end

    def self.current_week
      format_week(Time.now)
    end

    def self.current_month
      format_month(Time.now)
    end

    def self.current_day
      format_day(Time.now)
    end

    def self.date_from_week(year_and_week_of_year)
      week_of_year = year_and_week_of_year.to_s[4...7].to_i
      year = year_and_week_of_year.to_s[0...4].to_i
      Time.mktime(year) + (week_of_year-1).weeks
    end

    def self.date_from_month(year_and_month)
      month = year_and_month.to_s[4...7].to_i
      year = year_and_month.to_s[0...4].to_i
      Time.mktime(year,month)
    end

    def self.date_from_day(year_and_day_of_year)
      day_of_year = year_and_day_of_year.to_s[4...7].to_i
      year = year_and_day_of_year.to_s[0...4].to_i
      Time.mktime(year) + (day_of_year-1).days
    end

    def self.diff(from, to, per_year)
      year_diff = to.to_s[0...4].to_i - from.to_s[0...4].to_i
      diff = to.to_s[4...7].to_i - from.to_s[4...7].to_i
      (year_diff * per_year) + diff
    end

    def self.subtract_month(current, offset)
      date = date_from_month(current) - offset.months
      [date.strftime("%Y0%m"), date.strftime("%b %y")]
    end

    def self.subtract_week(current, offset)
      year = current[0..3].to_i
      week_of_year = current[4..6].to_i

      year -= offset/@@weeks_per_year
      offset %= @@weeks_per_year

      if week_of_year > offset
        week_of_year -= offset
      else
        year -= 1
        week_of_year = @@weeks_per_year + week_of_year - offset
      end

      key = "%d%03d" % [year, week_of_year]

      date = date_from_week(key)

      date -= (date.strftime("%w").to_i - 1).days

      day_from = date.strftime("%d").to_i
      month_from = date.strftime("%b")
      year_from = date.strftime("%y")

      date += 6.days

      day_to = date.strftime("%d").to_i
      month_to = date.strftime("%b")
      year_to = date.strftime("%y")

      if year_from != year_to
        label = "#{day_from} #{month_from} #{year_from} - #{day_to} #{month_to} #{year_to}"
      elsif month_from != month_to
        label = "#{day_from} #{month_from} - #{day_to} #{month_to} #{year_from}"
      else
        label = "#{day_from} - #{day_to} #{month_from} #{year_from}"
      end

      [key, label]
    end

    def self.subtract_day(current, offset)
      year = current[0..3].to_i
      day_of_year = current[4..6].to_i

      year -= offset/@@days_per_year
      offset %= @@days_per_year

      if day_of_year > offset
        day_of_year -= offset
      else
        year -= 1
        day_of_year = @@days_per_year + day_of_year - offset
      end

      key = "%d%03d" % [year, day_of_year]

      [key, date_from_day(key).strftime("%d %b %y")]
    end

  end
end
