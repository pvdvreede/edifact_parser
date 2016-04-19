class EdifactParser::Parser
token QUALIFIER STRING NUMBER OPTIONAL_BEGIN SEGMENT_END PLUS COLON
rule
  document
    : segments
    | beginning segments
    ;
  beginning
    : OPTIONAL_BEGIN
    ;

  segments
    : segments segment
    | segment
    ;
  segment
    : qual values segment_end
    | qual segment_end
    ;
  values
    : values value
    | value
    ;
  value
    : p_scalar
    | c_scalar
    | plus
    | col
    ;
  qual
    : QUALIFIER
    { @handler.start_segment; @handler.qualifier val[0] }
    ;
  p_scalar
    : plus scalar
    ;
  c_scalar
    : col scalar
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
    { @handler.scalar val[0].gsub("?", "") }
    ;
  plus
    : PLUS
    { @handler.end_element; @handler.start_element }
    ;
  col
    : COLON
    { @handler.colon }
    ;
  segment_end
    : SEGMENT_END
    { @handler.end_element; @handler.end_segment }
    ;
end

---- inner

  require_relative 'handler'
  require_relative 'parse_error'

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
  rescue Racc::ParseError => e
    raise EdifactParser::ParseError.new(e.message)
  end
