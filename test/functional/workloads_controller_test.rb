# frozen_string_literal: true

require File.expand_path('../test_helper', __dir__)

module RedmineWorkload
  class WorkloadsControllerTest < ActionDispatch::IntegrationTest
    include RedmineWorkload::AuthenticateUser

    fixtures :trackers, :projects, :projects_trackers, :members, :member_roles,
             :users, :issue_statuses, :enumerations, :roles

    test 'should not get index when not allowed to' do
      log_user('jsmith', 'jsmith')

      get workloads_path
      assert_response :forbidden
    end

    test 'should get index' do
      manager = roles :roles_001
      manager.add_permission! :view_all_workloads
      log_user('jsmith', 'jsmith')

      get workloads_path
      assert_response :success
    end

    test 'should get index with format csv' do
      manager = roles :roles_001
      manager.add_permission! :view_all_workloads
      log_user('jsmith', 'jsmith')

      get workloads_path(format: 'csv')
      assert_response :success
    end

    test 'should display error when requesting index as csv with invalid encoding' do
      manager = roles :roles_001
      manager.add_permission! :view_all_workloads
      log_user('jsmith', 'jsmith')

      get workloads_path(format: 'csv', params: { encoding: 'UTF88' })

      assert flash[:error].match(/Character encoding not allowed./)
    end

    test 'should get index with invalid first_day date without raising an error' do
      manager = roles :roles_001
      manager.add_permission! :view_all_workloads
      log_user('jsmith', 'jsmith')

      get workloads_path(workload: { first_day: '2026-01-32' })
      assert_response :success
    end

    test 'should get index with invalid last_day date without raising an error' do
      manager = roles :roles_001
      manager.add_permission! :view_all_workloads
      log_user('jsmith', 'jsmith')

      get workloads_path(workload: { last_day: '2026-13-01' })
      assert_response :success
    end

    test 'should get index with invalid start_date without raising an error' do
      manager = roles :roles_001
      manager.add_permission! :view_all_workloads
      log_user('jsmith', 'jsmith')

      get workloads_path(workload: { start_date: 'not-a-date' })
      assert_response :success
    end

    test 'should get index without error when start_date is after last_day' do
      manager = roles :roles_001
      manager.add_permission! :view_all_workloads
      log_user('jsmith', 'jsmith')

      get workloads_path(workload: {
                           first_day: '2026-01-01',
                           last_day: '2026-01-31',
                           start_date: '2026-06-01'
                         })
      assert_response :success
    end

    test 'should show warning when start_date is after last_day' do
      manager = roles :roles_001
      manager.add_permission! :view_all_workloads
      log_user('jsmith', 'jsmith')

      get workloads_path(workload: {
                           first_day: '2026-01-01',
                           last_day: '2026-01-31',
                           start_date: '2026-06-01'
                         })
      assert flash[:warning].present?
    end
  end
end
