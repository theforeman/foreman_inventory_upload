module InventorySync
  module Async
    class InventoryHostsSync < QueryInventoryJob
      set_callback :iteration, :around, :setup_facet_transaction
      set_callback :step, :around, :create_facets

      def plan
        # by default the tasks will be executed concurrently
        plan_self
        plan_self_host_sync
      end

      def setup_facet_transaction
        InsightsFacet.transaction do
          yield
        end
      end

      def create_facets
        # get the results from the event
        results = yield
        add_missing_insights_facets(results.host_uuids)
        results
      end

      private

      def add_missing_insights_facets(uuids_hash)
        existing_facets = InsightsFacet.where(host_id: uuids_hash.keys).pluck(:host_id, :uuid)
        missing_facets = uuids_hash.except(*existing_facets.map(&:first)).map do |host_id, uuid|
          {
            host_id: host_id,
            uuid: uuid,
          }
        end
        InsightsFacet.create(missing_facets)

        existing_facets.select { |host_id, uuid| uuid.empty? }.each do |host_id, _uuid|
          InsightsFacet.where(host_id: host_id).update_all(uuid: uuids_hash[host_id])
        end
      end

      def plan_self_host_sync
        plan_action InventorySync::Async::InventorySelfHostSync
      end
    end
  end
end
