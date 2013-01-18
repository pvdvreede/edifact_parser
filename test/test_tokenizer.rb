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
          ['+', '+'],
          [:STRING, 'ZZ'],
          [':', ':'],
          [:NUMBER, 3],
          ["'", "'"],
          [:QUALIFIER, "UNH"],
          ['+', '+'],
          ['+', '+'],
          [:STRING, "testing"],
          ["'", "'"],
          nil
        ]
      ],
      ["UNA:+.? 'UNB+UNOA:3+22234114345363:ZZ+55643345334:ZZ+130109:1412+61236'UNH+1237+ORDERS:D:96A:UN:EAN008'",
        [
          [:OPTIONAL_BEGIN, 'UNA:+.? \''],
          [:QUALIFIER, 'UNB'],
          ['+', '+'],
          [:STRING, 'UNOA'],
          [':', ':'],
          [:NUMBER, 3],
          ['+', '+'],
          [:NUMBER, 22234114345363],
          [':', ':'],
          [:STRING, 'ZZ'],
          ['+', '+'],
          [:NUMBER, 55643345334],
          [':', ':'],
          [:STRING, 'ZZ'],
          ['+', '+'],
          [:NUMBER, 130109],
          [':', ':'],
          [:NUMBER, 1412],
          ['+', '+'],
          [:NUMBER, 61236],
          ["'", "'"],
          [:QUALIFIER, 'UNH'],
          ['+', '+'],
          [:NUMBER, 1237],
          ['+', '+'],
          [:STRING, 'ORDERS'],
          [':', ':'],
          [:STRING, 'D'],
          [':', ':'],
          [:STRING, '96A'],
          [':', ':'],
          [:STRING, 'UN'],
          [':', ':'],
          [:STRING, 'EAN008'],
          ["'", "'"],
          nil
        ]
      ],
        ["UNA:+.? 'UNB+UNOA:3+ 7788665534566:ZZ+55643345334:ZZ+130109:1412+61236'UNH+1237+ORDERS with space:D:96A:UN:EAN008'  ",
          [
            [:OPTIONAL_BEGIN, 'UNA:+.? \''],
            [:QUALIFIER, 'UNB'],
            ['+', '+'],
            [:STRING, 'UNOA'],
            [':', ':'],
            [:NUMBER, 3],
            ['+', '+'],
            [:NUMBER, 7788665534566],
            [':', ':'],
            [:STRING, 'ZZ'],
            ['+', '+'],
            [:NUMBER, 55643345334],
            [':', ':'],
            [:STRING, 'ZZ'],
            ['+', '+'],
            [:NUMBER, 130109],
            [':', ':'],
            [:NUMBER, 1412],
            ['+', '+'],
            [:NUMBER, 61236],
            ["'", "'"],
            [:QUALIFIER, 'UNH'],
            ['+', '+'],
            [:NUMBER, 1237],
            ['+', '+'],
            [:STRING, 'ORDERS with space'],
            [':', ':'],
            [:STRING, 'D'],
            [':', ':'],
            [:STRING, '96A'],
            [':', ':'],
            [:STRING, 'UN'],
            [':', ':'],
            [:STRING, 'EAN008'],
            ["'", "'"],
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