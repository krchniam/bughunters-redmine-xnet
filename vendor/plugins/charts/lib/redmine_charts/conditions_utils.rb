module RedmineCharts
  module ConditionsUtils

    if defined?(Redmine::I18n)
      include Redmine::I18n
    else
      extend ChartsI18nPatch
    end
    
    @@default_types = [ "time_entries.user_id".to_sym, "time_entries.issue_id".to_sym, "time_entries.activity_id".to_sym, "issues.category_id".to_sym, "issues.fixed_version_id".to_sym, "issues.tracker_id".to_sym, "issues.priority_id".to_sym ]

    def self.default_types
      @@default_types
    end

    def self.from_params(params, options)
      conditions = {:project_id => project_and_its_children_ids(params[:project_id], params[:include_subprojects])}
      options.each do |k|
        t = params["conditions_#{k.to_s}".to_sym].blank? ? nil : Integer(params["conditions_#{k.to_s}".to_sym])
        conditions[k] = t if t and t > 0
      end   
      conditions
    end

    def self.to_options(options, project_id)
      options.collect do |i|
        case i
        when "time_entries.user_id".to_sym then
          users = {}          
          project_and_its_children_ids(project_id).each do |pid|
            Project.find(pid).members.each do |m|
              users[m.user.name] = m.user.id
            end
          end
          
          ["time_entries.user_id".to_sym, users.to_a.unshift([l(:charts_condition_all), 0])]
        when "time_entries.issue_id".to_sym then ["time_entries.issue_id".to_sym, nil]
        when "time_entries.activity_id".to_sym then ["time_entries.activity_id".to_sym, Enumeration.find_all_by_opt("ACTI").collect { |a| [a.name, a.id] }.unshift([l(:charts_condition_all), 0])]
        when "issues.category_id".to_sym then ["issues.category_id".to_sym, IssueCategory.find_all_by_project_id(project_and_its_children_ids(project_id)).collect { |c| [c.name, c.id] }.unshift([l(:charts_condition_all), 0])]
        when "issues.fixed_version_id".to_sym then ["issues.fixed_version_id".to_sym, Version.find_all_by_project_id(project_and_its_children_ids(project_id)).collect { |c| [c.name, c.id] }.unshift([l(:charts_condition_all), 0])]
        when "issues.tracker_id".to_sym then ["issues.tracker_id".to_sym, Tracker.all.collect { |c| [c.name, c.id] }.unshift([l(:charts_condition_all), 0])]
        when "issues.priority_id".to_sym then ["issues.priority_id".to_sym, Enumeration.find_all_by_opt("IPRI").collect { |a| [a.name, a.id] }.unshift([l(:charts_condition_all), 0])]
        end
      end
    end
    
    private 
    
    def self.project_and_its_children_ids(project_id, include_subprojects = true)       
      project = Project.find(project_id)
      if include_subprojects
        [project.id, project_children_ids(project)].flatten
      else
        [project.id]
      end
    end
    
    def self.project_children_ids(project)
      project.children.collect { |child| [child.id, project_children_ids(child)] }
    end

  end
end
