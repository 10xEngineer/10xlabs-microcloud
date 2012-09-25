require 'pathname'
require 'facets'

module TenxLabs  
  module Definition
    class Metadata
      include TenxLabs::Mixin::ObjectTransform
      include TenxLabs::Mixin::FromFile

      RESOURCE_TYPES = [:compute, :storage, :network]

      attr_reader 
        :maintainer, 
        :maintainer_email, 
        :handler, 
        :version, 
        :description, 
        :revision, 
        :resources,
        :vms_path,
        :cookbooks_path,
        :roles_path,
        :data_bags_path

      # FIXME provide chef style set_or_return with validations (chef/mixin/params_validate.rb)
      # FIXME DRY way how to define attributes/assign/evaluate
      # FIXME revision must not be specified in metadata directly

      def initialize(handler_name = "TenxLabs::Handlers::Chef", revision = nil)
        @maintainer = nil
        @maintainer_email = nil
        @version = nil
        @description = nil
        @revision = revision

        self.use(handler_name)

        @vms = []
        @components = []
        @resources = {}

        # TODO how to resolve internal lab structure?
        #      original code used metadata_rb's base_dir to deduce the location
        @vms_path = "vms"
        @cookbooks_path = "cookbooks"
        @roles_path = "roles"
        @data_bags_path = "data_bag"
      end

      def use(handler_name)
        @handler_name = handler_name
        @handler = (eval handler_name).new
      rescue NameError => e
        raise TenxLabs::Errors::InvalidHandler
      end

      def maintainer(maintainer)
        @maintainer = maintainer
      end

      def maintainer_email(email)
        @maintainer_email = email
      end

      def version(ver)
        @version = ver
      end    

      def description(desc)
        @description = desc
      end

      def resource_pool(klass, name, options = {})
        raise "Invalid resource pool type '#{klass}'" unless RESOURCE_TYPES.include? klass

        @resources[klass] = {
          :name => name,
          :options => options
        }
      end

      def to_obj
        {
          :__type__ => self.class.to_s.underscore,
          :version => @version,
          :revision => @revision,
          :maintainer => @maintainer,
          :maintainer_email => @maintainer_email,
          :handler => @handler,
          :resources => @resources,
          :description => @description,
        }
      end
    end
  end
end