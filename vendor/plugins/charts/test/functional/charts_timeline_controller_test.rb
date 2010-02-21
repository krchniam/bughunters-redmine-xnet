require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/charts_controller_test'
require 'charts_timeline_controller'

# Re-raise errors caught by the controller.
class ChartsTimelineController; def rescue_action(e) raise e end; end

class ChartsTimelineControllerTest < ChartsControllerTest

  def setup
    @controller = ChartsTimelineController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    User.current = nil
  end

  def test_range
    Setting.default_language = 'en'

    body = get_data :project_id => 15041

    assert_equal 0, body['x_axis']['min']
    assert_equal 1, body['x_axis']['steps']
    assert_equal 10, body['x_axis']['max']
    assert_equal 10, body['x_axis']['labels']['labels'].size
    assert_equal 10, body['elements'][0]['values'].size

    date = Time.now - Time.now.strftime('%w').to_i.days

    assert_equal get_week_labels(date - 9.weeks), body['x_axis']['labels']['labels'][0]
    assert_equal "", body['x_axis']['labels']['labels'][1]
    assert_equal get_week_labels(date - 7.weeks), body['x_axis']['labels']['labels'][2]
    assert_equal "", body['x_axis']['labels']['labels'][3]
    assert_equal get_week_labels(date - 5.weeks), body['x_axis']['labels']['labels'][4]
    assert_equal "", body['x_axis']['labels']['labels'][5]
    assert_equal get_week_labels(date - 3.weeks), body['x_axis']['labels']['labels'][6]
    assert_equal "", body['x_axis']['labels']['labels'][7]
    assert_equal get_week_labels(date - 1.week), body['x_axis']['labels']['labels'][8]
    assert_equal "", body['x_axis']['labels']['labels'][9]

    body = get_data :project_id => 15041, :range_offset => 2

    assert_equal 10, body['x_axis']['labels']['labels'].size
    assert_equal 10, body['elements'][0]['values'].size

    date = Time.now - Time.now.strftime('%w').to_i.days - 10.weeks

    assert_equal get_week_labels(date - 9.weeks), body['x_axis']['labels']['labels'][0]
    assert_equal "", body['x_axis']['labels']['labels'][1]
    assert_equal get_week_labels(date - 7.weeks), body['x_axis']['labels']['labels'][2]
    assert_equal "", body['x_axis']['labels']['labels'][3]
    assert_equal get_week_labels(date - 5.weeks), body['x_axis']['labels']['labels'][4]
    assert_equal "", body['x_axis']['labels']['labels'][5]
    assert_equal get_week_labels(date - 3.weeks), body['x_axis']['labels']['labels'][6]
    assert_equal "", body['x_axis']['labels']['labels'][7]
    assert_equal get_week_labels(date - 1.week), body['x_axis']['labels']['labels'][8]
    assert_equal "", body['x_axis']['labels']['labels'][9]

    body = get_data :project_id => 15041, :range_offset => 2, :range_steps => 20

    assert_equal 20, body['x_axis']['labels']['labels'].size
    assert_equal 20, body['elements'][0]['values'].size

    date = Time.now - Time.now.strftime('%w').to_i.days - 20.weeks

    assert_equal get_week_labels(date - 19.weeks), body['x_axis']['labels']['labels'][0]
    assert_equal "", body['x_axis']['labels']['labels'][1]
    assert_equal "", body['x_axis']['labels']['labels'][2]
    assert_equal "", body['x_axis']['labels']['labels'][3]
    assert_equal get_week_labels(date - 15.weeks), body['x_axis']['labels']['labels'][4]
    assert_equal "", body['x_axis']['labels']['labels'][5]
    assert_equal "", body['x_axis']['labels']['labels'][6]
    assert_equal "", body['x_axis']['labels']['labels'][7]
    assert_equal get_week_labels(date - 11.weeks), body['x_axis']['labels']['labels'][8]
    assert_equal "", body['x_axis']['labels']['labels'][9]
    assert_equal "", body['x_axis']['labels']['labels'][10]
    assert_equal "", body['x_axis']['labels']['labels'][11]
    assert_equal get_week_labels(date - 7.weeks), body['x_axis']['labels']['labels'][12]
    assert_equal "", body['x_axis']['labels']['labels'][13]
    assert_equal "", body['x_axis']['labels']['labels'][14]
    assert_equal "", body['x_axis']['labels']['labels'][15]
    assert_equal get_week_labels(date - 3.weeks), body['x_axis']['labels']['labels'][16]
    assert_equal "", body['x_axis']['labels']['labels'][17]
    assert_equal "", body['x_axis']['labels']['labels'][18]
    assert_equal "", body['x_axis']['labels']['labels'][19]

    body = get_data :project_id => 15041, :range_in => 'months'

    assert_equal 10, body['x_axis']['labels']['labels'].size
    assert_equal 10, body['elements'][0]['values'].size

    assert_equal get_month_labels(Time.now - 9.months), body['x_axis']['labels']['labels'][0]
    assert_equal "", body['x_axis']['labels']['labels'][1]
    assert_equal get_month_labels(Time.now - 7.months), body['x_axis']['labels']['labels'][2]
    assert_equal "", body['x_axis']['labels']['labels'][3]
    assert_equal get_month_labels(Time.now - 5.months), body['x_axis']['labels']['labels'][4]
    assert_equal "", body['x_axis']['labels']['labels'][5]
    assert_equal get_month_labels(Time.now - 3.months), body['x_axis']['labels']['labels'][6]
    assert_equal "", body['x_axis']['labels']['labels'][7]
    assert_equal get_month_labels(Time.now - 1.months), body['x_axis']['labels']['labels'][8]
    assert_equal "", body['x_axis']['labels']['labels'][9]

    body = get_data :project_id => 15041, :range_in => 'days'

    assert_equal 10, body['x_axis']['labels']['labels'].size
    assert_equal 10, body['elements'][0]['values'].size

    assert_equal get_day_labels(Time.now - 9.days), body['x_axis']['labels']['labels'][0]
    assert_equal "", body['x_axis']['labels']['labels'][1]
    assert_equal get_day_labels(Time.now - 7.days), body['x_axis']['labels']['labels'][2]
    assert_equal "", body['x_axis']['labels']['labels'][3]
    assert_equal get_day_labels(Time.now - 5.days), body['x_axis']['labels']['labels'][4]
    assert_equal "", body['x_axis']['labels']['labels'][5]
    assert_equal get_day_labels(Time.now - 3.days), body['x_axis']['labels']['labels'][6]
    assert_equal "", body['x_axis']['labels']['labels'][7]
    assert_equal get_day_labels(Time.now - 1.day), body['x_axis']['labels']['labels'][8]
    assert_equal "", body['x_axis']['labels']['labels'][9]
  end

  def test_without_grouping
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :range_in => 'days'

    assert_equal 1, body['elements'].size
    assert_in_delta 7.6 * 1.2, body['y_axis']['max'], 1
    assert_equal l(:charts_timeline_y), body['y_legend']['text']

    assert_equal 10, body['elements'][0]['values'].size
    assert_equal l(:charts_group_all), body['elements'][0]['text']

    assert_in_delta 0, body['elements'][0]['values'][0]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 9.days), body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 7.6, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(7.6, 2, Time.now - 8.days), body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][2]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 7.days), body['elements'][0]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 2.3, body['elements'][0]['values'][3]['value'], 0.1
    assert_equal get_label(2.3, 1, Time.now - 6.days), body['elements'][0]['values'][3]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 6.6, body['elements'][0]['values'][4]['value'], 0.1
    assert_equal get_label(6.6, 2, Time.now - 5.days), body['elements'][0]['values'][4]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][5]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 4.days), body['elements'][0]['values'][5]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][6]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 3.days), body['elements'][0]['values'][6]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 6.6, body['elements'][0]['values'][7]['value'], 0.1
    assert_equal get_label(6.6, 2, Time.now - 2.days), body['elements'][0]['values'][7]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 7.4, body['elements'][0]['values'][8]['value'], 0.1
    assert_equal get_label(7.4, 2, Time.now - 1.days), body['elements'][0]['values'][8]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][9]['value'], 0.1
    assert_equal get_label(0, 0, Time.now), body['elements'][0]['values'][9]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    body = get_data :project_id => 15041, :range_in => 'days', :include_subprojects => 1

    assert_in_delta 0, body['elements'][0]['values'][0]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 9.days), body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 14.9, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(14.9, 3, Time.now - 8.days), body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][2]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 7.days), body['elements'][0]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 2.3, body['elements'][0]['values'][3]['value'], 0.1
    assert_equal get_label(2.3, 1, Time.now - 6.days), body['elements'][0]['values'][3]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 6.6, body['elements'][0]['values'][4]['value'], 0.1
    assert_equal get_label(6.6, 2, Time.now - 5.days), body['elements'][0]['values'][4]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][5]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 4.days), body['elements'][0]['values'][5]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][6]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 3.days), body['elements'][0]['values'][6]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 6.6, body['elements'][0]['values'][7]['value'], 0.1
    assert_equal get_label(6.6, 2, Time.now - 2.days), body['elements'][0]['values'][7]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 7.4, body['elements'][0]['values'][8]['value'], 0.1
    assert_equal get_label(7.4, 2, Time.now - 1.days), body['elements'][0]['values'][8]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][9]['value'], 0.1
    assert_equal get_label(0, 0, Time.now), body['elements'][0]['values'][9]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
  end

  def test_grouping_by_users
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :grouping => 'users', :range_in => 'days', :range_steps => 3

    assert_equal 3, body['elements'].size

    assert_equal 3, body['elements'][1]['values'].size
    assert_equal 'charts_jsmith', body['elements'][1]['text']

    assert_in_delta 3.3, body['elements'][1]['values'][0]['value'], 0.1
    assert_equal get_label(3.3, 1, Time.now - 2.days), body['elements'][1]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][1]['values'][1]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 1.days), body['elements'][1]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_equal 3, body['elements'][0]['values'].size
    assert_equal 'charts_dlopper', body['elements'][0]['text']

    assert_in_delta 3.3, body['elements'][0]['values'][0]['value'], 0.1
    assert_equal get_label(3.3, 1, Time.now - 2.days), body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 2.3, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(2.3, 1, Time.now - 1.days), body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_equal 3, body['elements'][2]['values'].size
    assert_equal 'charts_rhill', body['elements'][2]['text']

    assert_in_delta 0, body['elements'][2]['values'][0]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 2.days), body['elements'][2]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 5.1, body['elements'][2]['values'][1]['value'], 0.1
    assert_equal get_label(5.1, 1, Time.now - 1.days), body['elements'][2]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
  end

  def test_grouping_by_priorities
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :grouping => 'priorities', :range_in => 'days', :range_steps => 3

    assert_equal 2, body['elements'].size

    assert_equal 3, body['elements'][0]['values'].size
    assert_equal 'Normal', body['elements'][0]['text']

    assert_in_delta 6.6, body['elements'][0]['values'][0]['value'], 0.1
    assert_equal get_label(6.6, 2, Time.now - 2.days), body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 2.3, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(2.3, 1, Time.now - 1.days), body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_equal 3, body['elements'][1]['values'].size
    assert_equal l(:charts_group_none), body['elements'][1]['text']

    assert_in_delta 0, body['elements'][1]['values'][0]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 2.days), body['elements'][1]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 5.1, body['elements'][1]['values'][1]['value'], 0.1
    assert_equal get_label(5.1, 1, Time.now - 1.days), body['elements'][1]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
  end

  def test_grouping_by_trackers
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :grouping => 'trackers', :range_in => 'days', :range_steps => 3

    assert_equal 2, body['elements'].size

    assert_equal 3, body['elements'][0]['values'].size
    assert_equal 'Bug', body['elements'][0]['text']

    assert_in_delta 6.6, body['elements'][0]['values'][0]['value'], 0.1
    assert_equal get_label(6.6, 2, Time.now - 2.days), body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 2.3, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(2.3, 1, Time.now - 1.days), body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_equal 3, body['elements'][1]['values'].size
    assert_equal l(:charts_group_none), body['elements'][1]['text']

    assert_in_delta 0, body['elements'][1]['values'][0]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 2.days), body['elements'][1]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 5.1, body['elements'][1]['values'][1]['value'], 0.1
    assert_equal get_label(5.1, 1, Time.now - 1.days), body['elements'][1]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
  end

  def test_grouping_by_issues
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :grouping => 'issues', :range_in => 'days', :range_steps => 3

    assert_equal 2, body['elements'].size

    assert_equal 3, body['elements'][0]['values'].size
    assert_equal '#15045 Issue5', body['elements'][0]['text']

    assert_in_delta 6.6, body['elements'][0]['values'][0]['value'], 0.1
    assert_equal get_label(6.6, 2, Time.now - 2.days), body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 2.3, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(2.3, 1, Time.now - 1.days), body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_equal 3, body['elements'][1]['values'].size
    assert_equal l(:charts_group_none), body['elements'][1]['text']

    assert_in_delta 0, body['elements'][1]['values'][0]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 2.days), body['elements'][1]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 5.1, body['elements'][1]['values'][1]['value'], 0.1
    assert_equal get_label(5.1, 1, Time.now - 1.days), body['elements'][1]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
  end

  def test_grouping_by_versions
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :grouping => 'versions', :range_in => 'days', :range_steps => 3

    assert_equal 2, body['elements'].size

    assert_equal 3, body['elements'][0]['values'].size
    assert_equal '2.0', body['elements'][0]['text']

    assert_in_delta 6.6, body['elements'][0]['values'][0]['value'], 0.1
    assert_equal get_label(6.6, 2, Time.now - 2.days), body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 2.3, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(2.3, 1, Time.now - 1.days), body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_equal 3, body['elements'][1]['values'].size
    assert_equal l(:charts_group_none), body['elements'][1]['text']

    assert_in_delta 0, body['elements'][1]['values'][0]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 2.days), body['elements'][1]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 5.1, body['elements'][1]['values'][1]['value'], 0.1
    assert_equal get_label(5.1, 1, Time.now - 1.days), body['elements'][1]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
  end

  def test_grouping_by_categories
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :grouping => 'categories', :range_in => 'days', :range_steps => 3

    assert_equal 2, body['elements'].size

    assert_equal 3, body['elements'][0]['values'].size
    assert_equal 'Category1', body['elements'][0]['text']

    assert_in_delta 6.6, body['elements'][0]['values'][0]['value'], 0.1
    assert_equal get_label(6.6, 2, Time.now - 2.days), body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 2.3, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(2.3, 1, Time.now - 1.days), body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_equal 3, body['elements'][1]['values'].size
    assert_equal l(:charts_group_none), body['elements'][1]['text']

    assert_in_delta 0, body['elements'][1]['values'][0]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 2.days), body['elements'][1]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 5.1, body['elements'][1]['values'][1]['value'], 0.1
    assert_equal get_label(5.1, 1, Time.now - 1.days), body['elements'][1]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
  end

  def test_grouping_by_activities
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :grouping => 'activities', :range_in => 'days', :range_steps => 3

    assert_equal 2, body['elements'].size

    assert_equal 3, body['elements'][0]['values'].size
    assert_equal 'Design', body['elements'][0]['text']

    assert_in_delta 3.3, body['elements'][0]['values'][0]['value'], 0.1
    assert_equal get_label(3.3, 1, Time.now - 2.days), body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 5.1, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(5.1, 1, Time.now - 1.days), body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_equal 3, body['elements'][1]['values'].size
    assert_equal 'Development', body['elements'][1]['text']

    assert_in_delta 3.3, body['elements'][1]['values'][0]['value'], 0.1
    assert_equal get_label(3.3, 1, Time.now - 2.days), body['elements'][1]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 2.3, body['elements'][1]['values'][1]['value'], 0.1
    assert_equal get_label(2.3, 1, Time.now - 1.days), body['elements'][1]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
  end

  def test_users_condition
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :range_in => 'days', "conditions_time_entries.user_id".to_sym => 15042

    assert_equal 10, body['elements'][0]['values'].size
    assert_equal l(:charts_group_all), body['elements'][0]['text']

    assert_in_delta 0, body['elements'][0]['values'][0]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 9.days), body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 4.3, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(4.3, 1, Time.now - 8.days), body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][2]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 7.days), body['elements'][0]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][3]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 6.days), body['elements'][0]['values'][3]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 2.3, body['elements'][0]['values'][4]['value'], 0.1
    assert_equal get_label(2.3, 1, Time.now - 5.days), body['elements'][0]['values'][4]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][5]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 4.days), body['elements'][0]['values'][5]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][6]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 3.days), body['elements'][0]['values'][6]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 3.3, body['elements'][0]['values'][7]['value'], 0.1
    assert_equal get_label(3.3, 1, Time.now - 2.days), body['elements'][0]['values'][7]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][8]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 1.days), body['elements'][0]['values'][8]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][9]['value'], 0.1
    assert_equal get_label(0, 0, Time.now), body['elements'][0]['values'][9]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
  end

  def test_issues_condition
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :range_in => 'days', "conditions_time_entries.issue_id".to_sym => 15045

    assert_equal 10, body['elements'][0]['values'].size
    assert_equal l(:charts_group_all), body['elements'][0]['text']

    assert_in_delta 0, body['elements'][0]['values'][0]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 9.days), body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 8.days), body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][2]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 7.days), body['elements'][0]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][3]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 6.days), body['elements'][0]['values'][3]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][4]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 5.days), body['elements'][0]['values'][4]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][5]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 4.days), body['elements'][0]['values'][5]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][6]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 3.days), body['elements'][0]['values'][6]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 6.6, body['elements'][0]['values'][7]['value'], 0.1
    assert_equal get_label(6.6, 2, Time.now - 2.days), body['elements'][0]['values'][7]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 2.3, body['elements'][0]['values'][8]['value'], 0.1
    assert_equal get_label(2.3, 1, Time.now - 1.days), body['elements'][0]['values'][8]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][9]['value'], 0.1
    assert_equal get_label(0, 0, Time.now), body['elements'][0]['values'][9]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
  end

  def test_activities_condition
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :range_in => 'days', "conditions_time_entries.activity_id".to_sym => 15045

    assert_equal 10, body['elements'][0]['values'].size
    assert_equal l(:charts_group_all), body['elements'][0]['text']

    assert_in_delta 0, body['elements'][0]['values'][0]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 9.days), body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 4.3, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(4.3, 1, Time.now - 8.days), body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][2]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 7.days), body['elements'][0]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 2.3, body['elements'][0]['values'][3]['value'], 0.1
    assert_equal get_label(2.3, 1, Time.now - 6.days), body['elements'][0]['values'][3]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 6.6, body['elements'][0]['values'][4]['value'], 0.1
    assert_equal get_label(6.6, 2, Time.now - 5.days), body['elements'][0]['values'][4]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][5]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 4.days), body['elements'][0]['values'][5]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][6]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 3.days), body['elements'][0]['values'][6]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 3.3, body['elements'][0]['values'][7]['value'], 0.1
    assert_equal get_label(3.3, 1, Time.now - 2.days), body['elements'][0]['values'][7]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 5.1, body['elements'][0]['values'][8]['value'], 0.1
    assert_equal get_label(5.1, 1, Time.now - 1.days), body['elements'][0]['values'][8]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][9]['value'], 0.1
    assert_equal get_label(0, 0, Time.now), body['elements'][0]['values'][9]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
  end

  def test_priorities_condition
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :range_in => 'days', "conditions_issues.priority_id".to_sym => 15044

    assert_equal 10, body['elements'][0]['values'].size
    assert_equal l(:charts_group_all), body['elements'][0]['text']

    assert_in_delta 0, body['elements'][0]['values'][0]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 9.days), body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 7.6, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(7.6, 2, Time.now - 8.days), body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][2]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 7.days), body['elements'][0]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][3]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 6.days), body['elements'][0]['values'][3]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][4]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 5.days), body['elements'][0]['values'][4]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][5]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 4.days), body['elements'][0]['values'][5]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][6]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 3.days), body['elements'][0]['values'][6]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][7]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 2.days), body['elements'][0]['values'][7]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][8]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 1.days), body['elements'][0]['values'][8]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][9]['value'], 0.1
    assert_equal get_label(0, 0, Time.now), body['elements'][0]['values'][9]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
  end

  def test_trackers_condition
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :range_in => 'days', "conditions_issues.tracker_id".to_sym => 15041

    assert_equal 10, body['elements'][0]['values'].size
    assert_equal l(:charts_group_all), body['elements'][0]['text']

    assert_in_delta 0, body['elements'][0]['values'][0]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 9.days), body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 8.days), body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][2]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 7.days), body['elements'][0]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][3]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 6.days), body['elements'][0]['values'][3]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][4]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 5.days), body['elements'][0]['values'][4]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][5]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 4.days), body['elements'][0]['values'][5]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][6]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 3.days), body['elements'][0]['values'][6]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 6.6, body['elements'][0]['values'][7]['value'], 0.1
    assert_equal get_label(6.6, 2, Time.now - 2.days), body['elements'][0]['values'][7]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 2.3, body['elements'][0]['values'][8]['value'], 0.1
    assert_equal get_label(2.3, 1, Time.now - 1.days), body['elements'][0]['values'][8]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][9]['value'], 0.1
    assert_equal get_label(0, 0, Time.now), body['elements'][0]['values'][9]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
  end

  def test_versions_condition
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :range_in => 'days', "conditions_issues.fixed_version_id".to_sym => 15042

    assert_equal 10, body['elements'][0]['values'].size
    assert_equal l(:charts_group_all), body['elements'][0]['text']

    assert_in_delta 0, body['elements'][0]['values'][0]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 9.days), body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 7.6, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(7.6, 2, Time.now - 8.days), body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][2]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 7.days), body['elements'][0]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][3]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 6.days), body['elements'][0]['values'][3]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][4]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 5.days), body['elements'][0]['values'][4]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][5]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 4.days), body['elements'][0]['values'][5]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][6]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 3.days), body['elements'][0]['values'][6]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 6.6, body['elements'][0]['values'][7]['value'], 0.1
    assert_equal get_label(6.6, 2, Time.now - 2.days), body['elements'][0]['values'][7]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 2.3, body['elements'][0]['values'][8]['value'], 0.1
    assert_equal get_label(2.3, 1, Time.now - 1.days), body['elements'][0]['values'][8]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][9]['value'], 0.1
    assert_equal get_label(0, 0, Time.now), body['elements'][0]['values'][9]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
  end

  def test_categories_condition
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :range_in => 'days', "conditions_issues.category_id".to_sym => 15041

    assert_equal 10, body['elements'][0]['values'].size
    assert_equal l(:charts_group_all), body['elements'][0]['text']

    assert_in_delta 0, body['elements'][0]['values'][0]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 9.days), body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 8.days), body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][2]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 7.days), body['elements'][0]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][3]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 6.days), body['elements'][0]['values'][3]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][4]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 5.days), body['elements'][0]['values'][4]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][5]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 4.days), body['elements'][0]['values'][5]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][6]['value'], 0.1
    assert_equal get_label(0, 0, Time.now - 3.days), body['elements'][0]['values'][6]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 6.6, body['elements'][0]['values'][7]['value'], 0.1
    assert_equal get_label(6.6, 2, Time.now - 2.days), body['elements'][0]['values'][7]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 2.3, body['elements'][0]['values'][8]['value'], 0.1
    assert_equal get_label(2.3, 1, Time.now - 1.days), body['elements'][0]['values'][8]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][0]['values'][9]['value'], 0.1
    assert_equal get_label(0, 0, Time.now), body['elements'][0]['values'][9]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
  end

  def test_all_conditions
    Setting.default_language = 'en'

    get_data :project_id => 15041, "conditions_issues.category_id".to_sym => 15043, "conditions_issues.tracker_id".to_sym => 15043, "conditions_issues.fixed_version_id".to_sym => 15043, "conditions_issues.fixed_version_id".to_sym => 15041, "conditions_time_entries.user_id".to_sym => 15043, "conditions_time_entries.issue_id".to_sym => 15043, "conditions_time_entries.activity_id".to_sym => 15043
  end

  def get_label(hours, entries, date_from)
    if(hours > 0)
      "#{l(:charts_timeline_hint, :hours => hours, :entries => entries)}<br>#{get_day_labels(date_from)}"
    else
      "#{l(:charts_timeline_hint_empty)}<br>#{get_day_labels(date_from)}"
    end
  end

end
