require 'facets'

# TODO VM should be based on common AbstractComponent class which provides
#      shared logic (like depends_on)

module TenxLabs  
  module Definition
    class Vm
      include TenxLabs::Mixin::ObjectTransform
      include TenxLabs::Mixin::FromFile

      attr_reader :name, :run_list, :hostname, :base_image

      def initialize(name = nil)
        @name = name
        @file = nil

        @base_image = nil
        @hostname = nil
        @run_list = []

        @dependencies = []
      end

      def base_image(image)
        @base_image = image
      end

      def hostname(hostname)
        @hostname = hostname
      end

      def run_list(list)
        @run_list = list
      end

      def depends_on(component, name)
        @dependencies << {
          :component => component,
          :name => name
        }
      end

      def process(&block)
        instance_eval &block
      end

      def to_obj
        {
          :__type__ => self.class.to_s.underscore,
          :name => @name,
          :vm_type => @base_image,
          :hostname => @hostname,
          :run_list => @run_list,
          :dependencies => @dependencies
        }
      end
    end
  end
end