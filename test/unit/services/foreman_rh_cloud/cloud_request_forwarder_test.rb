require 'test_plugin_helper'
require 'puma/null_io'

class CloudRequestForwarderTest < ActiveSupport::TestCase
  setup do
    @forwarder = ::ForemanRhCloud::CloudRequestForwarder.new

    @cert1 = "-----BEGIN CERTIFICATE-----\r\n" +
      "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\r\n" +
      "osxMtcaZZ1E=\r\n" +
      "-----END CERTIFICATE-----"
  end

  test 'should prepare correct cloud url' do
    paths = {
      "/redhat_access/r/insights/platform/module-update-router/v1/channel?module=insights-core" => "https://cert.cloud.redhat.com/api/module-update-router/v1/channel?module=insights-core",
      "/redhat_access/r/insights/v1/static/release/insights-core.egg" => "https://cert-api.access.redhat.com/r/insights/v1/static/release/insights-core.egg",
      "/redhat_access/r/insights/v1/static/uploader.v2.json" => "https://cert-api.access.redhat.com/r/insights/v1/static/uploader.v2.json",
      "/redhat_access/r/insights/v1/static/uploader.v2.json.asc" => "https://cert-api.access.redhat.com/r/insights/v1/static/uploader.v2.json.asc",
      "/redhat_access/r/insights/platform/inventory/v1/hosts" => "https://cert.cloud.redhat.com/api/inventory/v1/hosts",
      "/redhat_access/r/insights/platform/ingress/v1/upload" => "https://cert.cloud.redhat.com/api/ingress/v1/upload",
      "/redhat_access/r/insights/uploads/67200803-132b-474b-a6f9-37be74185df4" => "https://cert-api.access.redhat.com/r/insights/uploads/67200803-132b-474b-a6f9-37be74185df4",
    }

    paths.each do |key, value|
      actual_params = @forwarder.path_params(key, { cert: @cert1, key: OpenSSL::PKey::RSA.new(1024).to_pem })
      assert_equal value, actual_params[:url]
    end
  end

  test 'should forward payload from request parameters' do
    params = { 'pumpkin' => 'pie' }
    req = ActionDispatch::Request.new(
      'REQUEST_URI' => '/foo/bar',
      'REQUEST_METHOD' => 'GET',
      'rack.input' => ::Puma::NullIO.new,
      "action_dispatch.request.request_parameters" => { 'vegetables' => params }
    )
    assert_equal params, @forwarder.prepare_forward_payload(req, 'vegetables')
  end

  test 'should forward post payload' do
    post_data = 'Random POST data'
    req = ActionDispatch::Request.new(
      'REQUEST_URI' => '/foo/bar?baz=awesome',
      'REQUEST_METHOD' => 'POST',
      'rack.input' => ::Puma::NullIO.new,
      'RAW_POST_DATA' => post_data
    )
    assert_equal post_data, @forwarder.prepare_forward_payload(req, '')
  end

  test 'should forward put payload' do
    put_data = 'Random PUT data'
    req = ActionDispatch::Request.new(
      'REQUEST_URI' => '/foo/bar?baz=awesome',
      'REQUEST_METHOD' => 'PUT',
      'rack.input' => ::Puma::NullIO.new,
      'RAW_POST_DATA' => put_data
    )

    assert_equal put_data, @forwarder.prepare_forward_payload(req, '')
  end

  test 'should forward patch payload' do
    params = { 'pumpkin' => 'pie' }
    req = ActionDispatch::Request.new(
      'REQUEST_URI' => '/foo/bar?baz=awesome',
      'REQUEST_METHOD' => 'PATCH',
      'rack.input' => ::Puma::NullIO.new,
      'RAW_POST_DATA' => 'Random PATCH data',
      "action_dispatch.request.path_parameters" => { :format => "json" },
      "action_dispatch.request.request_parameters" => { 'vegetables' => params }
    )
    assert_equal params.to_json, @forwarder.prepare_forward_payload(req, 'vegetables')
  end

  test 'should forward file with metadata' do
    file_params = { :file => 'Test file', :metadata => 'File metadata' }
    req = ActionDispatch::Request.new(
      'REQUEST_URI' => '/foo/bar?baz=awesome',
      'REQUEST_METHOD' => 'POST',
      'rack.input' => ::Puma::NullIO.new,
      "action_dispatch.request.request_parameters" => file_params.merge(:foo => 'bar')
    )
    assert_equal file_params, @forwarder.prepare_forward_payload(req, '')
  end

  test 'should prepare params to forward' do
    params = { :page => 5, :per_page => 42 }
    req = ActionDispatch::Request.new(
      'REQUEST_URI' => '/foo/bar',
      'REQUEST_METHOD' => 'GET',
      'rack.input' => ::Puma::NullIO.new,
      "action_dispatch.request.query_parameters" => params
    )
    assert_equal params, @forwarder.prepare_forward_params(req, nil)
  end

  test 'should add branch id into forwarded params' do
    user_agent = { :foo => :bar }
    params = { :page => 5, :per_page => 42 }

    req = ActionDispatch::Request.new(
      'REQUEST_URI' => '/foo/bar',
      'REQUEST_METHOD' => 'GET',
      'HTTP_USER_AGENT' => user_agent,
      'rack.input' => ::Puma::NullIO.new,
      'action_dispatch.request.query_parameters' => params
    )
    assert_equal params.merge(:branch_id => 74), @forwarder.prepare_forward_params(req, 74)
  end
end
