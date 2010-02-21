module RedmineCharts
  module GroupingUtils

    if defined?(Redmine::I18n)
      include Redmine::I18n
    else
      extend ChartsI18nPatch
    end

    @@types = [ :users, :issues, :activities, :categories, :trackers, :versions, :priorities ]

    def self.default_types
      @@types
    end

    def self.from_params(params)
      if params[:grouping].blank? or not default_types.include?(params[:grouping].to_sym)
        nil
      else
         params[:grouping].to_sym
      end
    end
    
    def self.to_options(options)
      options.collect { |i| [l("charts_group_by_#{i}".to_sym), i]  }
    end

    def self.to_string(id, grouping, default = nil)
      if grouping.nil? or grouping == :none
        l(:charts_group_all)
      elsif grouping == :categories and category = IssueCategory.find_by_id(id.to_i)
        category.name
      elsif grouping == :users and user = User.find_by_id(id.to_i)
        user.login
      elsif grouping == :issues and issue = Issue.find_by_id(id.to_i)
        subject = issue.subject
        if subject.length > 24
          subject = "#{subject[0, 20].strip} ..."
        end
        "##{issue.id} #{subject}"
      elsif grouping == :activities and activity = Enumeration.find_by_id(id.to_i)
        activity.name
      elsif grouping == :priorities and priority = Enumeration.find_by_id(id.to_i)
        priority.name
      elsif grouping == :trackers and tracker = Tracker.find_by_id(id.to_i)
        tracker.name
      elsif grouping == :versions and version = Version.find_by_id(id.to_i)
        version.name
      elsif default
        default
      else
        l(:charts_group_none)
      end
    end

  end
end
