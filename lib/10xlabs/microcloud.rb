require 'active_support/inflector'
require 'httparty'
require 'yajl'
require 'uri'

module TenxLabs
  class Microcloud
    include HTTParty
    format :json

    def initialize(endpoint)
      @uri = URI.parse(endpoint)

      Microcloud.base_uri HTTParty.normalize_base_uri(@uri.to_s)
    end

    def get(resource, resource_id)
      # TODO error handling (404s, 401s)
      response = perform_request(
                    :get,
                    resource_path(resource, resource_id),
                    {})

      unless Net::HTTPOK
        raise response.parsed_response
      end

      response.parsed_response
    end

    def notify(resource, resource_id, event, data)
      body = {
        :action => event,
        resource => data
      }
      response = perform_request(
                    :post, 
                    resource_path(resource, resource_id, "notify"), 
                    :body => create_body(body))
    end

  private

    def perform_request(method, path, options)
      self.class.send(method.to_s, path, options)
    end

    def resource_path(resource, resource_id, append = nil)
      path = "/#{resource.to_s.pluralize}/#{resource_id}"
      path << "/#{append}" if append

      path
    end

    def create_body(hash)
      Yajl::Encoder.encode(hash)
    end

    # TODO create lab
    # TODO get lab status
    # TODO terminate lab
    #
    # TODO how to protect parts of API not accessible to regular users?
    #      
    # TODO providers management
    # TODO hostnode management/notifications
    # TODO pool management
  end

  end


