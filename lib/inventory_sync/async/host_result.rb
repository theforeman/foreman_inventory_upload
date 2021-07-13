module InventorySync
  module Async
    class HostResult
      attr_reader :uuid_by_fqdn

      def initialize(result)
        @total = result['total']
        @count = result['count']
        @page = result['page']
        @per_page = result['per_page']
        @sub_ids = result["results"].map { |host| host['subscription_manager_id'] }
        @uuid_by_sub_id = Hash[result["results"].map { |host| [host['subscription_manager_id'], host['id']] }]
        @uuid_by_fqdn = Hash[result["results"].map { |host| [host['fqdn'].downcase, host['id']] }]
      end

      def status_hashes
        @sub_ids.map do |sub_id|
          host_id = host_id(sub_id)
          if host_id
            touched << host_id
            {
              host_id: host_id,
              status: InventorySync::InventoryStatus::SYNC,
              reported_at: DateTime.current,
            }
          end
        end.compact
      end

      def touched
        @touched ||= []
      end

      def host_id(sub_id)
        hosts[sub_id]
      end

      def hosts
        @hosts ||= Hash[
          Katello::Host::SubscriptionFacet.where(uuid: @sub_ids).pluck(:uuid, :host_id)
        ]
      end

      def host_uuids
        @host_uuids ||= Hash[@sub_ids.map { |sub_id| [host_id(sub_id), @uuid_by_sub_id[sub_id]] }].except(nil)
      end

      def percentage
        ratio = @per_page * @page * 1.0 / @total * 100
        ratio > 100 ? 100 : ratio.truncate(2)
      end

      def last?
        @total <= @per_page * @page
      end
    end
  end
end
