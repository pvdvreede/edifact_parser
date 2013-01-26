require 'minitest/autorun'
require 'stringio'
require_relative '../lib/edifact_parser/tokenizer'

module EdifactParser
  class TestTokenizer < MiniTest::Unit::TestCase
    [
      ["UNA:+.? 'UNB+ZZ:3'UNH++testing'",
        [
          [:OPTIONAL_BEGIN, 'UNA:+.? \''],
          [:QUALIFIER, 'UNB'],
          [:PLUS, '+'],
          [:STRING, 'ZZ'],
          [:COLON, ':'],
          [:NUMBER, 3],
          [:SEGMENT_END, "'"],
          [:QUALIFIER, "UNH"],
          [:PLUS, '+'],
          [:PLUS, '+'],
          [:STRING, "testing"],
          [:SEGMENT_END, "'"],
          nil
        ]
      ],
      ["UNA:+.? 'UNB+UNOA:3+22234114345363:ZZ+55643345334:ZZ+130109:1412+61236'UNH+1237+ORDERS:D:96A:UN:EAN008'",
        [
          [:OPTIONAL_BEGIN, 'UNA:+.? \''],
          [:QUALIFIER, 'UNB'],
          [:PLUS, '+'],
          [:STRING, 'UNOA'],
          [:COLON, ':'],
          [:NUMBER, 3],
          [:PLUS, '+'],
          [:NUMBER, 22234114345363],
          [:COLON, ':'],
          [:STRING, 'ZZ'],
          [:PLUS, '+'],
          [:NUMBER, 55643345334],
          [:COLON, ':'],
          [:STRING, 'ZZ'],
          [:PLUS, '+'],
          [:NUMBER, 130109],
          [:COLON, ':'],
          [:NUMBER, 1412],
          [:PLUS, '+'],
          [:NUMBER, 61236],
          [:SEGMENT_END, "'"],
          [:QUALIFIER, 'UNH'],
          [:PLUS, '+'],
          [:NUMBER, 1237],
          [:PLUS, '+'],
          [:STRING, 'ORDERS'],
          [:COLON, ':'],
          [:STRING, 'D'],
          [:COLON, ':'],
          [:STRING, '96A'],
          [:COLON, ':'],
          [:STRING, 'UN'],
          [:COLON, ':'],
          [:STRING, 'EAN008'],
          [:SEGMENT_END, "'"],
          nil
        ]
      ],
      ["UNA:+.? 'UNB+UNOA:3+ 7788665534566:ZZ+55643345334:ZZ+130109:1412+61236'UNH+1237+ORDERS with space:D:96A:UN:EAN008'  ",
        [
          [:OPTIONAL_BEGIN, 'UNA:+.? \''],
          [:QUALIFIER, 'UNB'],
          [:PLUS, '+'],
          [:STRING, 'UNOA'],
          [:COLON, ':'],
          [:NUMBER, 3],
          [:PLUS, '+'],
          [:NUMBER, 7788665534566],
          [:COLON, ':'],
          [:STRING, 'ZZ'],
          [:PLUS, '+'],
          [:NUMBER, 55643345334],
          [:COLON, ':'],
          [:STRING, 'ZZ'],
          [:PLUS, '+'],
          [:NUMBER, 130109],
          [:COLON, ':'],
          [:NUMBER, 1412],
          [:PLUS, '+'],
          [:NUMBER, 61236],
          [:SEGMENT_END, "'"],
          [:QUALIFIER, 'UNH'],
          [:PLUS, '+'],
          [:NUMBER, 1237],
          [:PLUS, '+'],
          [:STRING, 'ORDERS with space'],
          [:COLON, ':'],
          [:STRING, 'D'],
          [:COLON, ':'],
          [:STRING, '96A'],
          [:COLON, ':'],
          [:STRING, 'UN'],
          [:COLON, ':'],
          [:STRING, 'EAN008'],
          [:SEGMENT_END, "'"],
          nil
        ]
      ],
      ["UNA:+.? 'UNB+UNOA:3+ 7788665534566:ZZ+55643345334:ZZ+130109:1412+61236'UNH+1237+contains an escape?' character or ?+two:D:96A:UN:EAN008'  ",
        [
          [:OPTIONAL_BEGIN, 'UNA:+.? \''],
          [:QUALIFIER, 'UNB'],
          [:PLUS, '+'],
          [:STRING, 'UNOA'],
          [:COLON, ':'],
          [:NUMBER, 3],
          [:PLUS, '+'],
          [:NUMBER, 7788665534566],
          [:COLON, ':'],
          [:STRING, 'ZZ'],
          [:PLUS, '+'],
          [:NUMBER, 55643345334],
          [:COLON, ':'],
          [:STRING, 'ZZ'],
          [:PLUS, '+'],
          [:NUMBER, 130109],
          [:COLON, ':'],
          [:NUMBER, 1412],
          [:PLUS, '+'],
          [:NUMBER, 61236],
          [:SEGMENT_END, "'"],
          [:QUALIFIER, 'UNH'],
          [:PLUS, '+'],
          [:NUMBER, 1237],
          [:PLUS, '+'],
          [:STRING, "contains an escape?' character or ?+two"],
          [:COLON, ':'],
          [:STRING, 'D'],
          [:COLON, ':'],
          [:STRING, '96A'],
          [:COLON, ':'],
          [:STRING, 'UN'],
          [:COLON, ':'],
          [:STRING, 'EAN008'],
          [:SEGMENT_END, "'"],
          nil
        ]
      ]
    ].each do |document|
      define_method("test_document_#{document.first[0..20].gsub(" ", '_')}") do
        tok = new_tokenizer(document.first)
        document.last.each do |token|
          assert_equal token, tok.next_token
        end
      end
    end

    def new_tokenizer(string)
      EdifactParser::Tokenizer.new StringIO.new(string)
    end
  end
end