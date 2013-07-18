require "hashie/version"

module Hashie
  # Your code goes here...
  class Mash < Hash
    def initialize
      
    end

    def method_missing(full_method, *args, &block)
      case full_method.to_s[-1]
        when "=" 
          self[full_method[0..-2].to_s] = args.first
        when "?" 
          self.has_key?(full_method[0..-2].to_s)
        when "!" 
          self.has_key?(full_method.to_s[0..-2]) ? self[full_method.to_s[0..-2]] : nil
        else 
          self.has_key?(full_method.to_s) ? self[full_method.to_s] : nil
      end
    end
  end
end