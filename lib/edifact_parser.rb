$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'edifact_parser/parser'
require 'edifact_parser/tokenizer'
require 'stringio'

module EdifactParser

  def self.load_io(input)
    tok     = EdifactParser::Tokenizer.new input
    parser  = EdifactParser::Parser.new tok
    handler = parser.parse
    handler.result
  end

  def self.load(edi)
    load_io(StringIO.new(edi))
  end

end
