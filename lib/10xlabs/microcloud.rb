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
      get_ext resource_path(resource, resource_id)
    end

    def get_ext(path)
      # TODO error handling (404s, 401s)
      response = perform_request(
                    :get,
                    path,
                    {})

      unless response.response.kind_of? Net::HTTPOK
        raise response.parsed_response
      end

      response.parsed_response
    end

    def post(resource, resource_id, data, options = {})
      post_ext resource_path(resource, resource_id), data, options
    end

    def post_ext(path, data, options = {})
      # TODO error handling (404s, 401s)

      # TODO explicitly convert data to JSON
      options[:body] = Yajl::Encoder.encode(data)
      # TODO why doesn't options[:format] set correct content type?
      options[:headers] = {'content-type' => 'application/json'}
      response = perform_request(
                    :post,
                    path,
                    options)

      unless response.response.kind_of? Net::HTTPOK
        raise response.parsed_response
      end

      response.parsed_response
    end

    # TODO decomission (replace with generic action/update API)
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

  public

    def perform_request(method, path, options)
      self.class.send(method.to_s, path, options)
    end

    def nested_resources_paths(resources)
      output = ""

      resources.each do |res|
        output << self.resource_path(*res)
      end

      output
    end

    def resource_path(resource, resource_id = nil, append = nil)
      path = "/#{resource.to_s.pluralize}"
      path << "/#{resource_id}" if resource_id
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


