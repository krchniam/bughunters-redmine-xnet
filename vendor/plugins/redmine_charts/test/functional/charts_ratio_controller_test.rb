require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/charts_controller_test'
require 'charts_ratio_controller'

class ChartsRatioControllerTest < ChartsControllerTest

  def setup
    @controller = ChartsRatioController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    User.current = nil
  end

  def test_grouping_by_users
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :project_ids => [15041]

    assert_equal 3, body['elements'][0]['values'].size

    assert_equal 'John Smith', body['elements'][0]['values'][0]["label"]
    assert_in_delta 16.8, body['elements'][0]['values'][0]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => 'John Smith', :hours => 16.8, :percent => 47, :total_hours => 36.1)}",
      body['elements'][0]['values'][0]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_equal 'redMine Admin', body['elements'][0]['values'][1]["label"]
    assert_in_delta 14.2, body['elements'][0]['values'][1]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => 'redMine Admin', :hours => 14.2, :percent => 39, :total_hours => 36.1)}",
      body['elements'][0]['values'][1]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_equal 'Dave Lopper', body['elements'][0]['values'][2]["label"]
    assert_in_delta 5.1, body['elements'][0]['values'][2]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => 'Dave Lopper', :hours => 5.1, :percent => 14, :total_hours => 36.1)}",
      body['elements'][0]['values'][2]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
  end

  def test_grouping_by_activities
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :project_ids => [15041], :grouping => :activity_id

    assert_equal 2, body['elements'][0]['values'].size

    assert_equal 'Design', body['elements'][0]['values'][1]["label"]
    assert_in_delta 10.2, body['elements'][0]['values'][1]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => 'Design', :hours => 10.2, :percent => 28, :total_hours => 36.1)}",
      body['elements'][0]['values'][1]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_equal 'Development', body['elements'][0]['values'][0]["label"]
    assert_in_delta 25.8, body['elements'][0]['values'][0]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => 'Development', :hours => 25.9, :percent => 72, :total_hours => 36.1)}",
      body['elements'][0]['values'][0]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
  end

  def test_grouping_by_priorities
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :project_ids => [15041], :grouping => :priority_id

    assert_equal 3, body['elements'][0]['values'].size

    assert_equal 'Low', body['elements'][0]['values'][1]["label"]
    assert_in_delta 13, body['elements'][0]['values'][1]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => 'Low', :hours => 13.2, :percent => 36, :total_hours => 36.1)}",
      body['elements'][0]['values'][1]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_equal l(:charts_ratio_others), body['elements'][0]['values'][2]["label"]
    assert_in_delta 5.1, body['elements'][0]['values'][2]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => l(:charts_ratio_others), :hours => 5.1, :percent => 14, :total_hours => 36.1)}",
      body['elements'][0]['values'][2]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
  end

  def test_grouping_by_trackers
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :project_ids => [15041], :grouping => :tracker_id

    assert_equal 3, body['elements'][0]['values'].size

    assert_equal 'Bug', body['elements'][0]['values'][1]["label"]
    assert_in_delta 14, body['elements'][0]['values'][1]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => 'Bug', :hours => 14.5, :percent => 40, :total_hours => 36.1)}",
      body['elements'][0]['values'][1]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_equal l(:charts_ratio_others), body['elements'][0]['values'][2]["label"]
    assert_in_delta 5.1, body['elements'][0]['values'][2]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => l(:charts_ratio_others), :hours => 5.1, :percent => 14, :total_hours => 36.1)}",
      body['elements'][0]['values'][2]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
  end

  def test_grouping_by_issues
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :project_ids => [15041], :grouping => :issue_id

    assert_equal 5, body['elements'][0]['values'].size

    assert_equal '#15045 Issue5', body['elements'][0]['values'][1]["label"]
    assert_in_delta 8.9, body['elements'][0]['values'][1]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => '#15045 Issue5', :hours => 8.9, :percent => 25, :total_hours => 36.1)}",
      body['elements'][0]['values'][1]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_equal '#15044 Issue4', body['elements'][0]['values'][0]["label"]
    assert_in_delta 8.9, body['elements'][0]['values'][0]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => '#15044 Issue4', :hours => 8.9, :percent => 25, :total_hours => 36.1)}",
      body['elements'][0]['values'][0]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 7.6 : 7.7

    assert_equal '#15043 Issue3', body['elements'][0]['values'][2]["label"]
    assert_in_delta 7.6, body['elements'][0]['values'][2]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => '#15043 Issue3', :hours => tmp, :percent => 21, :total_hours => 36.1)}",
      body['elements'][0]['values'][2]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_equal '#15041 Issue1', body['elements'][0]['values'][3]["label"]
    assert_in_delta 5.5, body['elements'][0]['values'][3]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => '#15041 Issue1', :hours => 5.6, :percent => 15, :total_hours => 36.1)}",
      body['elements'][0]['values'][3]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_equal l(:charts_ratio_others), body['elements'][0]['values'][4]["label"]
    assert_in_delta 5.1, body['elements'][0]['values'][4]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => l(:charts_ratio_others), :hours => 5.1, :percent => 14, :total_hours => 36.1)}",
      body['elements'][0]['values'][4]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
  end

  def test_grouping_by_versions
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :project_ids => [15041], :grouping => :fixed_version_id

    assert_equal 3, body['elements'][0]['values'].size

    assert_equal '1.0', body['elements'][0]['values'][1]["label"]
    assert_in_delta 14.5, body['elements'][0]['values'][1]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => '1.0', :hours => 14.5, :percent => 40, :total_hours => 36.1)}",
      body['elements'][0]['values'][1]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_equal l(:charts_ratio_others), body['elements'][0]['values'][2]["label"]
    assert_in_delta 5.1, body['elements'][0]['values'][2]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => l(:charts_ratio_others), :hours => 5.1, :percent => 14, :total_hours => 36.1)}",
      body['elements'][0]['values'][2]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_equal '2.0', body['elements'][0]['values'][0]["label"]
    assert_in_delta 16.5, body['elements'][0]['values'][0]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => '2.0', :hours => 16.5, :percent => 46, :total_hours => 36.1)}",
      body['elements'][0]['values'][0]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
  end

  def test_grouping_by_categories
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :project_ids => [15041], :grouping => :category_id

    assert_equal 3, body['elements'][0]['values'].size

    assert_equal 'Category2', body['elements'][0]['values'][0]["label"]
    assert_in_delta 25.4, body['elements'][0]['values'][0]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => 'Category2', :hours => 25.4, :percent => 70, :total_hours => 36.1)}",
      body['elements'][0]['values'][0]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_equal 'Category1', body['elements'][0]['values'][1]["label"]
    assert_in_delta 5.55, body['elements'][0]['values'][1]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => 'Category1', :hours => 5.6, :percent => 15, :total_hours => 36.1)}",
      body['elements'][0]['values'][1]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_equal l(:charts_ratio_others), body['elements'][0]['values'][2]["label"]
    assert_in_delta 5.1, body['elements'][0]['values'][2]["value"], 1
    assert_equal "#{l(:charts_ratio_hint, :label => l(:charts_ratio_others), :hours => 5.1, :percent => 14, :total_hours => 36.1)}",
      body['elements'][0]['values'][2]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")   
  end

  def test_users_condition
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :project_ids => [15041], :grouping => :user_id, :user_ids => 1

    assert_equal 1, body['elements'][0]['values'].size
    assert_equal 'redMine Admin', body['elements'][0]['values'][0]["label"]
    assert_in_delta 14, body['elements'][0]['values'][0]["value"], 1
  end

  def test_issues_condition
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :project_ids => [15041], :grouping => 'issue_id', :issue_ids => 15041

    assert_equal 1, body['elements'][0]['values'].size
    assert_equal '#15041 Issue1', body['elements'][0]['values'][0]["label"]
    assert_in_delta 6, body['elements'][0]['values'][0]["value"], 1
  end

  def test_activities_condition
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :project_ids => [15041], :grouping => 'activity_id', :activity_ids => 10

    assert_equal 1, body['elements'][0]['values'].size
    assert_equal 'Development', body['elements'][0]['values'][0]["label"]
    assert_in_delta 26, body['elements'][0]['values'][0]["value"], 1
  end

  def test_priorities_condition
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :project_ids => [15041], :grouping => :priority_id, :priority_ids => 5

    assert_equal 1, body['elements'][0]['values'].size
    assert_equal 'Normal', body['elements'][0]['values'][0]["label"]
    assert_in_delta 17.8, body['elements'][0]['values'][0]["value"], 1
  end

  def test_trackers_condition
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :project_ids => [15041], :grouping => :tracker_id, :tracker_ids => 1

    assert_equal 1, body['elements'][0]['values'].size
    assert_equal 'Bug', body['elements'][0]['values'][0]["label"]
    assert_in_delta 14, body['elements'][0]['values'][0]["value"], 1
  end

  def test_versions_condition
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :project_ids => [15041], :grouping => :fixed_version_id, :fixed_version_ids => 15041

    assert_equal 1, body['elements'][0]['values'].size
    assert_equal '1.0', body['elements'][0]['values'][0]["label"]
    assert_in_delta 14.5, body['elements'][0]['values'][0]["value"], 1
  end

  def test_categories_condition
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :project_ids => [15041], :grouping => :category_id, :category_ids => 15041

    assert_equal 1, body['elements'][0]['values'].size
    assert_equal 'Category1', body['elements'][0]['values'][0]["label"]
    assert_in_delta 5.55, body['elements'][0]['values'][0]["value"], 1
  end

  def test_authors_condition
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :project_ids => [15041], :grouping => :author_id, :author_ids => 2

    assert_equal 1, body['elements'][0]['values'].size
    assert_equal 'John Smith', body['elements'][0]['values'][0]["label"]
    assert_in_delta 8.9, body['elements'][0]['values'][0]["value"], 1
  end

  def test_statuses_condition
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :project_ids => [15041], :grouping => :status_id, :status_ids => 1

    assert_equal 1, body['elements'][0]['values'].size
    assert_equal 'New', body['elements'][0]['values'][0]["label"]
    assert_in_delta 8.9, body['elements'][0]['values'][0]["value"], 1
  end

  def test_all_conditions
    Setting.default_language = 'en'

    get_data :project_id => 15041, :project_ids => [15041], :author_ids => 2, :status_ids => 1, :category_ids => 15043, :tracker_ids => 15043, :fixed_version_ids => 15043, :priority_ids => 15041, :user_ids => 15043, :issue_ids => 15043, :activity_ids => 15043
  end

  def test_empty
    Setting.default_language = 'en'

    body = get_data:project_id => 15041, :project_ids => [15041], :category_ids => 15043, :fixed_version_ids => 15041

    assert_nil body
  end

  def test_sub_tasks
    if RedmineCharts.has_sub_issues_functionality_active
      Setting.default_language = 'en'

      body = get_data :project_id => 15044, :project_ids => [15044]

      assert_equal 1, body['elements'][0]['values'].size

      assert_equal 'John Smith', body['elements'][0]['values'][0]["label"]
      assert_in_delta 13.2, body['elements'][0]['values'][0]["value"], 1
      assert_equal "#{l(:charts_ratio_hint, :label => 'John Smith', :hours => 13.2, :percent => 100, :total_hours => 13.2)}",
        body['elements'][0]['values'][0]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    end
  end

end
