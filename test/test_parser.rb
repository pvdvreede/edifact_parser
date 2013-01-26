require 'minitest/autorun'
require_relative '../lib/edifact_parser'

module EdifactParser
  class TestParser < MiniTest::Unit::TestCase
    FILES_DIR = File.dirname(__FILE__) + "/files"

    def setup
      @separate_lines_file = open("#{FILES_DIR}/separate_lines.edi")
    end

    def test_separate_lines_file
      r = EdifactParser::load_io @separate_lines_file
      assert_equal([
        ["UNB", ["UNOA", 3], ["STYLUSSTUDIO", 1], ["DATADIRECT", 1], [20051107, 1159], [6002]],
        ["UNH", ["SSDD1"], ["ORDERS", "D", "03B", "UN", "EAN008"]],
        ["BGM", [220], ["BKOD99"], [9]],
        ["DTM", [137, 20051107, 102]],
        ["NAD", ["BY"], [5412345000176, nil, 9]],
        ["NAD", ["SU"], [4012345000094, nil, 9]],
        ["LIN", [1], [1], [764569104, "IB"]],
        ["QTY", [1, 25]],
        ["FTX", ["AFM"], [1], [], ["XPath 2.0 Programmer's Reference"]],
        ["LIN", [2], [1], [764569090, "IB"]],
        ["QTY", [1, 25]],
        ["FTX", ["AFM"], [1], [], ["XSLT 2.0 Programmer's Reference"]],
        ["LIN", [3], [1], [1861004656, "IB"]],
        ["QTY", [1, 16]],
        ["FTX", ["AFM"], [1], [], ["Java Server Programming"]],
        ["LIN", [4], [1], [596006756, "IB"]],
        ["QTY", [1, 10]],
        ["FTX", ["AFM"], [1], [], ["Enterprise Service Bus"]],
        ["UNS", ["S"]],
        ["CNT", [2, 4]],
        ["UNT", [22], ["SSDD1"]],
        ["UNZ", [1], [6002]]
      ], r)
    end

    def test_file_getting_values
      r = EdifactParser::load_io @separate_lines_file
      assert_equal(r.first.first, "UNB")
      assert_equal(r[1].first, "UNH")
      assert_equal(r.last.first, "UNZ")
    end

    def test_escape_character_in_string
      r = EdifactParser::load("FTX+AFM+1++XSLT 2.0 Programmer?'s Reference'")
      assert_equal(
        [
          ["FTX", ["AFM"], [1], [], ["XSLT 2.0 Programmer's Reference"]]
        ],
        r
      )
    end

    def test_two_segment_document
      r = EdifactParser::load("FTX+AFM+1++Java Server Programming'LIN+4+1+0596006756:IB'")
      assert_equal(
        [
          ["FTX", ["AFM"], [1], [], ["Java Server Programming"]],
          ["LIN", [4], [1], [596006756, "IB"]]
        ],
        r
      )
    end

    def test_segment_with_colons
      r = EdifactParser::load("DTM+137:20051107:102'")
      assert_equal(
        [
          ["DTM", [137, 20051107, 102]]
        ],
        r
      )
    end

    def test_segment_with_empty_colons
      r = EdifactParser::load("NAD+SU+4012345000094::9'")
      assert_equal(
        [
          ["NAD", ["SU"], [4012345000094, nil, 9]]
        ],
        r
      )
    end

    def test_basic_segment
      parser = new_parser("UNB+UNOA:3+22234114345363:ZZ+55643345334:ZZ+130109:1412+61236'")
      r = parser.parse.result
      assert_equal(
        [
          ["UNB",

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

          ]
        ],
        r
      )
    end

    def test_segment_with_UNA
      parser = new_parser("UNA:+.? 'UNB+UNOA:3+22234114345363:ZZ+55643345334:ZZ+130109:1412+61236'")
      r = parser.parse.result
      assert_equal(
        [
        ["UNB",
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
        ]
        ],
        r
      )
    end

    def test_segment_with_no_colons
      parser = new_parser("UNT+22+SSDD1'")
      r = parser.parse.result
      assert_equal(
        [
          ["UNT", [22], ["SSDD1"]]
        ],
        r
      )
    end

    def test_segment_with_blank_element
      parser = new_parser("UNB+UNOA:3+22234114345363:ZZ+55643345334:ZZ++61236'")
      r = parser.parse.result
      assert_equal(
        [
        ["UNB",
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
            # empty array when there is no data inbetween +'s
          ],
          [
            61236
          ]
        ]],
        r
      )
    end

    def new_parser(string)
      tok = Tokenizer.new StringIO.new(string)
      Parser.new tok
    end
  end
end