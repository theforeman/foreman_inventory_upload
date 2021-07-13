class InsightsClientReportStatus < HostStatus::Status
  REPORT_INTERVAL = 48.hours

  REPORTING             = 0 # host_registration_insights = true & getting data
  NO_REPORT             = 1 # host_registration_insights = true & not getting data
  NOT_MANAGED           = 2 # host_registration_insights = false
  NOT_MANAGED_WITH_DATA = 3 # host_registration_insights = false & getting data

  scope :stale, -> { where.not(reported_at: (Time.now - REPORT_INTERVAL)..Time.now) }
  scope :reporting, -> { where(status: REPORTING) }
  scope :not_managed_with_data, -> { where(status: NOT_MANAGED_WITH_DATA) }

  def self.status_name
    N_('Insights')
  end

  def to_label(_options = {})
    case status
      when REPORTING
        N_('Reporting')
      when NO_REPORT
        N_('Not reporting')
      when NOT_MANAGED
        N_('Not reporting (not set by registration)')
      when NOT_MANAGED_WITH_DATA
        N_('Reporting (not set by registration)')
    end
  end

  def to_global(_options = {})
    case status
      when REPORTING
        ::HostStatus::Global::OK
      when NO_REPORT
        ::HostStatus::Global::ERROR
      when NOT_MANAGED
        ::HostStatus::Global::OK
      when NOT_MANAGED_WITH_DATA
        ::HostStatus::Global::WARN
    end
  end

  def to_status(data: false)
    if insights_param
      return REPORTING if data
      return in_interval? ? REPORTING : NO_REPORT
    end

    data ? NOT_MANAGED_WITH_DATA : NOT_MANAGED
  end

  private

  def in_interval?
    return false unless reported_at
    (Time.now.utc - reported_at).to_i < REPORT_INTERVAL.to_i
  end

  def insights_param
    host.host_params_hash.dig('host_registration_insights', :value)
  end
end
