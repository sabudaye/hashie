require "hashie/version"

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

  class Dash
    SETTINGS_ARRAY = [ :default, :required ]

    @@property = Hash.new
    @@settings = Hash.new

    def initialize(init_hash = {})
        @hash = Hash.new
        init_hash.each do |k,v|
         if @@property.has_key?(k)
           @hash[k] = v
         else
           "raise(NoMethodError)"
         end
        self.check_settings
      end
    end

    def check_settings
      @@settings.each do |s_key, s_val|
        s_val.each do |prop_key, prop_val|
          case prop_key
          when :required
            if @hash[s_key].nil?
              @hash = {}
              raise ArgumentError
            end
          else
            true
          end
        end
      end
    end

    def self.property(prop_name, settings = {})
      @@property[prop_name] =  ""
      @@settings[prop_name] = settings
    end

    def method_missing(full_method, *args)
      full_method = full_method.to_s
      clean_name = full_method[0..-2]

      case full_method[-1]
      when "="
        define_singleton_method(full_method.to_sym) { |*args| @hash[clean_name.to_sym] = args.first; self.check_settings }
        send(full_method, *args)
      else
        @hash.has_key?(full_method.to_sym) ? @hash[full_method.to_sym] : "aa"
      end
    end
  end
end