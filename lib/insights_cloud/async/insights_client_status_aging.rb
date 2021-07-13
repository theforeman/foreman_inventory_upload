module InsightsCloud
  module Async
    class InsightsClientStatusAging < ::Actions::EntryAction
      include ::Actions::RecurringAction

      def run
        # update all stale records to "not reporting" counterpart
        InsightsClientReportStatus.stale.reporting.update_all(status: InsightsClientReportStatus::NO_REPORT)
        InsightsClientReportStatus.stale.not_managed_with_data.update_all(status: InsightsClientReportStatus::NOT_MANAGED)
      end

      def logger
        action_logger
      end
    end
  end
end
