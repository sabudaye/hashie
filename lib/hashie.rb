require "hashie/version"

module Hashie
  # Your code goes here...
  class Mash < Hash
    def initialize
      
    end

    def method_missing(method_name, *args, &block)
      parse = method_name.to_s.match(/(.*?)([?=!_]?)$/)
      case parse[2]
      when "="
        self[parse[1]] = args.first
      else
        if self.has_key?(parse[1])
          self[parse[1]]
        else
          nil
        end
      end
    end
  end
end