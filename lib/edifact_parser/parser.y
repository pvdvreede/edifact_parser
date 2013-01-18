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
    : qual starter values segment_end
    ;
  segments
    : segments segment
    | segment
    ;
  qual
    : QUALIFIER
    { @handler.start_segment; @handler.qualifier val[0] }
    ;
  values
    : values value
    | value
    ;
  value
    : scalar
    | plus scalar
    | colon scalar
    | scalar colon
    | scalar plus
    | plus scalar plus
    | colon scalar colon
    | colon scalar plus
    | plus scalar colon
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
    { @handler.end_segment }
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