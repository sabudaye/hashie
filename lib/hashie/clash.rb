module Hashie
  class Clash < Hash
    def method_missing(full_method, *args)
      full_method = full_method.to_s
      clean_name = full_method[0..-2]
      @stack_hash ||= {}
      if full_method == "_end!"
        self[@stack_hash[:key]] = @stack_hash[:stack]
        @stack_hash = {}
        self
      elsif full_method[-1] == "!" 
        @stack_hash[:key] = clean_name.to_sym
        self
      else
        if @stack_hash[:key].nil? 
          define_singleton_method(full_method) { |args| self[full_method.to_sym] = args; self }
          send(full_method, *args)
        else
          if @stack_hash[:stack].nil?
            @stack_hash.merge!({:stack => {full_method.to_sym => args.first}})
          else
            @stack_hash[:stack].merge!({full_method.to_sym => args.first})
          end
          self
        end
      end
    end
  end
end