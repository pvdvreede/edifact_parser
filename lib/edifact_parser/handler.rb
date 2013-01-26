module EdifactParser
  class Handler
    attr_reader :stack

    def initialize
      @stack = [[:array]]
      @element_started = false
      @empty = true
    end

    def start_segment
      push [:array]
    end

    def start_element
      push [:array]
      @element_started = true
    end

    def scalar(s)
      @stack.last << [:scalar, s]
      @empty = false
    end

    def colon
      if @empty
        @stack.last << [:nil]
      end
      @empty = true
    end

    def end_segment
      @stack.pop
    end

    def end_element
      if @element_started
        @stack.pop
        @element_started = false
      end
    end

    def qualifier(q)
      @stack.last << [:scalar, q]
    end

    def result
      root = @stack.first
      process(root.first, root.drop(1))
    end

    private

      def process(type, rest)
        case type
        when :array
          rest.map { |x| process(x.first, x.drop(1)) }
        when :scalar
          rest.first
        when :nil
          nil
        end
      end

      def push(o)
        @stack.last << o
        @stack << o
      end

  end
end