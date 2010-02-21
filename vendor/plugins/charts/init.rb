require 'redmine'

RAILS_DEFAULT_LOGGER.info 'Starting Charts Plugin for RedMine'

require 'dispatcher'
require_dependency 'redmine_charts/enumeration_patch'

unless defined?(Redmine::I18n)
  require_dependency 'redmine_charts/i18n_patch'
end

Dispatcher.to_prepare do
  Enumeration.send(:include, ChartsEnumerationPatch)
end

require_dependency 'redmine_charts/sql_utils'
require_dependency 'redmine_charts/line_data_converter'
require_dependency 'redmine_charts/pie_data_converter'
require_dependency 'redmine_charts/stack_data_converter'
require_dependency 'redmine_charts/utils'
require_dependency 'redmine_charts/conditions_utils'
require_dependency 'redmine_charts/grouping_utils'
require_dependency 'redmine_charts/range_utils'

Redmine::Plugin.register :redmine_charts do
  name 'Charts Plugin'
  author 'Maciej Szczytowski'
  description 'Plugin for Redmine which integrates some nice project charts.'
  url 'http://github.com/mszczytowski/redmine_charts/'
  version '0.0.14'

  # Minimum version of Redmine.

  requires_redmine :version_or_higher => '0.8.0'

  # Configuring permissions for plugin's controllers.

  project_module :charts do
    permission :view_charts, RedmineCharts::Utils.controllers_for_permissions, :require => :member
  end

  # Creating menu entry. It appears in project menu, after 'new_issue' entry.

  menu :project_menu, :charts, { :controller => RedmineCharts::Utils.default_controller, :action => 'index' }, :caption => :charts_menu_label, :after => :new_issue, :param => :project_id
end
