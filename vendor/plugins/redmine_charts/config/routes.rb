require 'redmine_charts/utils'

# Configuring routing for plugin's controllers.

ActionController::Routing::Routes.draw do |map|
  RedmineCharts::Utils.controllers_for_routing do |name, controller|
    map.connect "projects/:project_id/charts/#{name}/:action", :controller => controller 
  end
end