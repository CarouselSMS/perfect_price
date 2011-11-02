module PerfectPrice
  module Configurable # :nodoc:

    # Lets you define options and maps (lists) of options in any class.
    #
    #     class Feature
    #       include PerfectPrice::Configurable
    #       option :option1
    #       option :option2
    #     end
    #
    #     class Plan
    #       include PerfectPrice::Configurable
    #       option :name
    #       option :feature, :many => true, :class => Feature
    #     end
    #
    # This will give you:
    #
    #     plan.name('new name')
    #     plan.name                 # => 'new name'
    #
    #     # Define options either inline or in the block
    #     plan.feature :mo, :option1 => 1 do
    #       option2 0.05
    #     end
    #
    #     plan.feature(:mo).option1  # => 1
    #     plan.features              # => { :mo => Feature }
    #
    module ClassMethods
      
      # Defines an option.
      #
      # Options are:
      #
      # * <tt>:many</tt> - If set to <tt>true</tt>, the option will allow multiple named
      #   instances. Each instance will be placed in the Map instance variable with the
      #   name prefixed with 's' (feature -> features).
      #
      # * <tt>:class</tt> - Specifies the name of the class to use for instantiating
      #   child options.
      #
      # * <tt>:copy</tt> - When <tt>:many</tt> is set, this option specifies which options
      #   to copy to a newly created child option.
      #
      # Option examples:
      #
      #   option :name
      #   option :feature, :many => true, :class => Feature
      #   option :plan, :many => true, :class => Plan, :copy => :features
      #
      def option(opt, options = {})
        if !options[:many]
          self.class_eval "
            def #{opt}(*a)
              @#{opt} = a.first unless a.empty?
              @#{opt}
            end
          "
        else
          raise "Need :class option to know the class of each item" unless options[:class]
          copied_options = options[:copy] && [ options[:copy] ].flatten
          copying = copied_options ? "%w{ #{copied_options.join(' ')} }.each { |o| item.send('' + o + '=', send(o)) }" : ''
          self.class_eval "
            def #{opt}s
              @#{opt}s = {} unless @#{opt}s
              @#{opt}s
            end
            
            def #{opt}s=(v)
              @#{opt}s = v
            end
        
            def has_#{opt}?(name)
              @#{opt}s && @#{opt}s.has_key?(name.to_sym)
            end
            
            def #{opt}(name, options = {}, &block)
              name = name.to_sym

              @#{opt}s = {} unless @#{opt}s
              item = @#{opt}s[name]
              if !item
                item = #{options[:class]}.new
                item.name(name) if item.respond_to?(:name)
                #{copying}
                @#{opt}s[name] = item
              end

              options.each { |k, v| item.send(k, v) } if options.any?
    
              item.instance_eval(&block) if block
    
              item
            end
          "
        end
      end
    end
  
    def self.included(receiver)
      receiver.extend ClassMethods
    end
  end
end