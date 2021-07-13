module InventorySync
  module Async
    class InventorySelfHostSync < QueryInventoryJob
      set_callback :step, :around, :create_facets

      def create_facets
        # get the results from the event
        results = yield

        add_missing_insights_facet(results.uuid_by_fqdn) unless results.uuid_by_fqdn.empty?
        results
      end

      private

      def add_missing_insights_facet(uuids_hash)
        facet = InsightsFacet.find_or_create_by(host_id: ForemanRhCloud.foreman_host.id) do |facet|
          facet.uuid = uuids_hash.values.first
        end

        # fix empty uuid in case the facet already exists
        facet.update(uuid: uuids_hash.values.first) unless facet.uuid
      end

      def request_url
        ForemanInventoryUpload.inventory_self_url
      end
    end
  end
end
