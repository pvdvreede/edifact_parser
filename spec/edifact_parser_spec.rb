# -*- coding: UTF-8 -*-

require 'parslet/rig/rspec'
require 'edifact_parser'

describe EdifactParser::Parser do
  let(:parser)    { EdifactParser::Parser.new }

  it 'parses integers' do
    expect(parser.integer).to     parse('1')
    expect(parser.integer).to     parse('-123')
    expect(parser.integer).to     parse('120381')
    expect(parser.integer).to     parse('181')
    expect(parser.integer).to_not parse('0181')
  end

  it 'parses floats' do
    expect(parser.float).to     parse('0.1')
    expect(parser.float).to     parse('3.14159')
    expect(parser.float).to     parse('-0.00001')
    expect(parser.float).to_not parse('.1')
  end

  it 'parses strings' do
    expect(parser.string).to     parse('hello there')
    expect(parser.string).to     parse('hello there it?\'s great!')
    expect(parser.string).to     parse('hello there it?\'s great!')
    expect(parser.string).to_not parse('hello there it\'s great!')
    expect(parser.string).to_not parse('hello there +1 great!')
  end

  it 'parses qualifiers' do
    expect(parser.qualifier).to     parse('ABC')
    expect(parser.qualifier).to     parse('DBF')
    expect(parser.qualifier).to_not parse('ADBF')
    expect(parser.qualifier).to_not parse('AD\'BF')
    expect(parser.qualifier).to_not parse('fds')
    expect(parser.qualifier).to_not parse('F0s')
  end

  it 'parses segment end' do
    expect(parser.segment_end).to     parse('\'')
    expect(parser.segment_end).to_not parse('?\'')
  end

  it 'parses component separator' do
    expect(parser.component_sep).to     parse(':')
    expect(parser.component_sep).to_not parse('?:')
  end

  it 'parses data separator' do
    expect(parser.data_sep).to      parse('+')
    expect(parser.data_sep).to_not  parse('?+')
  end

  # it 'parses a segment' do
  #   expect(parser.segment).to     parse('+324:a string!+')
  #   expect(parser.segment).to     parse('+324:a string!\'')
  #   expect(parser.segment).to     parse('+324:a string!:1.234\'')
  #   expect(parser.segment).to_not parse('+324+')
  #   expect(parser.segment).to_not parse('+a string\'')
  # end

end
