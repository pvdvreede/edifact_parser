# -*- coding: UTF-8 -*-

# Main parser file
class EdifactParser::Parser < ::Parslet::Parser

  # Scalar values
  rule(:digit) do
    match('[0-9]')
  end

  rule(:negative) do
    str('-')
  end

  rule(:integer) do
    negative.maybe >>
    match('[1-9]') >>
    digit.repeat
  end

  rule(:float) do
    negative.maybe >>
    digit.repeat(1) >>
    str('.') >>
    digit.repeat(1)
  end

  rule(:string_escape)    { str('?') }

  rule(:string_special)   { match('[\':+]') }

  rule(:escaped_special)  { string_escape >> string_special }

  rule(:string) do
    (escaped_special | string_special.absent? >> any).repeat
  end

  rule(:scalar) do
    string | float | integer
  end

  rule(:value) do
    data_value | comp_value | data_sep | component_sep
  end

  rule(:values) do
    value.repeat(1)
  end

  rule(:segment) do
    qualifier >> values.maybe >> segment_end >> whitespace.maybe
  end

  rule(:segments) do
    segment.repeat(1)
  end

  rule(:document) do
    segments
  end

  rule(:whitespace) do
    match('[\s\t\r\n]').repeat(1)
  end

  # Separators
  rule(:data_value) do
    data_sep >> scalar
  end

  rule(:comp_value) do
    component_sep >> scalar
  end

  rule(:plus)           { str('+') }
  rule(:colon)          { str(':') }

  rule(:component_sep)  { string_escape.absent? >> colon }
  rule(:data_sep)       { string_escape.absent? >> plus }
  rule(:separator)      { component_sep | data_sep }
  rule(:any_separator)  { separator | segment_end }

  rule(:line_start)     { match('[^]') }
  rule(:line_end)       { match('[\n\r]') }
  rule(:segment_end)    { string_escape.absent? >> match('[\']') }
  rule(:qualifier)      { match('[A-Z]').repeat(3, 3) }

end
