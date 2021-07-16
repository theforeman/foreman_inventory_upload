module ForemanInventoryUpload
  module Generators
    class Queries
      def self.fact_names
        @fact_names ||= Hash[
          Katello::RhsmFactName.where(name:
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
              'distribution::name',
              'uname::release',
              'lscpu::flags',
              'distribution::version',
              'distribution::id',
              'virt::is_guest',
              'dmi::system::manufacturer',
              'dmi::system::product_name',
              'dmi::chassis::asset_tag',
              'insights_client::obfuscate_hostname_enabled',
              'insights_client::obfuscate_ip_enabled',
              'insights_client::hostname',
              'insights_client::ips',
              'insights_id',
            ]).pluck(:name, :id)
          ]
      end

      def self.for_slice(base)
        base
          .joins(:subscription_facet)
          .preload(
            :interfaces,
            :installed_packages,
            :content_facet,
            :host_statuses,
            :inventory_upload_facts,
            subscription_facet: [:pools, :installed_products, :hypervisor_host]
          )
      end

      def self.for_report(portal_user)
        org_ids = organizations_for_user(portal_user).pluck(:id)
        for_org(org_ids)
      end

      def self.for_org(organization_id, use_batches: true)
        base_query = for_slice(Host.unscoped.where(organization_id: organization_id))
        use_batches ? base_query.in_batches(of: ForemanInventoryUpload.slice_size) : base_query
      end

      def self.organizations_for_user(portal_user)
        Organization
          .joins(:telemetry_configuration)
          .where(
            redhat_access_telemetry_configurations: {
              portal_user: portal_user,
              enable_telemetry: true,
            }
          )
      end
    end
  end
end
