# edifact_parser

Simple UN/EDIFACT parser for ruby.

This project will take in an EDIFACT document and parse it out to a ruby hash and array structure for you to manipulate as you please.

*It does NOT do any validation of the document whatsoever.* This is up to you to implement from its return value.

## Installation

TBD.

## Usage

`edifact_parser` has a simple api that either takes an EDIFACT document as a string, or as ruby IO object.

As a string:

    ruby_hash = EdifactParser::load(edi_string)
    
As an IO object:

    ruby_hash = EdifactParser::load_io(open('path/to/file'))
    
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