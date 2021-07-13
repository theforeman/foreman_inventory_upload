module ForemanInventoryUpload
  def self.base_folder
    # in production setup, where selinux is enabled, we only have rights to
    # create folders under /ver/lib/foreman. If the folder does not exist, it's
    # a dev setup, where we can use our current root
    @base_folder ||= File.join(
      Dir.glob('/var/lib/foreman').first || Dir.getwd,
      'red_hat_inventory/'
    )
  end

  def self.uploads_folder
    @uploads_folder ||= ensure_folder(
      File.join(
        ForemanInventoryUpload.base_folder,
        'uploads/'
      )
    )
  end

  def self.uploads_file_path(filename)
    File.join(ForemanInventoryUpload.uploads_folder, filename)
  end

  def self.done_folder
    File.join(ForemanInventoryUpload.uploads_folder, 'done/')
  end

  def self.done_file_path(filename)
    File.join(ForemanInventoryUpload.done_folder, filename)
  end

  def self.generated_reports_folder
    @generated_reports_folder ||= ensure_folder(
      File.join(
        ForemanInventoryUpload.base_folder,
        'generated_reports/'
      )
    )
  end

  def self.outputs_folder
    @outputs_folder ||= ensure_folder(File.join(ForemanInventoryUpload.base_folder, 'outputs/'))
  end

  def self.upload_script_file
    'uploader.sh'
  end

  def self.facts_archive_name(organization)
    "report_for_#{organization}.tar.xz"
  end

  def self.upload_url
    # for testing set ENV to 'https://ci.cloud.redhat.com/api/ingress/v1/upload'
    @upload_url ||= ENV['SATELLITE_INVENTORY_UPLOAD_URL'] || 'https://cert.cloud.redhat.com/api/ingress/v1/upload'
  end

  def self.slice_size
    @slice_size ||= (ENV['SATELLITE_INVENTORY_SLICE_SIZE'] || '1000').to_i
  end

  def self.max_org_size
    # Set max amount of hosts per organization for automatic uploads
    @max_org_size ||= (ENV['SATELLITE_INVENTORY_MAX_ORG_SIZE'] || 150_000).to_i
  end

  def self.ensure_folder(folder)
    FileUtils.mkdir_p(folder)
    folder
  end

  def self.inventory_base_url
    ForemanRhCloud.base_url + "/api/inventory/v1/hosts"
  end

  def self.inventory_export_url
    tags = URI.encode("satellite/satellite_instance_id=#{Foreman.instance_id}")
    inventory_base_url + "?tags=#{tags}"
  end

  def self.inventory_self_url
    inventory_base_url + "?hostname_or_id=#{ForemanRhCloud.foreman_host.fqdn}"
  end
end
