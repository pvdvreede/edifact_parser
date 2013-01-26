require 'strscan'

module EdifactParser
  class Tokenizer
    OPTIONAL_BEGIN = /^UNA:\+\.\?\s'/
    QUALIFIER = /(^|(?<='))(UNB|UNH|BGM|DTM|PAI|ALI|IMD|FTX|LOC|GIS|DGS|GIR|RFF|MEA|QTY|MOA|RTE|NAD|DOC|CTA|COM|TAX|PCD|CUX|TDT|TSR|PII|TOD|PAC|EQD|SEL|ALC|RNG|INP|LIN|PRI|UNS|UNT|UNZ|CNT)/
    STRING = /[A-Za-z0-9\s\.]*(\?')*[A-Za-z0-9\s\.]*(\?\+)*[A-Za-z0-9\s\.]*(\?:)*[A-Za-z0-9\s\.]*/
    SPACE = /\s+/
    NUMBER = /[0-9]+(?=[\+:'])/
    LINE_BREAK = /\n/
    SEGMENT_END = /(?<!\?)'/
    PLUS = /(?<!\?)\+/
    COLON = /(?<!\?)\:/

    def initialize(io)
      @ss = StringScanner.new io.read
    end

    def next_token
      return if @ss.eos?

      # ignore spaces and line breaks
      @ss.scan(SPACE)
      @ss.scan(LINE_BREAK)

      return if @ss.eos?

      case
      when text = @ss.scan(OPTIONAL_BEGIN) then [:OPTIONAL_BEGIN, text]
      when text = @ss.scan(QUALIFIER) then [:QUALIFIER, text]
      when text = @ss.scan(SEGMENT_END) then [:SEGMENT_END, text]
      when text = @ss.scan(PLUS) then [:PLUS, text]
      when text = @ss.scan(COLON) then [:COLON, text]
      when text = @ss.scan(NUMBER) then [:NUMBER, text.to_i]
      when text = @ss.scan(STRING) then [:STRING, text]
      else
        x = @ss.getch
        [x, x]
      end
    end
  end
end