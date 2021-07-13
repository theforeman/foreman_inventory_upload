require 'test_plugin_helper'
require 'foreman_tasks/test_helpers'

class InventorySelfHostSyncTest < ActiveSupport::TestCase
  include ForemanTasks::TestHelpers::WithInThreadExecutor

  setup do
    User.current = User.find_by(login: 'secret_admin')

    # this host would pass our plugin queries, so it could be uploaded to the cloud.
    @host1 = FactoryBot.create(:host)
    @host1_inventory_id = '3255d080-e6c1-44e2-8d72-b044b9a38d8f'

    ForemanInventoryUpload::Generators::Queries.instance_variable_set(:@fact_names, nil)

    ForemanRhCloud.stubs(:foreman_host).returns(@host1)

    inventory_json = <<-INVENTORY_JSON
    {
      "total": 1,
      "count": 1,
      "page": 1,
      "per_page": 1,
      "results": [
        {
          "insights_id": "e0dc5144-d78e-43ed-97be-a7a21d1b6946",
          "rhel_machine_id": null,
          "subscription_manager_id": "0f97ee19-6862-4900-aea4-f121c8754776",
          "satellite_id": "0f97ee19-6862-4900-aea4-f121c8754776",
          "bios_uuid": "6a0b199a-8225-4ade-ae44-3b18cfc84a01",
          "ip_addresses": [
            "192.168.122.136"
          ],
          "fqdn": "#{@host1.fqdn}",
          "mac_addresses": [
            "52:54:00:02:d1:2a",
            "00:00:00:00:00:00"
          ],
          "external_id": null,
          "id": "#{@host1_inventory_id}",
          "account": "1460290",
          "display_name": "insights-rh8.example.com",
          "ansible_host": null,
          "facts": [
            {
              "namespace": "satellite",
              "facts": {
                "virtual_host_name": "virt-who-nobody.home-1",
                "satellite_instance_id": "fc4d0cb0-a0b0-421e-b096-b028319b8e47",
                "is_simple_content_access": false,
                "distribution_version": "8.3",
                "satellite_version": "6.8.4",
                "organization_id": 1,
                "is_hostname_obfuscated": false,
                "virtual_host_uuid": "a90e6294-4766-420a-8dc0-3ec5b96d60ec"
              }
            },
            {
              "namespace": "yupana",
              "facts": {
                "report_platform_id": "d37afa50-08ce-4efb-a0e5-759c2a016661",
                "report_slice_id": "5bf791d7-5e30-4a3c-929a-11dd9fa6eb72",
                "source": "Satellite",
                "yupana_host_id": "78c62486-0ac4-406c-a4c0-3a1f81112a2d",
                "account": "1460290"
              }
            }
          ],
          "reporter": "puptoo",
          "stale_timestamp": "2021-03-19T06:05:12.092136+00:00",
          "stale_warning_timestamp": "2021-03-26T06:05:12.092136+00:00",
          "culled_timestamp": "2021-04-02T06:05:12.092136+00:00",
          "created": "2021-02-08T13:22:50.555671+00:00",
          "updated": "2021-03-18T01:05:12.131847+00:00"
        }
      ]
    }
    INVENTORY_JSON
    @inventory = JSON.parse(inventory_json)
  end

  test 'Inventory should sync UUID for existing Insights Facets' do
    InventorySync::Async::InventorySelfHostSync.any_instance.expects(:query_inventory).returns(@inventory)

    @host1.build_insights.save

    ForemanTasks.sync_task(InventorySync::Async::InventorySelfHostSync)

    @host1.reload

    assert_equal @host1_inventory_id, @host1.insights.uuid
  end

  test 'Inventory should sync UUID for new Insights Facets' do
    InventorySync::Async::InventorySelfHostSync.any_instance.expects(:query_inventory).returns(@inventory)

    ForemanTasks.sync_task(InventorySync::Async::InventorySelfHostSync)

    @host1.reload

    assert_equal @host1_inventory_id, @host1.insights.uuid
  end
end
