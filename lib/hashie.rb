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
           raise NoMethodError
         end
        self.check_settings
      end
    end

    def check_settings(method = nil)
      @@sett_check = lambda do |sett_hash, method_name|
          sett_hash.each do |prop_key, prop_val|
              case prop_key
              when :required
                if prop_val && @hash[method_name].nil?
                  raise ArgumentError
                end
              when :default
                @hash[method_name] = prop_val
              else
                true
              end
          end
      end

      if method.nil?
        @@settings.each do |s_key, s_val|
          @@sett_check.call(s_val, s_key)
        end
      else
        @@sett_check.call(@@settings[method], method)
      end
    end

    def self.property(prop_name, settings = {})
      @@property[prop_name] =  ""
      @@settings[prop_name] = settings
    end

    def [](*args)
      @hash.has_key?(args.first.to_sym) ? @hash[args.first.to_sym] : begin raise NoMethodError end
    end

    def []=(*args)
      puts args
    end

    def method_missing(full_method, *args)
      full_method = full_method.to_s
      clean_name = full_method[0..-2].to_sym

      case full_method[-1]
      when "="
        if  @@property.has_key?(clean_name)
          define_singleton_method(full_method.to_sym) { |*args| @hash[clean_name] = args.first ; check_settings[clean_name] }
          send(full_method, *args)
        else
          raise NoMethodError
        end          
      else
        @hash.has_key?(full_method.to_sym) ? @hash[full_method.to_sym] : begin raise NoMethodError, "#{full_method} #{args}" end
      end
    end
  end
end