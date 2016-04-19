require 'minitest/autorun'
require_relative '../lib/edifact_parser'

module EdifactParser
  class TestParser < MiniTest::Unit::TestCase
    FILES_DIR = File.dirname(__FILE__) + "/files"

    def test_separate_lines_file
      r = EdifactParser::load_io open("#{FILES_DIR}/separate_lines.edi")
      assert_equal([
        ["UNB", ["UNOA", 3], ["TESTPLACE", 1], ["DEP1", 1], [20051107, 1159], [6002]],
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

    def test_prod_avail_req_file
      r = EdifactParser::load_io open("#{FILES_DIR}/prod_avail_req.edi")
      assert_equal([
        ["UNB", ["IATB", 1], ["6XPPC"], ["LHPPC"], [940101, 950], [1]],
        ["UNH", [1], ["PAORES", 93, 1, "IA"]],
        ["MSG", [1, 45]],
        ["IFT", [3], ["XYZCOMPANY AVAILABILITY"]],
        ["ERC", ["A7V", 1, "AMD"]],
        ["IFT", [3], ["NO MORE FLIGHTS"]],
        ["ODI"],
        ["TVL", [240493, 1000, nil, 1220], ["FRA"], ["JFK"], ["DL"], [400], ["C"]],
        ["PDI", [], ["C", 3], ["Y", nil, 3], ["F", nil, 1]],
        ["APD", ["74C", 0, nil, nil, 6], [], [], [], [], [], ["6X"]],
        ["TVL", [240493, 1740, nil, 2030], ["JFK"], ["MIA"], ["DL"], [81], ["C"]],
        ["PDI", [], ["C", 4]],
        ["APD", ["EM2", 0, 1630, nil, 6], [], [], [], [], [], [], ["DA"]],
        ["UNT", [13], [1]],
        ["UNZ", [1], [1]]
      ],
        r
      )
    end

    def test_separate_lines_file_getting_values
      r = EdifactParser::load_io open("#{FILES_DIR}/separate_lines.edi")
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

    def test_parser_error_thrown
      parser = new_parser("asdjasdpo LULULU 191292**;;")
      assert_raises(EdifactParser::ParseError) do
        r = parser.parse.result
      end
    end

    def new_parser(string)
      tok = Tokenizer.new StringIO.new(string)
      Parser.new tok
    end
  end
end
