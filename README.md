# edifact_parser [![Build Status](https://travis-ci.org/pvdvreede/edifact_parser.png?branch=master)](https://travis-ci.org/pvdvreede/edifact_parser)

Simple UN/EDIFACT document parser for ruby.

This project will take in an EDIFACT document and parse it out to a ruby array structure for you to manipulate as you please.

*It does NOT do any validation of the document whatsoever.* This is up to you to implement from its return value.

## Requirements

This library has been tested on the following:

* Ruby MRI 1.9.2
* Ruby MRI 1.9.3
* Ruby MRI 2.0.0
* JRuby 1.7 in 1.9 mode

These are currently the only supported Ruby versions. You are welcome to try it with other versions and let me know if it works.

## Installation

```
gem install edifact_parser
```

## Usage

`edifact_parser` has a simple api that either takes an EDIFACT document as a string, or as a ruby IO object.

Just require the gem before usage with:

```ruby
require 'edifact_parser'
```

Then parse the EDIFACT document either from a string or an IO object.

As a string:

```ruby
ruby_array = EdifactParser::load(edi_string)
```

As an IO object:

```ruby
ruby_array = EdifactParser::load_io(open('path/to/file'))
```

## Output

The array that is returned by the parser is an array of EDIFACT segments.

The following EDIFACT document:

```
UNA:+.? '
UNB+UNOA:3+TESTPLACE:1+DEP1:1+20051107:1159+6002'
UNH+SSDD1+ORDERS:D:03B:UN:EAN008'
BGM+220+BKOD99+9'
DTM+137:20051107:102'
NAD+BY+5412345000176::9'
NAD+SU+4012345000094::9'
LIN+1+1+0764569104:IB'
QTY+1:25'
FTX+AFM+1++XPath 2.0 Programmer?'s Reference'
LIN+2+1+0764569090:IB'
QTY+1:25'
FTX+AFM+1++XSLT 2.0 Programmer?'s Reference'
LIN+3+1+1861004656:IB'
QTY+1:16'
FTX+AFM+1++Java Server Programming'
LIN+4+1+0596006756:IB'
QTY+1:10'
FTX+AFM+1++Enterprise Service Bus'
UNS+S'
CNT+2:4'
UNT+22+SSDD1'
UNZ+1+6002'
```

Will be converted to the following ruby array:

```ruby
[
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
]
```

Note that the composites inside segments are arrays themselves that may contain zero to many values. If the composite is empty it will be an empty array, and if one of the values inside a composite is empty it will contain a `nil` value inside the array.

To see more examples look at the [test_parser.rb](https://github.com/pvdvreede/edifact_parser/blob/master/test/test_parser.rb) file.

## License

`edifact_parser` is provided free of charge under the MIT license.

Copyright (c) 2013 Paul Van de Vreede

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the 'Software'), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
