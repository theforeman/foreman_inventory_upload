require 'test_plugin_helper'
require 'foreman_tasks/test_helpers'

class InventoryHostsSyncTest < ActiveSupport::TestCase
  include ForemanTasks::TestHelpers::WithInThreadExecutor

  setup do
    User.current = User.find_by(login: 'secret_admin')

    env = FactoryBot.create(:katello_k_t_environment)
    cv = env.content_views << FactoryBot.create(:katello_content_view, organization: env.organization)

    # this host would pass our plugin queries, so it could be uploaded to the cloud.
    @host1 = FactoryBot.create(
      :host,
      :with_subscription,
      :with_content,
      content_view: cv.first,
      lifecycle_environment: env,
      organization: env.organization
    )

    pool = FactoryBot.create(:katello_pool, account_number: '1234', cp_id: 1)

    @host1.subscription_facet.pools << pool

    # this host would pass our plugin queries, so it could be uploaded to the cloud.
    @host2 = FactoryBot.create(
      :host,
      :with_subscription,
      :with_content,
      content_view: cv.first,
      lifecycle_environment: env,
      organization: env.organization
    )

    @host2.subscription_facet.pools << pool
    @host2_inventory_id = '4536bf5c-ff03-4154-a8c9-32ff4b40e40c'

    ForemanInventoryUpload::Generators::Queries.instance_variable_set(:@fact_names, nil)

    inventory_json = <<-INVENTORY_JSON
    {
      "total": 3,
      "count": 3,
      "page": 1,
      "per_page": 3,
      "results": [
        {
          "insights_id": "72d29d75-dbbf-4121-9566-2f581ab77f36",
          "rhel_machine_id": null,
          "subscription_manager_id": "#{@host2.subscription_facet.uuid}",
          "satellite_id": "bb72bf95-0a19-4090-8009-f0d8c68aca61",
          "bios_uuid": "b48a7e5f-cb50-4029-a75e-366bf43db641",
          "ip_addresses": [
            "192.168.122.56"
          ],
          "fqdn": "#{@host2.fqdn}",
          "mac_addresses": [
            "52:54:00:aa:12:12",
            "00:00:00:00:00:00"
          ],
          "external_id": null,
          "id": "#{@host2_inventory_id}",
          "account": "1460290",
          "display_name": "insights-rh7.example.com",
          "ansible_host": null,
          "facts": [
            {
              "namespace": "satellite",
              "facts": {
                "virtual_host_name": "virt-who-nobody.home-1",
                "satellite_instance_id": "fc4d0cb0-a0b0-421e-b096-b028319b8e47",
                "is_simple_content_access": false,
                "distribution_version": "7.3",
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
                "yupana_host_id": "e85958b6-58db-4cfd-aeb6-01ee81bc0f43",
                "account": "1460290"
              }
            }
          ],
          "reporter": "puptoo",
          "stale_timestamp": "2021-03-19T07:57:42.466399+00:00",
          "stale_warning_timestamp": "2021-03-26T07:57:42.466399+00:00",
          "culled_timestamp": "2021-04-02T07:57:42.466399+00:00",
          "created": "2021-02-08T14:36:03.613880+00:00",
          "updated": "2021-03-18T02:57:42.535250+00:00"
        },
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
          "id": "3255d080-e6c1-44e2-8d72-b044b9a38d8f",
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
        },
        {
          "insights_id": "b533848e-465f-4f1a-9b2b-b71cb2d5239d",
          "rhel_machine_id": null,
          "subscription_manager_id": "d29bde40-348e-437c-8acf-8fa98320fc1b",
          "satellite_id": "d29bde40-348e-437c-8acf-8fa98320fc1b",
          "bios_uuid": "3cd5d972-cfb5-451a-8314-fd2f56629d7c",
          "ip_addresses": [
            "172.16.5.39",
            "fd6e:2298:736e::857",
            "fd6e:2298:736e:0:2c66:6101:9cc6:2b23"
          ],
          "fqdn": "rhel8-demo.oss-lab.net",
          "mac_addresses": [
            "6e:66:a6:fe:fc:07",
            "00:00:00:00:00:00"
          ],
          "external_id": null,
          "id": "59ab38db-c25b-4fc7-bfb2-c8eb01d865a9",
          "account": "1460290",
          "display_name": "rhel8-demo.oss-lab.net",
          "ansible_host": null,
          "facts": [
            {
              "namespace": "satellite",
              "facts": {
                "satellite_instance_id": "fb3643d8-9030-487b-b95c-684783806ffd",
                "system_purpose_sla": "",
                "is_simple_content_access": false,
                "distribution_version": "8.3",
                "satellite_version": "6.8.1",
                "organization_id": 1,
                "system_purpose_role": "",
                "system_purpose_usage": "",
                "is_hostname_obfuscated": false
              }
            },
            {
              "namespace": "yupana",
              "facts": {
                "report_platform_id": "fa8b924c-51ee-479d-97d2-b4623cf1d4aa",
                "report_slice_id": "0b49103f-6471-4ade-ad74-a51537bc5691",
                "source": "Satellite",
                "yupana_host_id": "30e43340-12fb-445d-b23f-faaf5cbc2092",
                "account": "1460290"
              }
            }
          ],
          "reporter": "puptoo",
          "stale_timestamp": "2021-03-19T05:55:23.700781+00:00",
          "stale_warning_timestamp": "2021-03-26T05:55:23.700781+00:00",
          "culled_timestamp": "2021-04-02T05:55:23.700781+00:00",
          "created": "2021-01-13T20:05:51.059012+00:00",
          "updated": "2021-03-18T00:55:23.739162+00:00"
        }
      ]
    }
    INVENTORY_JSON
    @inventory = JSON.parse(inventory_json)
  end

  def interesting_facts
    [
      'dmi::system::uuid',
      'virt::uuid',
      'cpu::cpu(s)',
      'cpu::cpu_socket(s)',
      'cpu::core(s)_per_socket',
      'memory::memtotal',
      'dmi::bios::vendor',
      'dmi::bios::version',
      'dmi::bios::relase_date',
      'uname::release',
      'lscpu::flags',
      'distribution::name',
      'distribution::version',
      'distribution::id',
      'virt::is_guest',
      'dmi::system::manufacturer',
      'dmi::system::product_name',
      'dmi::chassis::asset_tag',
      'insights_client::obfuscate_hostname_enabled',
      'insights_client::hostname',
    ]
  end

  def fact_names
    @fact_names ||= Hash[
      interesting_facts.map do |fact|
        [fact, FactoryBot.create(:fact_name, name: fact, type: 'Katello::RhsmFactName')]
      end
    ]
  end

  test 'Inventory should sync UUID for existing Insights Facets' do
    InventorySync::Async::InventoryHostsSync.any_instance.expects(:query_inventory).returns(@inventory)
    InventorySync::Async::InventoryHostsSync.any_instance.expects(:plan_self_host_sync)

    @host2.build_insights.save

    ForemanTasks.sync_task(InventorySync::Async::InventoryHostsSync)

    @host2.reload

    assert_equal @host2_inventory_id, @host2.insights.uuid
  end

  test 'Inventory should sync UUID for new Insights Facets' do
    InventorySync::Async::InventoryHostsSync.any_instance.expects(:query_inventory).returns(@inventory)
    InventorySync::Async::InventoryHostsSync.any_instance.expects(:plan_self_host_sync)

    ForemanTasks.sync_task(InventorySync::Async::InventoryHostsSync)

    @host2.reload

    assert_equal @host2_inventory_id, @host2.insights.uuid
  end
end
