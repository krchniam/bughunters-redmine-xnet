class ChartsTimelineController < ChartsController

  unloadable
  
  protected

  def get_data(conditions, grouping , range, pagination)
    prepare_ranged = RedmineCharts::RangeUtils.prepare_range(range, "time_entries.spent_on")

    conditions["time_entries.spent_on"] = (prepare_ranged[:date_from])...(prepare_ranged[:date_to])

    group = []
    group << prepare_ranged[:sql]
    group << "time_entries.user_id" if grouping == :users
    group << "time_entries.issue_id" if grouping == :issues
    group << "time_entries.project_id" if grouping == :projects
    group << "time_entries.activity_id" if grouping == :activities
    group << "issues.category_id" if grouping == :categories
    group << "issues.priority_id" if grouping == :priorities
    group << "issues.tracker_id" if grouping == :trackers
    group << "issues.fixed_version_id" if grouping == :versions
    group = group.join(", ")

    select = []
    select << "#{prepare_ranged[:sql]} as value_x"
    select << "count(1) as count_y"
    select << "sum(time_entries.hours) as value_y"
    select << "coalesce(time_entries.user_id, 0) as group_id" if grouping == :users
    select << "coalesce(time_entries.issue_id, 0) as group_id" if grouping == :issues
    select << "coalesce(time_entries.project_id, 0) as group_id" if grouping == :projects
    select << "coalesce(time_entries.activity_id, 0) as group_id" if grouping == :activities
    select << "coalesce(issues.category_id, 0) as group_id" if grouping == :categories
    select << "coalesce(issues.priority_id, 0) as group_id" if grouping == :priorities
    select << "coalesce(issues.tracker_id, 0) as group_id" if grouping == :trackers
    select << "coalesce(issues.fixed_version_id, 0) as group_id" if grouping == :versions
    select << "-1 as group_id" if grouping.nil? or grouping == :none
    select = select.join(", ")

    joins = nil

    conditions.each do |k,v|
      joins = "left join issues on issues.id = time_entries.issue_id" if k.to_s[0,7] == 'issues.'
    end

    joins = "left join issues on issues.id = time_entries.issue_id" unless [:categories, :priorities, :trackers, :versions].index(grouping).nil?

    rows = TimeEntry.find(:all, :joins => joins, :select => select, :conditions => conditions, :order => "1", :readonly => true, :group => group)

    sets = {}
    max = 0

    if rows.size > 0
      rows.each do |row|
        group_name = RedmineCharts::GroupingUtils.to_string(row.group_id, grouping)
        index = prepare_ranged[:keys].index(row.value_x)
        if index
          sets[group_name] ||= Array.new(prepare_ranged[:steps], [0, get_hints])
          sets[group_name][index] = [row.value_y.to_f, get_hints(row, grouping)]
          max = row.value_y.to_f if max < row.value_y.to_f
        else
          raise row.value_x.to_s
        end
      end
    else
      sets[""] ||= Array.new(prepare_ranged[:steps], [0, get_hints])
    end

    sets = sets.sort.collect { |name, values| [name, values] }

    {
      :labels => prepare_ranged[:labels],
      :count => prepare_ranged[:steps],
      :max => max > 1 ? max : 1,
      :sets => sets
    }
  end

  def get_hints(record = nil, grouping = nil)
    unless record.nil?
      l(:charts_timeline_hint, { :hours => RedmineCharts::Utils.round(record.value_y), :entries => record.count_y.to_i })
    else
      l(:charts_timeline_hint_empty)
    end
  end

  def get_title
    l(:charts_link_timeline)
  end
  
  def get_help
    l(:charts_timeline_help)
  end
  
  def get_type
    :line
  end
  
  def get_x_legend
    l(:charts_timeline_x)
  end
  
  def get_y_legend
    l(:charts_timeline_y)
  end
  
  def show_x_axis
    true
  end
  
  def show_y_axis
    true
  end
  
  def show_date_condition
    true
  end
  
  def get_grouping_options
    [ :none, RedmineCharts::GroupingUtils.default_types ].flatten
  end
  
end
