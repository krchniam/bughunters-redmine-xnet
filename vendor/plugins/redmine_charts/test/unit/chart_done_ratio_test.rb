require File.dirname(__FILE__) + '/../test_helper'

class ChartTimeEntryTest < ActiveSupport::TestCase

  def test_aggregation
    aggregation = ChartDoneRatio.get_aggregation_for_issue(:project_ids => [15041])
    assert_equal 100, aggregation[15041]
    assert_equal 60, aggregation[15043]
    assert_equal 100, aggregation[15044]
    assert_equal 60, aggregation[15045]
  end

  def test_timeline
    Time.set_current_date = Time.mktime(2010,4,1)
    timeline = ChartDoneRatio.get_timeline_for_issue({:project_ids => 15041}, {:range => :weeks, :limit => 11, :offset => 0})
    assert_equal 4, timeline.size
    assert_equal 11, timeline[15041].size
    assert_equal 11, timeline[15043].size
    assert_equal 11, timeline[15044].size
    assert_equal 11, timeline[15045].size
    assert_equal 0, timeline[15041][0]
    assert_equal 30, timeline[15041][1]
    assert_equal 100, timeline[15041][2]
    assert_equal 100, timeline[15041][9]
  end

end