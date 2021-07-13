require 'rest-client'

module InventorySync
  module Async
    class QueryInventoryJob < ::Actions::EntryAction
      include ActiveSupport::Callbacks
      include ::ForemanRhCloud::CloudAuth

      define_callbacks :iteration, :step

      def run
        run_callbacks :iteration do
          page = 1
          loop do
            api_response = query_inventory(page)
            results = HostResult.new(api_response)
            logger.debug("Downloaded cloud inventory data: #{results.percentage}%")

            run_callbacks :step do
              results
            end

            page += 1
            break if results.last?
          end
        end
      end

      private

      def query_inventory(page = 1)
        hosts_inventory_response = execute_cloud_request(
          method: :get,
          url: request_url,
          headers: {
            params: {
              per_page: 100,
              page: page,
            },
          }
        )

        JSON.parse(hosts_inventory_response)
      end

      def logger
        action_logger
      end

      def request_url
        ForemanInventoryUpload.inventory_export_url
      end
    end
  end
end
