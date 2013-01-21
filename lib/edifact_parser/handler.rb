module EdifactParser
  class Handler
    attr_reader :stack

    def initialize
      @stack = [[:root]]
      @element_started = false
    end

    def start_segment
      push [:hash]
    end

    def start_element
      push [:array]
      @element_started = true
    end

    def start_component
      push [:array]
    end

    def scalar(s)
      @stack.last << [:scalar, s]
    end

    def end_segment
      @stack.pop
    end
    alias :end_component :end_segment

    def end_element
      if @element_started
        @stack.pop
      end
    end

    def qualifier(q)
      @stack.last << [:scalar, q]
      push [:array]
    end

    def result
      @stack
      root = @stack.first.last
      process root.first, root.drop(1)

    end

    private

      def process(type, rest)
        case type
        when :array
          rest.map { |x| process(x.first, x.drop(1)) }
        when :hash
          Hash[rest.map { |x|
            process(x.first, x.drop(1))
          }.each_slice(2).to_a]
        when :scalar
          rest.first
        end
      end

      def push(o)
        @stack.last << o
        @stack << o
      end

  end
end