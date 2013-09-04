# -*- coding: UTF-8 -*-

# Main parser file
class EdifactParser::Parser < ::Parslet::Parser

  rule(:digit)          { match('[0-9]') }
  rule(:integer) do
    str('-').maybe >> match('[1-9]') >> digit.repeat
  end
  rule(:float) do
    str('-').maybe >> digit.repeat(1) >> str('.') >> digit.repeat(1)
  end

  rule(:string_escape)    { str('?') }
  rule(:string_special)   { match('[\':+]') }
  rule(:escaped_special)  { string_escape >> string_special }
  rule(:string) do
    (escaped_special | string_special.absent? >> any).repeat
  end

  rule(:value) do
    integer | float | string
  end

  rule(:data_value) do
    data_sep >> value
  end

  rule(:comp_value) do
    component_sep >> value
  end

  rule(:plus)           { match('[+]') }
  rule(:colon)          { match('[:]') }

  rule(:separator)      { component_sep | data_sep }
  rule(:component_sep)  { string_escape.absent? >> colon }
  rule(:data_sep)       { string_escape.absent? >> plus }

  rule(:line_start)     { match('[^]') }
  rule(:line_end)       { match('[\n\r]') }
  rule(:segment_end)    { string_escape.absent? >> match('[\']') }
  rule(:qualifier)      { match('[A-Z]').repeat(3, 3) }

end
