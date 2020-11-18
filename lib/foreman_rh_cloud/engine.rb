require 'katello'
require 'redhat_access'

module ForemanRhCloud
  class Engine < ::Rails::Engine
    engine_name 'foreman_rh_cloud'

    initializer 'foreman_rh_cloud.load_default_settings', :before => :load_config_initializers do
      require_dependency File.expand_path('../../app/models/setting/rh_cloud.rb', __dir__)
    end

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/overrides"]
    config.autoload_paths += Dir["#{config.root}/app/services"]
    config.autoload_paths += Dir["#{config.root}/lib"]

    config.eager_load_paths += Dir["#{config.root}/lib"]

    # Add any db migrations
    initializer 'foreman_rh_cloud.load_app_instance_data' do |app|
      ForemanRhCloud::Engine.paths['db/migrate'].existent.each do |path|
        app.config.paths['db/migrate'] << path
      end
    end

    initializer 'foreman_rh_cloud.register_plugin', :before => :finisher_hook do |_app|
      Foreman::Plugin.register :foreman_rh_cloud do
        requires_foreman '>= 2.3'

        # Add permissions
        security_block :foreman_rh_cloud do
          permission(
            :generate_foreman_rh_cloud,
            'foreman_inventory_upload/reports': [:generate]
          )
          permission(
            :view_foreman_rh_cloud,
            'foreman_inventory_upload/accounts': [:index],
            'foreman_inventory_upload/reports': [:last],
            'foreman_inventory_upload/uploads': [:auto_upload, :show_auto_upload, :download_file, :last],
            'foreman_rh_cloud/react': [:inventory_upload]
          )
        end

        plugin_permissions = [:view_foreman_rh_cloud, :generate_foreman_rh_cloud]

        role 'ForemanRhCloud', plugin_permissions, 'Role granting permissions to view the hosts inventory,
                                                    generate a report, upload it to the cloud and download it locally'

        add_permissions_to_default_roles Role::ORG_ADMIN => plugin_permissions,
                                         Role::MANAGER => plugin_permissions,
                                         Role::SYSTEM_ADMIN => plugin_permissions

        # Adding a sub menu after hosts menu
        divider :top_menu, caption: N_('RH Cloud'), parent: :configure_menu
        menu :top_menu, :inventory_upload, caption: N_('Inventory Upload'), url_hash: { controller: :'foreman_rh_cloud/react', action: :inventory_upload }, parent: :configure_menu
        menu :top_menu, :insights_hits_import, caption: N_('Insights'), url_hash: { controller: :'foreman_rh_cloud/react', action: :insights_cloud }, parent: :configure_menu

        register_facet InsightsFacet, :insights do
          configure_host do
            set_dependent_action :destroy
          end
        end

        register_global_js_file 'global'

        register_custom_status(InventorySync::InventoryStatus)

        extend_page 'hosts/show' do |context|
          context.add_pagelet :main_tabs,
            partial: 'hosts/insights_tab',
            name: _('Insights'),
            id: 'insights',
            onlyif: proc { |host| host.insights }
        end
      end

      ::Katello::UINotifications::Subscriptions::ManifestImportSuccess.include ForemanInventoryUpload::Notifications::ManifestImportSuccessNotificationOverride if defined?(Katello)

      ::Host::Managed.include RhCloudHost
      ::Host::Base.include RhCloudHost
    end

    initializer "foreman_rh_cloud.set_dynflow.config.on_init", :before => :finisher_hook do |_app|
      unless Rails.env.test?
        ForemanTasks.dynflow.config.on_init do |world|
          ForemanInventoryUpload::Async::GenerateAllReportsJob.spawn_if_missing(world)
          InsightsCloud::Async::InsightsScheduledSync.spawn_if_missing(world)
        end
      end
    end

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ForemanRhCloud::Engine.load_seed
      end
    end

    initializer 'foreman_rh_cloud.register_gettext', after: :load_config_initializers do |_app|
      locale_dir = File.join(File.expand_path('../..', __dir__), 'locale')
      locale_domain = 'foreman_rh_cloud'
      Foreman::Gettext::Support.add_text_domain locale_domain, locale_dir
    end
  end
end
