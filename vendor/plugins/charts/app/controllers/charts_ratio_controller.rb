class ChartsRatioController < ChartsController

  unloadable
  
  protected

  def get_data(conditions, grouping, range, pagination)
    grouping ||= :users
    
    group = case grouping
    when :users then "user_id"
    when :issues then "issue_id"
    when :activities then "activity_id"
    when :categories then "issues.category_id"
    when :priorities then "issues.priority_id"
    when :trackers then "issues.tracker_id"
    when :versions then "issues.fixed_version_id"
    end

    joins = nil

    conditions_new = {}

    conditions.each do |k,v|
      if k == :project_id
        conditions_new["time_entries.project_id".to_sym] = v
      else
        conditions_new[k] = v
      end
    end

    conditions = conditions_new

    conditions.each do |k,v|
      joins = "left join issues on issues.id = issue_id" if k.to_s[0,7] == 'issues.'
    end

    joins = "left join issues on issues.id = issue_id" if group[0,7] == 'issues.'

    select = []
    select << "sum(hours) as value_y"
    select << "#{group} as group_id"
    select = select.join(", ")

    rows = TimeEntry.find(:all, :joins => joins, :select => select, :conditions => conditions, :readonly => true, :group => group, :order => "1 asc, 2 asc")

    bigger_rows = []
    total_hours = 0
    other_value = 0
    other_no = 0

    rows.each do |row|
      total_hours += row.value_y.to_f
    end

    rows.each do |row|
      if row.group_id == 0 or ((other_value + row.value_y.to_f)/total_hours) < 0.05
        other_value += row.value_y.to_f
        other_no += 1
      else
        bigger_rows << row
      end
    end

    if other_no > 1
      rows = bigger_rows
      other_row = Struct.new(:value_x, :value_y, :group_id).new
      other_row.value_y = other_value
      other_row.group_id = 0
      rows << other_row
    end

    labels = []
    set = []

    if rows.empty?
      labels << l(:charts_ratio_label, { :label => l(:charts_ratio_none) })
      set << [1, l(:charts_ratio_hint, { :label => l(:charts_ratio_none), :hours => 0, :percent => 0, :total_hours => 0 })]
    else
      rows.each do |row|
        labels << l(:charts_ratio_label, { :label => RedmineCharts::GroupingUtils.to_string(row.group_id, grouping, l(:charts_ratio_others)) })
        hint = l(:charts_ratio_hint, { :label => RedmineCharts::GroupingUtils.to_string(row.group_id, grouping, l(:charts_ratio_others)), :hours => RedmineCharts::Utils.round(row.value_y), :percent => get_percent(row.value_y, total_hours), :total_hours => RedmineCharts::Utils.round(total_hours) })
        set << [RedmineCharts::Utils.round(row.value_y), hint]
      end
    end

    {
      :labels => labels,
      :count => rows.size,
      :max => 0,
      :sets => {"" => set}
    }
  end

  def get_title
    l(:charts_link_ratio)
  end
  
  def get_help
    l(:charts_ratio_help)
  end
  
  def get_type
    :pie
  end

  private

  def get_percent(value, total)
    if total > 0      
      (value.to_f/total*100).round
    else
      0
    end
  end
  
end
