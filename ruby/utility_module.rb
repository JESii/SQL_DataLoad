module UtilityModule
  # $DESCRIPTION
  #   Utility functions for MORS processing
  # =============================================================  
  # $CHANGE LOG:
  # 2012-12-28 jes  - Tweak create_bts_match_name()
  # 2013-01-02 jes  - Incorporate Structs from process_1_remittance
  #                 - Raise SystemExit so can catch it later
  # 2013-01-13 jes  - Reduce multiple spaces to a single space                
  # $END LOG:


  # General definitions
  tab = "\n" ; dq = '"' ; sq = "'" 

  Remitinfo = Struct.new(:year, :month_no, :invoice_no, :ebill_date)

  def make_remitinfo(array)
    Remitinfo.new(
      array[0], array[1], array[2], nil
    )
  end
  
  Remittance = Struct.new(:line_no, :consumer_name, :uci_no, :service_code, :sub_code, :authorization_no, :service_MY,
                          :units, :amount, :adjustment_code, :ebill_id, :invoice_no, :btrs_uci_match_name)

def fmt_no(val)
  ("%10.0f" % val).strip
end

  def parse_file_name(fname)
    filename = File.basename(fname)
    puts filename
    test = filename =~ /^Rem[_ ](\d\d\d\d)_(\d\d)[_ ](\w*)\.xls$/
    return  make_remitinfo([$1,$2,$3]) if ! test.nil?
    test = filename =~ /^Inv(\w*)_(\d\d\d\d)[-_](\d\d).*\.xls$/ 
    make_remitinfo([$2,$3,$1])
  end
  def emit_msg(msg)
    puts msg
  end
  def emit_error(string)
    emit_msg "(ERROR) #{string}"
  end
  def emit_error_and_exit(string)
    emit_msg("(FATAL) " + string)
    #Process.kill(9,0)
    #Process.kill("SIGTERM",0)
    #abort
    raise SystemExit #exit(0)
  end

  def create_btrs_match_name(name)
    return nil if name.nil?
    match_name = name.clone() # Use clone so name doesn't get wasted
    match_name.upcase!
    match_name.gsub!(/\` /, '`')    # Special case for X` Abcd
    match_name.gsub!(/`/, "'")    # Replace BTRS ` with '
    match_name.tr!(",.'", " ")
    match_name.gsub!(/^(.*)\s+-\s+(.*)$/,'\1-\2')
    match_name.gsub!(/\s+/,' ')
    match_name.strip!
    match_name.gsub!(/^(.*)\s\w$/,'\1')   # Drop trailing single letters
    match_name.gsub!(/(.*)\(\w*\)$/,'\1') # Drop parenthesized names
#    match_name.gsub!(/\s\s+/, ' ')        # Reduce multiple spaces to a single space
    match_name.strip!
    match_name
  end
end
