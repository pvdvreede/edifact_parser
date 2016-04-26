require 'minitest/autorun'
require_relative '../lib/edifact_parser'

module EdifactParser
  class TestHeaderDefinedFormat < MiniTest::Unit::TestCase
    FILES_DIR = File.dirname(__FILE__) + "/files"

    def test_header_defined_format
      r = EdifactParser::load_io open("#{FILES_DIR}/header_defined_format.edi")
      assert_equal([
        ["UNB", ["UNOA", 3.0], ["UNBE\\*NANNT", 1.0], ["DEP1", 1.0], [20051107, 1159.0], [6002.0]],
        ["UNH", ["SSDD1"], ["ORDERS", "D", "03B", "UN", "EAN008"]]
      ], r)
    end

  end
end
