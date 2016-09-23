module Capybara
  module MultiServer
    def self.configuration
      @configuration ||= Configuration.new
    end
  
    def self.configure
      Capybara.run_server = false
      yield configuration if block_given?
    end
    
    def self.boot
      configuration.servers.each do |name, server_spec|
        server = server_spec[:booter].call
        server_spec[:instance] = server
      end
      
      if configuration.default_server
        server = configuration.servers[configuration.default_server][:instance]
        Capybara.app_host = "http://#{server.host}:#{server.port}"
      end
    end
    
    class Configuration
      def initialize
        @servers = {}
      end
      
      attr_reader :servers
      
      def server(name, &block)
        servers[name] = {booter: block}
        
        Helpers.module_eval do
          define_method "#{name}_host" do
            server = Capybara::MultiServer.configuration.servers[name][:instance]
            "http://#{server.host}:#{server.port}"
          end
        end
      end
      
      def capybara_server(name)
        server(name) do
          Capybara::Server.new(Capybara.app).tap do |capybara_server|
            capybara_server.boot
          end
        end
      end
      
      attr_accessor :default_server
    end
    
    module Helpers extend ActiveSupport::Concern
      extend self
      
      class_methods do
        def default_server(name)
          before(:all) do
            @old_app_host = Capybara.app_host
            Capybara.app_host = send("#{name}_host")
          end
          
          after(:all) do
            Capybara.app_host = @old_app_host
          end
        end
      end
    end
  end
end
