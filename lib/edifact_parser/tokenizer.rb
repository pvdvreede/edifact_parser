require 'strscan'

module EdifactParser
  class Tokenizer
    QUALIFIERS = [
      'UNB', 'UNH', 'UNZ', 'UNT', 'UNS', 'IFI', 'IFT', 'ODI', 'TVL', 'APD',
      'ADR', 'AGR', 'AJT', 'ALC', 'ALI', 'APP', 'APR', 'ARD', 'ARR', 'ASI', 'ATT', 'AUT',
      'BAS', 'BGM', 'BII', 'BUS', 'CAV', 'CCD', 'CCI', 'CDI', 'CDS', 'CDV', 'CED', 'CIN',
      'CLA', 'CLI', 'CMP', 'CNI', 'CNT', 'COD', 'COM', 'COT', 'CPI', 'CPS', 'CPT', 'CST',
      'CTA', 'CUX', 'DAM', 'DFN', 'DGS', 'DII', 'DIM', 'DLI', 'DLM', 'DMS', 'DOC', 'DRD',
      'DSG', 'DSI', 'DTM', 'EDT', 'EFI', 'ELM', 'ELU', 'ELV', 'EMP', 'EQA', 'EQD', 'EQN',
      'ERC', 'ERP', 'EVE', 'FCA', 'FII', 'FNS', 'FNT', 'FOR', 'FSQ', 'FTX', 'GDS', 'GEI',
      'GID', 'GIN', 'GIR', 'GOR', 'GRU', 'HAN', 'HYN', 'ICD', 'IDE', 'IFD', 'IHC', 'IMD',
      'IND', 'INP', 'INV', 'IRQ', 'LAN', 'LIN', 'LOC', 'MEA', 'MEM', 'MKS', 'MOA', 'MSG',
      'MTD', 'NAD', 'NAT', 'PAC', 'PAI', 'PAS', 'PCC', 'PCD', 'PCI', 'PDI', 'PER', 'PGI',
      'PIA', 'PNA', 'POC', 'PRC', 'PRI', 'PRV', 'PSD', 'PTY', 'PYT', 'QRS', 'QTY', 'QUA',
      'QVR', 'RCS', 'REL', 'RFF', 'RJL', 'RNG', 'ROD', 'RSL', 'RTE', 'SAL', 'SCC', 'SCD',
      'SEG', 'SEL', 'SEQ', 'SFI', 'SGP', 'SGU', 'SPR', 'SPS', 'STA', 'STC', 'STG', 'STS',
      'TAX', 'TCC', 'TDT', 'TEM', 'TMD', 'TMP', 'TOD', 'TPL', 'TRU', 'TSR', 'VLI' ]

    OPTIONAL_BEGIN = /^UNA:\+\.\?\s'/
    STRING = /[A-Za-z0-9\s\.]*(\?')*[A-Za-z0-9\s\.]*(\?\+)*[A-Za-z0-9\s\.]*(\?:)*[A-Za-z0-9\s\.]*/
    SPACE = /\s+/
    NUMBER = /[0-9]+(?=[\+:'])/
    LINE_BREAK = /\n/
    SEGMENT_END = /(?<!\?)'/
    PLUS = /(?<!\?)\+/
    COLON = /(?<!\?)\:/

    def initialize(io)
      @ss = StringScanner.new io.read
      @qualifiers = qualifier_regex
    end

    def next_token
      return if @ss.eos?

      # ignore spaces and line breaks
      @ss.scan(SPACE)
      @ss.scan(LINE_BREAK)

      return if @ss.eos?

      case
      when text = @ss.scan(OPTIONAL_BEGIN) then [:OPTIONAL_BEGIN, text]
      when text = @ss.scan(@qualifiers) then [:QUALIFIER, text]
      when text = @ss.scan(SEGMENT_END) then [:SEGMENT_END, text]
      when text = @ss.scan(PLUS) then [:PLUS, text]
      when text = @ss.scan(COLON) then [:COLON, text]
      when text = @ss.scan(NUMBER) then [:NUMBER, text.to_i]
      when text = @ss.scan(STRING) then [:STRING, text]
      else
        x = @ss.getch
        [x, x]
      end
    end

    private

    def qualifier_regex
      reg_ex_string = ""

      QUALIFIERS.each do |qual|
        reg_ex_string += "#{qual}|"
      end

      /(^|(?<='))(#{reg_ex_string[0, reg_ex_string.length-1]})/
    end

  end
end
