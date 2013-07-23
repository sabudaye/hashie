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
    class << self
      attr_reader :prop, :set
      def property(prop_name, settings = {})
         @prop ||= Hash.new
         @set ||= Hash.new
         @prop[prop_name] =  ""
         @set[prop_name] = settings
      end 
    end

    def initialize(init_hash = {})
      @hash = Hash.new
      @property = self.class.prop
      @settings = self.class.set
      init_hash.each do |k,v|
        if @property.has_key?(k)
          self.check_settings(k,v)
          @hash[k] = v
        else
          raise NoMethodError
        end
      end
      check_settings
    end

    def check_settings(method = nil, arg = "")
      @sett_check = lambda do |sett_hash, method_name|
          sett_hash.each do |prop_key, prop_val|
              case prop_key
              when :required
                if prop_val && arg.nil?
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
        @settings.each do |s_key, s_val|
          @sett_check.call(s_val, s_key)
        end
      else
        @sett_check.call(@settings[method], method)
      end
    end

    def [](*args)
      @hash.has_key?(args.first.to_sym) ? @hash[args.first.to_sym] : begin raise NoMethodError end
    end

    def []=(*args)
      @hash[args.first.to_sym] = args.last
    end

    def method_missing(full_method, *args)
      full_method = full_method.to_s
      clean_name = full_method[0..-2].to_sym

      case full_method[-1]
      when "="
        if  @property.has_key?(clean_name)
          define_singleton_method(full_method.to_sym) { |*args| ; self.check_settings(clean_name, args.first) ; @hash[clean_name] = args.first }
          send(full_method, *args)
        else
          raise NoMethodError
        end          
      else
        @hash.has_key?(full_method.to_sym) ? @hash[full_method.to_sym] : begin raise NoMethodError, "#{full_method} #{args}" end
      end
    end
  end

  class Trash
    class << self
      attr_reader :prop, :set
      def property(prop_name, settings = {})
         @prop ||= Hash.new
         @set ||= Hash.new
         @prop[settings[:from]] = ""
         @set[settings[:from]] = {}
         @prop[prop_name] =  ""
         @set[prop_name] = settings
      end 

    end

    def initialize(init_hash = {})
      @hash = Hash.new
      @property = self.class.prop
      @settings = self.class.set
      init_hash.each do |k,v|
        if @property.has_key?(k)
          self.check_settings(k,v)
          @hash[k] = v
        else
          raise NoMethodError
        end
      end
      check_settings
    end

    def check_settings(method = nil, arg = "")
      @sett_check = lambda do |sett_hash, method_name|
        sett_hash.each do |prop_key, prop_val|
          case prop_key
          when :required
            if prop_val && arg.nil?
              raise ArgumentError
            end
          when :default
            @hash[method_name] = prop_val
          when :from
            @hash[method_name] = @hash[prop_val]
          else
            true
          end
        end
      end

      if method.nil?
        @settings.each do |s_key, s_val|
          @sett_check.call(s_val, s_key)
        end
      else
        @sett_check.call(@settings[method], method)
      end
    end

    def [](*args)
      @hash.has_key?(args.first.to_sym) ? @hash[args.first.to_sym] : begin raise NoMethodError end
    end

    def []=(*args)
      @hash[args.first.to_sym] = args.last
      self.set_equivalent(args.first.to_sym)
    end
    
    def method_missing(full_method, *args)
      full_method = full_method.to_s
      clean_name = full_method[0..-2].to_sym

      case full_method[-1]
      when "="
        if  @property.has_key?(clean_name)
          define_singleton_method(full_method.to_sym) { |*args| ; self.check_settings(clean_name, args.first) ; @hash[clean_name] = args.first; self.set_equivalent(clean_name) }
          send(full_method, *args)
        else
          raise NoMethodError
        end          
      else
        @hash.has_key?(full_method.to_sym) ? @hash[full_method.to_sym] : begin raise NoMethodError, "#{full_method} #{args}" end
      end
    end

    def set_equivalent(hash_key)
      @settings.each do |s_key,s_val|
        if s_val.has_key?(:from)
          hash_key == s_val[:from] ? @hash[s_key] = @hash[hash_key] : @hash[s_val[:from]] = @hash[s_key]
        end
      end
    end

  end

  class Clash < Hash
    def method_missing(full_method, *args)
      full_method = full_method.to_s
      clean_name = full_method[0..-2]
      case full_method[-1]
      when "!" 
        # define_singleton_method(full_method) { self[clean_name] = self.class.new }
      else 
        define_singleton_method(full_method) { |args| self[full_method.to_sym] = self.class.new }
      end
      send(full_method, *args)
    end
  end
end