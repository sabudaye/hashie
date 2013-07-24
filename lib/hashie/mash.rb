module Hashie
  class Mash < Hash
    def method_missing(full_method, *args)
      full_method = full_method.to_s
      clean_name = full_method[0..-2]
      case full_method[-1]
      when "=" 
        define_singleton_method(full_method) { |*args| self[clean_name] = args.first }
      when "?" 
        define_singleton_method(full_method) { self.has_key?(clean_name) }
      when "!" 
        define_singleton_method(full_method) { self[clean_name] = self.class.new }
      else 
        define_singleton_method(full_method) { self.has_key?(full_method) ? self[full_method] : nil }
      end
      send(full_method, *args)
    end
  end
end