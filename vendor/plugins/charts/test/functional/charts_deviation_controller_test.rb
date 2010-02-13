require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/charts_controller_test'
require 'charts_deviation_controller'

# Re-raise errors caught by the controller.
class ChartsDeviationController; def rescue_action(e) raise e end; end

class ChartsDeviationControllerTest < ChartsControllerTest

  def setup
    @controller = ChartsDeviationController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    User.current = nil
  end

  def test_get_data
    Setting.default_language = 'en'

    body = get_data :project_id => 15041
    
    assert_equal 4, body['elements'][0]['values'].size

    assert_in_delta 74.0, body['elements'][0]['values'][0][0]['val'], 1
    assert_equal "#{l(:charts_deviation_hint_logged, :logged_hours => 22.0)}#{l(:charts_deviation_hint_issue, :estimated_hours => 30.0, :work_done => 73)}#{l(:charts_deviation_hint_project_label)}",
      body['elements'][0]['values'][0][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 38.0, body['elements'][0]['values'][0][1]['val'], 1
    assert_equal "#{l(:charts_deviation_hint_remaining_over_estimation, :remaining_hours => 11.0, :hours_over_estimation => 3.0, :over_estimation => 12)}#{l(:charts_deviation_hint_issue, :estimated_hours => 30.0, :work_done => 73)}#{l(:charts_deviation_hint_project_label)}",
      body['elements'][0]['values'][0][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 15.4, body['elements'][0]['values'][0][2]['val'], 1
    assert_equal "#{l(:charts_deviation_hint_logged_not_estimated, :logged_hours => 5.1)}",
      body['elements'][0]['values'][0][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 5.6 : 5.5

    assert_in_delta 56.0, body['elements'][0]['values'][1][0]['val'], 1
    assert_equal "#{l(:charts_deviation_hint_logged, :logged_hours => tmp)}#{l(:charts_deviation_hint_issue, :estimated_hours => 10.0, :work_done => 100)}#{l(:charts_deviation_hint_label, :issue_id => 15041, :issue_name => 'Issue1')}",
      body['elements'][0]['values'][1][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_nil body['elements'][0]['values'][1][1]

    assert_in_delta 95.0, body['elements'][0]['values'][2][0]['val'], 1
    assert_equal "#{l(:charts_deviation_hint_logged, :logged_hours => 7.6)}#{l(:charts_deviation_hint_issue, :estimated_hours => 8.0, :work_done => 60)}#{l(:charts_deviation_hint_label, :issue_id => 15043, :issue_name => 'Issue3')}",
      body['elements'][0]['values'][2][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 63.0, body['elements'][0]['values'][2][1]['val'], 1
    assert_equal "#{l(:charts_deviation_hint_remaining_over_estimation, :remaining_hours => 5.1, :hours_over_estimation => 4.7, :over_estimation => 58)}#{l(:charts_deviation_hint_issue, :estimated_hours => 8.0, :work_done => 60)}#{l(:charts_deviation_hint_label, :issue_id => 15043, :issue_name => 'Issue3')}",
      body['elements'][0]['values'][2][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_in_delta 74.0, body['elements'][0]['values'][3][0]['val'], 1
    assert_equal "#{l(:charts_deviation_hint_logged, :logged_hours => 8.9)}#{l(:charts_deviation_hint_issue, :estimated_hours => 12.0, :work_done => 60)}#{l(:charts_deviation_hint_label, :issue_id => 15045, :issue_name => 'Issue5')}",
      body['elements'][0]['values'][3][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")
    assert_in_delta 49.0, body['elements'][0]['values'][3][1]['val'], 1
    assert_equal "#{l(:charts_deviation_hint_remaining_over_estimation, :remaining_hours => 5.9, :hours_over_estimation => 2.8, :over_estimation => 24)}#{l(:charts_deviation_hint_issue, :estimated_hours => 12.0, :work_done => 60)}#{l(:charts_deviation_hint_label, :issue_id => 15045, :issue_name => 'Issue5')}",
      body['elements'][0]['values'][3][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")

    assert_equal 4, body['elements'][1]['values'].size
    assert_equal 100, body['elements'][1]['values'][0]['y']
    assert_equal 100, body['elements'][1]['values'][1]['y']
    assert_equal 101, body['elements'][1]['values'][2]['y']
    assert_equal 101, body['elements'][1]['values'][3]['y']
    assert_equal -0.45, body['elements'][1]['values'][0]['x']
    assert_equal -0.55 + body['elements'][0]['values'].size, body['elements'][1]['values'][1]['x']
    assert_equal -0.55 + body['elements'][0]['values'].size, body['elements'][1]['values'][2]['x']
    assert_equal -0.45, body['elements'][1]['values'][3]['x']
    
    assert_equal l(:charts_deviation_x), body['x_legend']['text']
    assert_equal l(:charts_deviation_y), body['y_legend']['text']
    assert_equal 0, body['x_axis']['min']
    assert_equal body['elements'][0]['values'].size, body['x_axis']['max']
    assert_equal 1, body['x_axis']['steps']
    assert_equal 0, body['y_axis']['min']
    assert_in_delta 190, body['y_axis']['max'], 1
    assert_in_delta 32, body['y_axis']['steps'], 1
    assert_equal l(:charts_deviation_project_label), body['x_axis']['labels']['labels'][0]
    assert_equal l(:charts_deviation_label, {:issue_id=>15041}), body['x_axis']['labels']['labels'][1]
    assert_equal l(:charts_deviation_label, {:issue_id=>15043}), body['x_axis']['labels']['labels'][2]
    assert_equal l(:charts_deviation_label, {:issue_id=>15045}), body['x_axis']['labels']['labels'][3]
    assert_equal l(:charts_deviation_group_logged), body['elements'][0]['keys'][0]['text']
    assert_equal l(:charts_deviation_group_remaining), body['elements'][0]['keys'][1]['text']
    assert_equal l(:charts_deviation_group_logged_not_estimated), body['elements'][0]['keys'][2]['text']
    assert_equal l(:charts_deviation_group_estimated), body['elements'][0]['keys'][3]['text']
  end

  def test_include_subprojects
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :include_subprojects => 1

    assert_equal 5, body['elements'][0]['values'].size
  end

  def test_pagination
    Setting.default_language = 'en'

    body = get_data :project_id => 15041, :per_page => 2

    assert_equal 3, body['elements'][0]['values'].size

    body = get_data :project_id => 15041, :per_page => 2, :page => 2

    assert_equal 2, body['elements'][0]['values'].size

    body = get_data :project_id => 15041, :per_page => 2, :page => 3

    assert_equal 1, body['elements'][0]['values'].size
  end

end
