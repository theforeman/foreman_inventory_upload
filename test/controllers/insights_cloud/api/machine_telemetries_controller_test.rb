require 'test_plugin_helper'

module InsightsCloud::Api
  class MachineTelemetriesControllerTest < ActionController::TestCase
    context '#forward_request' do
      setup do
        @body = 'Cloud response body'
        @http_req = RestClient::Request.new(:method => 'GET', :url => 'http://test.theforeman.org')

        org = FactoryBot.create(:organization)
        host = FactoryBot.create(:host, :with_subscription, :organization => org)
        User.current = ::Katello::CpConsumerUser.new(:uuid => host.subscription_facet.uuid, :login => host.subscription_facet.uuid)
        InsightsCloud::Api::MachineTelemetriesController.any_instance.stubs(:upstream_owner).returns({ 'uuid' => 'abcdefg' })

        @cert1 = "-----BEGIN CERTIFICATE-----\r\n" +
        "MIIFdDCCA1ygAwIBAgIJAM5Uqykb3EAtMA0GCSqGSIb3DQEBCwUAME8xCzAJBgNV\r\n" +
        "BAYTAklMMREwDwYDVQQIDAhUZWwgQXZpdjEUMBIGA1UECgwLVGhlIEZvcmVtYW4x\r\n" +
        "FzAVBgNVBAMMDnRoZWZvcmVtYW4ub3JnMB4XDTE4MDMyNDEyMzYyOFoXDTI4MDMy\r\n" +
        "MTEyMzYyOFowTzELMAkGA1UEBhMCSUwxETAPBgNVBAgMCFRlbCBBdml2MRQwEgYD\r\n" +
        "VQQKDAtUaGUgRm9yZW1hbjEXMBUGA1UEAwwOdGhlZm9yZW1hbi5vcmcwggIiMA0G\r\n" +
        "CSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDF04/s4h+BgHPG1HDZ/sDlYq925pkc\r\n" +
        "RTVAfnE2EXDAmZ6W4Q9ueDY65MHe3ZWO5Dg72kNSP2sK9kRI7Dk5CAFOgyw1rH8t\r\n" +
        "Hd1+0xp/lv6e4SvSYghxIL68vFe0ftKkm1usqejBM5ZTgKr7JCI+XSIN36F65Kde\r\n" +
        "c+vxwBnayuhP04r9/aaE/709SXML4eRVYW8I3qFy9FPtUOm+bY8U2PIv5fHayqbG\r\n" +
        "cL/4t3+MCtMhHJsLzdBXya+1P5t+HcKjUNlmwoUF961YAktVuEFloGd0RMRlqF3/\r\n" +
        "itU3QNlXgA5QBIciE5VPr/PiqgMC3zgd5avjF4OribZ+N9AATLiQMW78il5wSfcc\r\n" +
        "kQjU9ChOLrzku455vQ8KE4bc0qvpCWGfUah6MvL9JB+TQkRl/8kxl0b9ZinIvJDH\r\n" +
        "ynVMb4cB/TDEjrjOfzn9mWLH0ZJqjmc2bER/G12WQxOaYLxdVwRStD3Yh6PtiFWu\r\n" +
        "sXOk19UOTVkeuvGFVtvzLfEwQ1lDEo7+VBQz8FG/HBu2Hpq3IwCFrHuicikwjQJk\r\n" +
        "nfturgD0rBOKEc1qWNZRCvovYOLL6ihvv5Orujsx5ZCHOAtnVNxkvIlFt2RS45LF\r\n" +
        "MtPJyhAc6SjitllfUEirxprsbmeSZqrIfzcGaEhgOSnyik1WMv6bYiqPfBg8Fzjh\r\n" +
        "vOCbtiDNPmvgOwIDAQABo1MwUTAdBgNVHQ4EFgQUtkAgQopsTtG9zSG3MgW2IxHD\r\n" +
        "MDwwHwYDVR0jBBgwFoAUtkAgQopsTtG9zSG3MgW2IxHDMDwwDwYDVR0TAQH/BAUw\r\n" +
        "AwEB/zANBgkqhkiG9w0BAQsFAAOCAgEAJq7iN+ZroRBweNhvUobxs75bLIV6tNn1\r\n" +
        "MdNHDRA+hezwf+gxHZhFyaAHfTpst2/9leK5Qe5Zd6gZLr3E5/8ppQuRod72H39B\r\n" +
        "vxMlG5zxDss0WMo3vZeKZbTY6QhXi/lY2IZ6OGV4feSvCsYxn27GTjjrRUSLFeHH\r\n" +
        "JVemCwCDMavaE3+OIY4v2P4FcG+MjUvfOB9ahI24TWL7YgrsNVmJjCILq+EeUj0t\r\n" +
        "Gde1SXVyLkqt7PoxHRJAE0BCEMJSnjxaVB329acJgeehBUxjj4CCPqtDxtbz9HEH\r\n" +
        "mOKfNdaKpFor+DUeEKUWVGnr9U9xOaC+Ws+oX7MIEUCDM7p2ob4JwcjnFs1jZgHh\r\n" +
        "Hwig+i7doTlc701PvKWO96fuNHK3B3/jTb1fVvSZ49O/RvY1VWODdUdxWmXGHNh3\r\n" +
        "LoR8tSPEb46lC2DXGaIQumqQt8PnBG+vL1qkQa1SGTV7dJ8TTbxbv0S+sS+igkk9\r\n" +
        "zsIEK8Ea3Ep935cXximz0faAAKHSA+It+xHLAyDtqy2KaAEBgGsBuuWlUfK6TaP3\r\n" +
        "Gwdjct3y4yYUO45lUsUfHqX8vk/4ttW5zYeDiW+HArJz+9VUXNbEdury4kGuHgBj\r\n" +
        "xHD4Bsul65+hHZ9QywKU26F1A6TLkYpQ2rk/Dx9LGICM4m4IlHjWJPFsQdtkyOor\r\n" +
        "osxMtcaZZ1E=\r\n" +
        "-----END CERTIFICATE-----"
      end

      test "should respond with response from cloud" do
        net_http_resp = Net::HTTPResponse.new(1.0, 200, "OK")
        net_http_resp.add_field 'Set-Cookie', 'Monster'
        res = RestClient::Response.create(@body, net_http_resp, @http_req)
        ::ForemanRhCloud::CloudRequestForwarder.any_instance.stubs(:forward_request).returns(res)

        get :forward_request, params: { "path" => "platform/module-update-router/v1/channel" }
        assert_equal @body, @response.body
      end

      test "should respond with the same content type" do
        net_http_resp = Net::HTTPResponse.new(1.0, 200, "OK")
        net_http_resp.add_field 'Set-Cookie', 'Monster'
        res = RestClient::Response.create(@body, net_http_resp, @http_req)
        ::ForemanRhCloud::CloudRequestForwarder.any_instance.expects(:execute_cloud_request).with do |opts|
          opts[:headers][:content_type] == 'application/json'
        end.returns(res)
        InsightsCloud::Api::MachineTelemetriesController.any_instance.expects(:candlepin_id_cert)
          .returns(
            {
              cert: @cert1,
              key: OpenSSL::PKey::RSA.new(1024).to_pem,
            }
          )
        InsightsCloud::Api::MachineTelemetriesController.any_instance.expects(:cp_owner_id).returns('123')

        post :forward_request, as: :json, params: { "path" => "static/v1/test", "machine_telemetry" => {"foo" => "bar"} }
        assert_equal @body, @response.body
      end

      test "should add headers to response from cloud" do
        x_resource_count = '101'
        x_rh_insights_request_id = '202'
        net_http_resp = Net::HTTPResponse.new(1.0, 200, "OK")
        net_http_resp['x_resource_count'] = x_resource_count
        net_http_resp['x_rh_insights_request_id'] = x_rh_insights_request_id
        res = RestClient::Response.create(@body, net_http_resp, @http_req)
        ::ForemanRhCloud::CloudRequestForwarder.any_instance.stubs(:forward_request).returns(res)

        get :forward_request, params: { "path" => "platform/module-update-router/v1/channel" }
        assert_equal x_resource_count, @response.headers['x-resource-count']
        assert_equal x_rh_insights_request_id, @response.headers['x_rh_insights_request_id']
      end

      test "should handle failed authentication to cloud" do
        net_http_resp = Net::HTTPResponse.new(1.0, 401, "Unauthorized")
        res = RestClient::Response.create(@body, net_http_resp, @http_req)
        ::ForemanRhCloud::CloudRequestForwarder.any_instance.stubs(:forward_request).returns(res)

        get :forward_request, params: { "path" => "platform/module-update-router/v1/channel" }
        assert_equal 502, @response.status
        assert_equal 'Authentication to the Insights Service failed.', JSON.parse(@response.body)['message']
      end
    end

    context '#branch_info' do
      setup do
        User.current = User.find_by(login: 'secret_admin')

        @env = FactoryBot.create(:katello_k_t_environment)
        cv = @env.content_views << FactoryBot.create(:katello_content_view, organization: @env.organization)

        @host = FactoryBot.create(
          :host,
          :with_subscription,
          :with_content,
          :with_hostgroup,
          :with_parameter,
          content_view: cv.first,
          lifecycle_environment: @env,
          organization: @env.organization
        )

        @host.subscription_facet.pools << FactoryBot.create(:katello_pool, account_number: '5678', cp_id: 1)

        uuid = @host.subscription_facet.uuid

        @user = ::Katello::CpConsumerUser.new({ :uuid => uuid, :login => uuid })

        @controller.stub(:set_client_user, @user) do
          User.current = @user
        end

        @controller.stubs(:cp_owner_id).returns('test-branch-id')
      end

      test 'should get branch info' do
        get :branch_info

        assert_response :success
      end

      test 'should handle missing organization' do
        Host::Managed.any_instance.stubs(:organization).returns(nil)
        get :branch_info

        res = JSON.parse(@response.body)
        assert_equal "Organization not found or invalid", res['message']
        assert_response 400
      end

      test 'should handle missing branch id' do
        @controller.stubs(:cp_owner_id).returns(nil)
        get :branch_info

        res = JSON.parse(@response.body)
        assert_equal "Branch ID not found for organization #{@host.organization.title}", res['message']
        assert_response 400
      end
    end
  end
end
