require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/charts_controller_test'
require 'charts_burndown_controller'

# Re-raise errors caught by the controller.
class ChartsBurndownController; def rescue_action(e) raise e end; end

class ChartsBurndownControllerTest < ChartsControllerTest

  def setup
    @controller = ChartsBurndownController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    User.current = nil
  end

  def test_get_data
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :range_steps => 4, :range_in => 'days'

    assert_equal l(:charts_burndown_y), body['y_legend']['text']
    assert_equal l(:charts_burndown_x), body['x_legend']['text']
    assert_in_delta 60, body['y_axis']['max'], 1
    assert_equal 0, body['y_axis']['min']
    assert_in_delta 4, body['x_axis']['max'], 1
    assert_equal 0, body['x_axis']['min']
    assert_equal 4, body['x_axis']['labels']['labels'].size
    assert_equal get_day_labels(Time.now - 3.day), body['x_axis']['labels']['labels'][0]
    assert_equal get_day_labels(Time.now - 2.day), body['x_axis']['labels']['labels'][1]
    assert_equal get_day_labels(Time.now - 1.day), body['x_axis']['labels']['labels'][2]
    assert_equal get_day_labels(Time.now), body['x_axis']['labels']['labels'][3]

    assert_equal 4, body['elements'].size
    assert_equal 4, body['elements'][0]['values'].size
    assert_equal l(:charts_burndown_group_estimated), body['elements'][0]['text']
    assert_equal 4, body['elements'][1]['values'].size
    assert_equal l(:charts_burndown_group_logged), body['elements'][1]['text']
    assert_equal 4, body['elements'][2]['values'].size
    assert_equal l(:charts_burndown_group_remaining), body['elements'][2]['text']
    assert_equal 4, body['elements'][3]['values'].size
    assert_equal l(:charts_burndown_group_predicted), body['elements'][3]['text']

    assert_in_delta 18, body['elements'][0]['values'][0]['value'], 0.1 
    assert_equal "#{l(:charts_burndown_hint_estimated, :estimated_hours => 18.0)}<br>#{get_day_labels(Time.now - 3.day)}", body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 30, body['elements'][0]['values'][1]['value'], 0.1 
    assert_equal "#{l(:charts_burndown_hint_estimated, :estimated_hours => 30.0)}<br>#{get_day_labels(Time.now - 2.day)}", body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 30, body['elements'][0]['values'][2]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_estimated, :estimated_hours => 30.0)}<br>#{get_day_labels(Time.now - 1.day)}", body['elements'][0]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 22.0 : 22.1
    tmp2 = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 36.1 : 36.0

    assert_in_delta 22.05, body['elements'][1]['values'][0]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_logged, :logged_hours => tmp)}<br>#{get_day_labels(Time.now - 3.day)}", body['elements'][1]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 28.65, body['elements'][1]['values'][1]['value'], 0.1 
    assert_equal "#{l(:charts_burndown_hint_logged, :logged_hours => 28.7)}<br>#{get_day_labels(Time.now - 2.day)}", body['elements'][1]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 36.05, body['elements'][1]['values'][2]['value'], 0.1 
    assert_equal "#{l(:charts_burndown_hint_logged, :logged_hours => tmp2)}<br>#{get_day_labels(Time.now - 1.day)}", body['elements'][1]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_in_delta 4.8, body['elements'][2]['values'][0]['value'], 0.1 
    assert_equal "#{l(:charts_burndown_hint_remaining, :remaining_hours => 4.8, :work_done => 82)}<br>#{get_day_labels(Time.now - 3.day)}", body['elements'][2]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 21.3, body['elements'][2]['values'][1]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_remaining, :remaining_hours => 21.3, :work_done => 57)}<br>#{get_day_labels(Time.now - 2.day)}", body['elements'][2]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 13.1, body['elements'][2]['values'][2]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_remaining, :remaining_hours => 13.1, :work_done => 73)}<br>#{get_day_labels(Time.now - 1.day)}", body['elements'][2]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_in_delta 26.8, body['elements'][3]['values'][0]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_predicted_over_estimation, :predicted_hours => 26.8, :hours_over_estimation => 8.8)}<br>#{get_day_labels(Time.now - 3.day)}", body['elements'][3]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 50.0, body['elements'][3]['values'][1]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_predicted_over_estimation, :predicted_hours => 50.0, :hours_over_estimation => 20.0)}<br>#{get_day_labels(Time.now - 2.day)}", body['elements'][3]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 49.2, body['elements'][3]['values'][2]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_predicted_over_estimation, :predicted_hours => 49.2, :hours_over_estimation => 19.2)}<br>#{get_day_labels(Time.now - 1.day)}", body['elements'][3]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

  end

  def test_include_subprojects
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :range_steps => 4, :include_subprojects => 1, :range_in => 'days'

    assert_in_delta 23, body['elements'][0]['values'][0]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_estimated, :estimated_hours => 23.0)}<br>#{get_day_labels(Time.now - 3.day)}", body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 35, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_estimated, :estimated_hours => 35.0)}<br>#{get_day_labels(Time.now - 2.day)}", body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 35, body['elements'][0]['values'][2]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_estimated, :estimated_hours => 35.0)}<br>#{get_day_labels(Time.now - 1.day)}", body['elements'][0]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_in_delta 29.35, body['elements'][1]['values'][0]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_logged, :logged_hours => 29.4)}<br>#{get_day_labels(Time.now - 3.day)}", body['elements'][1]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 35.95, body['elements'][1]['values'][1]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_logged, :logged_hours => 36.0)}<br>#{get_day_labels(Time.now - 2.day)}", body['elements'][1]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 43.35, body['elements'][1]['values'][2]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_logged, :logged_hours => 43.4)}<br>#{get_day_labels(Time.now - 1.day)}", body['elements'][1]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_in_delta 4.7, body['elements'][2]['values'][0]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_remaining, :remaining_hours => 4.7, :work_done => 86)}<br>#{get_day_labels(Time.now - 3.day)}", body['elements'][2]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 20.7, body['elements'][2]['values'][1]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_remaining, :remaining_hours => 20.7, :work_done => 63)}<br>#{get_day_labels(Time.now - 2.day)}", body['elements'][2]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 12.8, body['elements'][2]['values'][2]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_remaining, :remaining_hours => 12.8, :work_done => 77)}<br>#{get_day_labels(Time.now - 1.day)}", body['elements'][2]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_in_delta 34.15, body['elements'][3]['values'][0]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_predicted_over_estimation, :predicted_hours => 34.1, :hours_over_estimation => 11.1)}<br>#{get_day_labels(Time.now - 3.day)}", body['elements'][3]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 56.7, body['elements'][3]['values'][1]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_predicted_over_estimation, :predicted_hours => 56.7, :hours_over_estimation => 21.7)}<br>#{get_day_labels(Time.now - 2.day)}", body['elements'][3]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 56.2, body['elements'][3]['values'][2]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_predicted_over_estimation, :predicted_hours => 56.2, :hours_over_estimation => 21.2)}<br>#{get_day_labels(Time.now - 1.day)}", body['elements'][3]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

  end

  def test_status_closed
    Setting.default_language = 'en'

    body = get_data :project_id => 15043, :range_steps => 4, :range_in => 'days'

    assert_in_delta 0, body['elements'][0]['values'][0]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_estimated, :estimated_hours => 0.0)}<br>#{get_day_labels(Time.now - 3.day)}", body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 12, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_estimated, :estimated_hours => 12.0)}<br>#{get_day_labels(Time.now - 2.day)}", body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 12, body['elements'][0]['values'][2]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_estimated, :estimated_hours => 12.0)}<br>#{get_day_labels(Time.now - 1.day)}", body['elements'][0]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_in_delta 0, body['elements'][1]['values'][0]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_logged, :logged_hours => 0.0)}<br>#{get_day_labels(Time.now - 3.day)}", body['elements'][1]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 0, body['elements'][1]['values'][1]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_logged, :logged_hours => 0.0)}<br>#{get_day_labels(Time.now - 2.day)}", body['elements'][1]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 7, body['elements'][1]['values'][2]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_logged, :logged_hours => 7.0)}<br>#{get_day_labels(Time.now - 1.day)}", body['elements'][1]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_in_delta 0, body['elements'][2]['values'][0]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_remaining, :remaining_hours => 0.0, :work_done => 0)}<br>#{get_day_labels(Time.now - 3.day)}", body['elements'][2]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 12, body['elements'][2]['values'][1]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_remaining, :remaining_hours => 12.0, :work_done => 0)}<br>#{get_day_labels(Time.now - 2.day)}", body['elements'][2]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    # Should be 0, http://github.com/mszczytowski/redmine_charts/issues#issue/1
    assert_in_delta 4.7, body['elements'][2]['values'][2]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_remaining, :remaining_hours => 4.7, :work_done => 60)}<br>#{get_day_labels(Time.now - 1.day)}", body['elements'][2]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_in_delta 0, body['elements'][3]['values'][0]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_predicted, :predicted_hours => 0.0)}<br>#{get_day_labels(Time.now - 3.day)}", body['elements'][3]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 12, body['elements'][3]['values'][1]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_predicted, :predicted_hours => 12.0)}<br>#{get_day_labels(Time.now - 2.day)}", body['elements'][3]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    # Should be 7.
    assert_in_delta 11.7, body['elements'][3]['values'][2]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_predicted, :predicted_hours => 11.7)}<br>#{get_day_labels(Time.now - 1.day)}", body['elements'][3]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
  end

end
