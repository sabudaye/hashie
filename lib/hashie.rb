require "hashie/version"

module Hashie
  # Your code goes here...
  class Mash < Hash
    def initialize
      
    end

    def method_missing(full_method, *args, &block)
      full_method = full_method.to_s
      case full_method[-1]
        when "=" 
          self[full_method[0..-2]] = args.first
        when "?" 
          self.has_key?(full_method[0..-2])
        when "!" 
          self[full_method[0..-2]] = self.class.new
        else 
          self.has_key?(full_method) ? self[full_method] : nil
      end
    end
  end
end