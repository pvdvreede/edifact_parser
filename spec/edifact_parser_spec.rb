# -*- coding: UTF-8 -*-

require 'spec_helper'

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
    expect(parser.float).to     parse('12303.56')
    expect(parser.float).to     parse('-0.00001')
    expect(parser.float).to_not parse('.1')
  end

  it 'parses strings' do
    expect(parser.string).to     parse('hello there')
    expect(parser.string).to     parse('96A')
    expect(parser.string).to     parse('D')
    expect(parser.string).to     parse('hello there it?\'s great!')
    expect(parser.string).to     parse('hello there it?\'s great!')
    expect(parser.string).to_not parse('hello there it\'s great!')
    expect(parser.string).to_not parse('hello there +1 great!')
  end

  it 'parses scalars' do
    expect(parser.scalar).to      parse('hi, how are you')
    expect(parser.scalar).to      parse('1233')
    expect(parser.scalar).to      parse('-4590')
    expect(parser.scalar).to      parse('-45.34598')
    expect(parser.scalar).to      parse('12.453')
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

  it 'parses a segment' do
    expect(parser.segment).to     parse('ABC+helo:123\'')
    expect(parser.segment).to     parse('ABC++testing:1232+sdfsd\'')
    expect(parser.segment).to     parse(
      'UNB+UNOA:3+22234114345363:ZZ+55643345334:ZZ+130109:1412+61236\'')
    expect(parser.segment).to     parse('UNH+1237+ORDERS:D:96A:UN\'')
    expect(parser.segment).to     parse('UNH\'')
    expect(parser.segment).to_not parse('GHF+324+')
    expect(parser.segment).to_not parse('+a string\'')
  end

  it 'parses documents' do
    expect(parser.document).to     parse(
      'UNA:+.? \'' +
      'UNB+UNOA:3+22234114345363:ZZ+55643345334:ZZ+130109:1412+61236\'' +
      'UNH+1237+ORDERS:D:96A:UN:EAN008\'')
    expect(parser.document).to     parse(
      'UNA:+.? \'' +
      'UNB+UNOA:3+7788665534566:ZZ+55643345334:ZZ+130109:1412+61236\'' +
      'UNH+1237+ORDERS:D:96A:UN:EAN008\'  ')
    expect(parser.document).to     parse(
      'UNA:+.? \'' +
      'UNB+UNOA:3+ 7788665534566:ZZ+55643345334:ZZ+130109:1412+61236\'' +
      'UNH+1237+ORDERS with space:D:96A:UN:EAN008\'')
    expect(parser.document).to     parse(
      'UNA:+.? \'' +
      'UNB+UNOA:3+ 7788665534566:ZZ+55643345334:ZZ+130109:1412+61236\'' +
      'UNH+1237+contains an escape?\' character or ?+two:D:96A:UN:EAN008\'  ')
  end

end
