module EdifactParser
  class Format
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

    OPTIONAL_BEGIN = /^UNA.{4}\s./

    def self.from_source(source)
      return new() unless source.match(OPTIONAL_BEGIN)

      new(
        component_data_element_selector: source[3],
        data_element_separator: source[4],
        decimal_notification: source[5],
        release_indicator: source[6],
        # 7 is reserved for future use in the spec
        segment_terminator: source[8]
      )
    end

    def initialize(component_data_element_selector: ':',
                   data_element_separator: '+',
                   decimal_notification: '.',
                   release_indicator: '?',
                   segment_terminator: "'")
      @component_data_element_selector = component_data_element_selector
      @data_element_separator = data_element_separator
      @decimal_notification = decimal_notification
      @release_indicator = release_indicator
      @segment_terminator = segment_terminator
      @regexes = {}

      add_regexes!
    end

    def get(name)
      @regexes.fetch(name)
    end

    private

    def look_forward_to_separator
      separator_matchers = [@component_data_element_selector,
                            @data_element_separator,
                            @release_indicator,
                            @segment_terminator].map { |c| "\\#{c}" }.join('|')
      "(?=[#{separator_matchers}])"
    end

    def add_regexes!
      @regexes[:qualifiers]     = qualifier_regex
      @regexes[:optional_begin] = OPTIONAL_BEGIN
      @regexes[:string]         = string_regex
      @regexes[:space]          = /\s+/
      @regexes[:line_break]     = /\n/
      @regexes[:number]         = /[0-9]+#{'\\' + @decimal_notification}?[0-9]?+#{look_forward_to_separator}/
      @regexes[:segment_end]    = /(?<!#{'\\' + @release_indicator})#{'\\' + @segment_terminator}/
      @regexes[:plus]           = /(?<!#{'\\' + @release_indicator})#{'\\' + @data_element_separator}/
      @regexes[:colon]          = /(?<!#{'\\' + @release_indicator})#{'\\' + @component_data_element_selector}/
    end

    def qualifier_regex
      reg_ex_string = ""

      QUALIFIERS.each do |qual|
        reg_ex_string += "#{qual}#{look_forward_to_separator}|"
      end

      /(^|(?<=\#{@segment_terminator}))(#{reg_ex_string[0, reg_ex_string.length-1]})/
    end

    def string_regex
      /^.*?[^#{'\\' + @release_indicator }](?=[#{'\\' + @component_data_element_selector}|#{'\\' + @segment_terminator}|#{'\\' + @data_element_separator}])/
    end
  end
end
