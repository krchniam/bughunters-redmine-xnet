require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/charts_controller_test'
require 'charts_ratio_controller'

# Re-raise errors caught by the controller.
class ChartsRatioController; def rescue_action(e) raise e end; end

class ChartsRatioControllerTest < ChartsControllerTest

  def setup
    @controller = ChartsRatioController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    User.current = nil
  end

  def test_grouping_by_users
    Setting.default_language = 'en'

    body = get_data :project_id => 15041

    assert_equal 3, body['elements'][0]['values'].size

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 36.1 : 36.0

    assert_equal 'charts_jsmith', body['elements'][0]['values'][1]["label"]
    assert_in_delta 14, body['elements'][0]['values'][1]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => 'charts_jsmith', :hours => 14.2, :percent => 39, :total_hours => tmp)}",
      body['elements'][0]['values'][1]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_equal 'charts_dlopper', body['elements'][0]['values'][2]["label"]
    assert_in_delta 17, body['elements'][0]['values'][2]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => 'charts_dlopper', :hours => 16.8, :percent => 47, :total_hours => tmp)}",
      body['elements'][0]['values'][2]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    body = get_data :project_id => 15041, :include_subprojects => 1

    assert_equal 'charts_jsmith', body['elements'][0]['values'][1]["label"]
    assert_in_delta 14, body['elements'][0]['values'][1]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => 'charts_jsmith', :hours => 14.2, :percent => 33, :total_hours => 43.4)}",
      body['elements'][0]['values'][1]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_equal 'charts_dlopper', body['elements'][0]['values'][2]["label"]
    assert_in_delta 24, body['elements'][0]['values'][2]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => 'charts_dlopper', :hours => 24.1, :percent => 56, :total_hours => 43.4)}",
      body['elements'][0]['values'][2]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
  end

  def test_grouping_by_activities
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :grouping => 'activities'

    assert_equal 2, body['elements'][0]['values'].size

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 36.1 : 36.0

    assert_equal 'Design', body['elements'][0]['values'][1]["label"]
    assert_in_delta 26, body['elements'][0]['values'][1]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => 'Design', :hours => 25.9, :percent => 72, :total_hours => tmp)}",
      body['elements'][0]['values'][1]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_equal 'Development', body['elements'][0]['values'][0]["label"]
    assert_in_delta 10, body['elements'][0]['values'][0]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => 'Development', :hours => 10.2, :percent => 28, :total_hours => tmp)}",
      body['elements'][0]['values'][0]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
  end

  def test_grouping_by_priorities
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :grouping => 'priorities'

    assert_equal 3, body['elements'][0]['values'].size

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 36.1 : 36.0

    assert_equal 'High', body['elements'][0]['values'][1]["label"]
    assert_in_delta 13, body['elements'][0]['values'][1]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => 'High', :hours => 13.2, :percent => 36, :total_hours => tmp)}",
      body['elements'][0]['values'][1]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_equal 'Normal', body['elements'][0]['values'][2]["label"]
    assert_in_delta 18, body['elements'][0]['values'][2]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => 'Normal', :hours => 17.8, :percent => 49, :total_hours => tmp)}",
      body['elements'][0]['values'][2]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
  end

  def test_grouping_by_trackers
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :grouping => 'trackers'

    assert_equal 3, body['elements'][0]['values'].size

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 36.1 : 36.0
    tmp2 = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 14.5 : 14.4

    assert_equal 'Bug', body['elements'][0]['values'][1]["label"]
    assert_in_delta 14, body['elements'][0]['values'][1]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => 'Bug', :hours => tmp2, :percent => 40, :total_hours => tmp)}",
      body['elements'][0]['values'][1]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_equal 'Feature', body['elements'][0]['values'][2]["label"]
    assert_in_delta 17, body['elements'][0]['values'][2]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => 'Feature', :hours => 16.5, :percent => 46, :total_hours => tmp)}",
      body['elements'][0]['values'][2]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
  end

  def test_grouping_by_issues
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :grouping => 'issues'

    assert_equal 5, body['elements'][0]['values'].size

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 36.1 : 36.0
    tmp2 = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 5.6 : 5.5

    assert_equal '#15041 Issue1', body['elements'][0]['values'][1]["label"]
    assert_in_delta 6, body['elements'][0]['values'][1]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => '#15041 Issue1', :hours => tmp2, :percent => 15, :total_hours => tmp)}",
      body['elements'][0]['values'][1]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_equal '#15043 Issue3', body['elements'][0]['values'][2]["label"]
    assert_in_delta 8, body['elements'][0]['values'][2]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => '#15043 Issue3', :hours => 7.6, :percent => 21, :total_hours => tmp)}",
      body['elements'][0]['values'][2]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    tmp3 = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 3 : 4
    tmp4 = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 4 : 3

    assert_equal '#15044 Issue4', body['elements'][0]['values'][tmp3]["label"]
    assert_in_delta 9, body['elements'][0]['values'][tmp3]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => '#15044 Issue4', :hours => 8.9, :percent => 25, :total_hours => tmp)}",
      body['elements'][0]['values'][tmp3]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_equal '#15045 Issue5', body['elements'][0]['values'][tmp4]["label"]
    assert_in_delta 9, body['elements'][0]['values'][tmp4]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => '#15045 Issue5', :hours => 8.9, :percent => 25, :total_hours => tmp)}",
      body['elements'][0]['values'][tmp4]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
  end

  def test_grouping_by_versions
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :grouping => 'versions', :include_subprojects => 1

    assert_equal 3, body['elements'][0]['values'].size

    assert_equal '1.0', body['elements'][0]['values'][1]["label"]
    assert_in_delta 14, body['elements'][0]['values'][1]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => '1.0', :hours => 14.5, :percent => 33, :total_hours => 43.4)}",
      body['elements'][0]['values'][1]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_equal '2.0', body['elements'][0]['values'][2]["label"]
    assert_in_delta 17, body['elements'][0]['values'][2]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => '2.0', :hours => 16.5, :percent => 38, :total_hours => 43.4)}",
      body['elements'][0]['values'][2]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_equal l(:charts_ratio_others), body['elements'][0]['values'][0]["label"]
    assert_in_delta 12, body['elements'][0]['values'][0]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => l(:charts_ratio_others), :hours => 12.4, :percent => 29, :total_hours => 43.4)}",
      body['elements'][0]['values'][0]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
  end

  def test_grouping_by_categories
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :grouping => 'categories', :include_subprojects => 1

    assert_equal 4, body['elements'][0]['values'].size

    tmp1 = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 14.5 : 14.4
    tmp2 = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 43.3 : 43.4

    assert_equal 'Category1', body['elements'][0]['values'][2]["label"]
    assert_in_delta 14, body['elements'][0]['values'][2]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => 'Category1', :hours => tmp1, :percent => 33, :total_hours => tmp2)}",
      body['elements'][0]['values'][2]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_equal 'Category2', body['elements'][0]['values'][3]["label"]
    assert_in_delta 17, body['elements'][0]['values'][3]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => 'Category2', :hours => 16.5, :percent => 38, :total_hours => tmp2)}",
      body['elements'][0]['values'][3]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_equal 'Category3', body['elements'][0]['values'][1]["label"]
    assert_in_delta 7, body['elements'][0]['values'][1]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => 'Category3', :hours => 7.3, :percent => 17, :total_hours => tmp2)}",
      body['elements'][0]['values'][1]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
  end

  def test_users_condition
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :grouping => 'users', "conditions_time_entries.user_id".to_sym => 15042

    assert_equal 1, body['elements'][0]['values'].size
    assert_equal 'charts_jsmith', body['elements'][0]['values'][0]["label"]
    assert_in_delta 14, body['elements'][0]['values'][0]["value"], 1
  end

  def test_issues_condition
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :grouping => 'issues', "conditions_time_entries.issue_id".to_sym => 15041

    assert_equal 1, body['elements'][0]['values'].size
    assert_equal '#15041 Issue1', body['elements'][0]['values'][0]["label"]
    assert_in_delta 6, body['elements'][0]['values'][0]["value"], 1
  end

  def test_activities_condition
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :grouping => 'activities', "conditions_time_entries.activity_id" => 15045

    assert_equal 1, body['elements'][0]['values'].size
    assert_equal 'Design', body['elements'][0]['values'][0]["label"]
    assert_in_delta 26, body['elements'][0]['values'][0]["value"], 1
  end

  def test_priorities_condition
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :grouping => 'priorities', "conditions_issues.priority_id".to_sym => 15043

    assert_equal 1, body['elements'][0]['values'].size
    assert_equal 'Normal', body['elements'][0]['values'][0]["label"]
    assert_in_delta 17.8, body['elements'][0]['values'][0]["value"], 1
  end

  def test_trackers_condition
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :grouping => 'trackers', "conditions_issues.tracker_id".to_sym => 15041

    assert_equal 1, body['elements'][0]['values'].size
    assert_equal 'Bug', body['elements'][0]['values'][0]["label"]
    assert_in_delta 14, body['elements'][0]['values'][0]["value"], 1
  end

  def test_versions_condition
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :grouping => 'versions', "conditions_issues.fixed_version_id".to_sym => 15041, :include_subprojects => 1

    assert_equal 1, body['elements'][0]['values'].size
    assert_equal '1.0', body['elements'][0]['values'][0]["label"]
    assert_in_delta 14.5, body['elements'][0]['values'][0]["value"], 1
  end

  def test_categories_condition
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :grouping => 'categories', "conditions_issues.category_id".to_sym => 15041, :include_subprojects => 1

    assert_equal 1, body['elements'][0]['values'].size
    assert_equal 'Category1', body['elements'][0]['values'][0]["label"]
    assert_in_delta 14.45, body['elements'][0]['values'][0]["value"], 1
  end

  def test_all_conditions
    Setting.default_language = 'en'

    get_data :project_id => 15041, "conditions_issues.category_id".to_sym => 15043, "conditions_issues.tracker_id".to_sym => 15043, "conditions_issues.fixed_version_id".to_sym => 15043, "conditions_issues.fixed_version_id".to_sym => 15041, "conditions_time_entries.user_id".to_sym => 15043, "conditions_time_entries.issue_id".to_sym => 15043, "conditions_time_entries.activity_id".to_sym => 15043
  end

  def test_empty
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, "conditions_issues.category_id".to_sym => 15043, "conditions_issues.fixed_version_id".to_sym => 15041

    assert_equal 1, body['elements'][0]['values'].size
    assert_equal l(:charts_ratio_none), body['elements'][0]['values'][0]["label"]
    assert_in_delta 1, body['elements'][0]['values'][0]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => l(:charts_ratio_none), :hours => 0, :percent => 0, :total_hours => 0)}",
      body['elements'][0]['values'][0]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
  end

end
