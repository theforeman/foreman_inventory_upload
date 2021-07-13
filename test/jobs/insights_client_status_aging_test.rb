require 'test_plugin_helper'
require 'foreman_tasks/test_helpers'

class InsightsClientStatusAgingTest < ActiveSupport::TestCase
  include ForemanTasks::TestHelpers::WithInThreadExecutor

  setup do
    User.current = User.find_by(login: 'secret_admin')

    @host1 = FactoryBot.create(:host)
    @host2 = FactoryBot.create(:host)
    @host3 = FactoryBot.create(:host)
    @host4 = FactoryBot.create(:host)

    @hosts = [@host1, @host2, @host3, @host4]
  end

  test 'stale statuses should change' do
    InsightsClientReportStatus.find_or_initialize_by(host_id: @host1.id).update(status: InsightsClientReportStatus::REPORTING, reported_at: Time.now - InsightsClientReportStatus::REPORT_INTERVAL - 1.day)
    InsightsClientReportStatus.find_or_initialize_by(host_id: @host2.id).update(status: InsightsClientReportStatus::NO_REPORT, reported_at: Time.now - InsightsClientReportStatus::REPORT_INTERVAL - 1.day)
    InsightsClientReportStatus.find_or_initialize_by(host_id: @host3.id).update(status: InsightsClientReportStatus::NOT_MANAGED, reported_at: Time.now - InsightsClientReportStatus::REPORT_INTERVAL - 1.day)
    InsightsClientReportStatus.find_or_initialize_by(host_id: @host4.id).update(status: InsightsClientReportStatus::NOT_MANAGED_WITH_DATA, reported_at: Time.now - InsightsClientReportStatus::REPORT_INTERVAL - 1.day)

    ForemanTasks.sync_task(InsightsCloud::Async::InsightsClientStatusAging)

    @hosts.each(&:reload)

    assert_equal InsightsClientReportStatus::NO_REPORT, @host1.get_status(InsightsClientReportStatus).status
    assert_equal InsightsClientReportStatus::NO_REPORT, @host2.get_status(InsightsClientReportStatus).status
    assert_equal InsightsClientReportStatus::NOT_MANAGED, @host3.get_status(InsightsClientReportStatus).status
    assert_equal InsightsClientReportStatus::NOT_MANAGED, @host4.get_status(InsightsClientReportStatus).status
  end
end
