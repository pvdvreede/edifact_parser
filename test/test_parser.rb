require 'minitest/autorun'
require_relative '../lib/edifact_parser'

module EdifactParser
  class TestParser < MiniTest::Unit::TestCase
    FILES_DIR = File.dirname(__FILE__) + "\\files"

    def test_separate_lines_file
      r = EdifactParser::load_io open("#{FILES_DIR}\\separate_lines.edi")
      assert_equal([], r)
    end

    def test_segment
      parser = new_parser("UNB+UNOA:3+22234114345363:ZZ+55643345334:ZZ+130109:1412+61236'")
      r = parser.parse.result
      assert_equal(
        {"UNB" => [
          [
            "UNOA",
            3
          ],
          [
            22234114345363,
            "ZZ"
          ],
          [
            55643345334,
            "ZZ"
          ],
          [
            130109,
            1412
          ],
          [
            61236
          ]
        ]},
        r
      )
    end

    def test_segment_with_UNA
      parser = new_parser("UNA:+.? 'UNB+UNOA:3+22234114345363:ZZ+55643345334:ZZ+130109:1412+61236'")
      r = parser.parse.result
      assert_equal(
        {"UNB" => [
          [
            "UNOA",
            3
          ],
          [
            22234114345363,
            "ZZ"
          ],
          [
            55643345334,
            "ZZ"
          ],
          [
            130109,
            1412
          ],
          [
            61236
          ]
        ]},
        r
      )
    end

    def test_segment_with_no_colons
      parser = new_parser("UNA:+.? 'UNB+UNOA:3+22234114345363ZZ+55643345334:ZZ+130109:1412+61236'")
      r = parser.parse.result
      assert_equal(
        {"UNB" => [
          [
            "UNOA",
            3
          ],
          [
            "22234114345363ZZ"
          ],
          [
            55643345334,
            "ZZ"
          ],
          [
            130109,
            1412
          ],
          [
            61236
          ]
        ]},
        r
      )
    end

    def test_segment_blank_values
      parser = new_parser("UNB+UNOA:3+22234114345363:ZZ+55643345334:ZZ++61236'")
      r = parser.parse.result
      assert_equal(
        {"UNB" => [
          [
            "UNOA",
            3
          ],
          [
            22234114345363,
            "ZZ"
          ],
          [
            55643345334,
            "ZZ"
          ],
          [

          ],
          [
            61236
          ]
        ]},
        r
      )
    end

    def new_parser(string)
      tok = Tokenizer.new StringIO.new(string)
      Parser.new tok
    end
  end
end