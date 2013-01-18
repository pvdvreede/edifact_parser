module EdifactParser
  class Handler
    attr_reader :stack

    def initialize
      @stack = [[:root]]
    end

    def start_segment
      push [:hash]
    end

    def start_element
      push [:array]
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
    alias :end_element :end_segment
    alias :end_component :end_segment

    def qualifier(q)
      @stack.last << [:qualifier, q]
    end

    def result
      @stack
    end

    private

      def push(o)
        @stack.last << o
        @stack << o
      end

  end
end