require "hashie/version"

module Hashie
  class Mash < Hash

    def method_missing(full_method, *args)
      full_method = full_method.to_s
      case full_method[-1]
      when "=" 
        define_singleton_method(full_method) do |*args|
          self[full_method[0..-2]] = args.first
        end
        send(full_method, *args)
      when "?" 
        define_singleton_method(full_method) do
          self.has_key?(full_method[0..-2])
        end
        send(full_method)
      when "!" 
        define_singleton_method(full_method) do
          self[full_method[0..-2]] = self.class.new
        end
        send(full_method)
      else 
        define_singleton_method(full_method) do
          self.has_key?(full_method) ? self[full_method] : nil
        end
        send(full_method)
      end
    end
  end

  class Dash
    
    def self.property(prop_name, settings = {})
      puts settings unless settings.empty?
    end

    def initialize(hash = {})
      hash.each do |key, value|
        self[key] = value
      end
    end
  end
end