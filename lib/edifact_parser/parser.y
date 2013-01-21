class EdifactParser::Parser
token QUALIFIER STRING NUMBER OPTIONAL_BEGIN
rule
  document
    : segments
    | beginning segments
    ;
  beginning
    : OPTIONAL_BEGIN
    ;
  segment
    : qual elements
    ;
  segments
    : segments segment
    | segment
    ;
  elements
    : elements element
    | element
    ;
  element
    : plus components
    | plus components segment_end
    | plus
    ;
  components
    : components component
    | component
    ;
  component
    : scalar colon
    | colon scalar
    | scalar
    ;
  qual
    : QUALIFIER
    { @handler.start_segment; @handler.qualifier val[0] }
    ;
  scalar
    : string
    | number
    ;
  number
    : NUMBER
    { @handler.scalar val[0] }
    ;
  string
    : STRING
    { @handler.scalar val[0] }
    ;
  plus
    : '+'
    { @handler.end_element; @handler.start_element }
    ;
  colon
    : ':'
    ;
  starter
    : plus
    | colon
    ;
  segment_end
    : '\''
    { @handler.end_element; @handler.end_segment }
    ;
end

---- inner

  require_relative 'handler'

  attr_reader :handler

  def initialize(tokenizer, handler = Handler.new)
    @tokenizer = tokenizer
    @handler   = handler
    super()
  end

  def next_token
    @tokenizer.next_token
  end

  def parse
    do_parse
    handler
  end