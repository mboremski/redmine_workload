# frozen_string_literal: true

require File.expand_path('redmine_workload/extensions/user_patch', __dir__)
require File.expand_path('redmine_workload/hooks/after_plugins_loaded_hook', __dir__)
require File.expand_path('redmine_workload/group_workload_preparer', __dir__)
require File.expand_path('redmine_workload/user_workload_preparer', __dir__)
require File.expand_path('redmine_workload/wl_calculation_restrictions', __dir__)
require File.expand_path('redmine_workload/wl_csv_exporter', __dir__)
require File.expand_path('redmine_workload/wl_date_tools', __dir__)
require File.expand_path('redmine_workload/wl_issue_query', __dir__)
require File.expand_path('redmine_workload/wl_issue_state', __dir__)
require File.expand_path('redmine_workload/wl_user_data_finder', __dir__)
require File.expand_path('redmine_workload/wl_user_data_defaults', __dir__)

# Simple Rails related methods
module RedmineWorkload
  # Check whether Redmine is running postgresql database
  def self.postgresql?
    db_config = if ActiveRecord::Base.configurations.respond_to?(:configs_for)
      ActiveRecord::Base.configurations.configs_for(env_name: Rails.env).first
    else
      ActiveRecord::Base.configurations[Rails.env]
    end
    adapter = db_config.respond_to?(:adapter) ? db_config.adapter : db_config['adapter']
    adapter == 'postgresql'
  end
end
