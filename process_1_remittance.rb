#!/usr/bin/env ruby
#
# Process one remittance file
# =============================================================  
# $CHANGE LOG:
# 2013-01-02 jes  - Move Structs to UtilityModule and setup for running inside
#                 process_remittances.rb -- MUCH faster!
# $END LOG:

require 'spreadsheet'
require 'flt'
include Flt
require 'pp'
### Now included in the main module
#load "utility_module.rb"
#include UtilityModule

remitinfo=''
def remittify(row)
  return nil if row.empty?
  return nil if row[0] == 'Line #'
  return nil if row[0].nil?
  r = Remittance.new(
      row[0].to_i, 
      row[1].nil? ? '' : row[1].tr!("~",","), # Sometimes, the name is missing!
      fmt_no(row[2]),     # uci number
      fmt_no(row[3]),     # service code 
      row[4], 
      fmt_no(row[5]),     # authorization number  
      row[6],
      row[7],             # units  
      row[8],             # amount
      fmt_no(row[9]),     # adjustment code (usually 0)
      nil,nil,
      ### Unable to get the following to work...
      #"EB#{remitinfo[:year]}#{remitinfo[:month_no]}",
      #remitinfo[:invoice_no]
      nil                 # BTRS match name
  )
  return nil if r[:uci_no].nil?
  return nil if r[:authorization_no].nil?
  r[:btrs_uci_match_name] = create_btrs_match_name(r[:consumer_name])
  r
end

emit_error_and_exit("Missing job parameters: filename or ebill_date") if ARGV[0].nil? || ARGV[1].nil?
filename = ARGV[0]
ebill_date = ARGV[1]
remitinfo = parse_file_name(filename)
remitinfo[:ebill_date] = ebill_date
emit_error_and_exit("Invalid remittance file name: #{ARGV[0]}") if remitinfo.include?(nil)
emit_msg("Processing invoice# #{remitinfo[:invoice_no]} for EBill date #{remitinfo[:ebill_date]}")
DecNum.context.precision = 2
record_count = total_hours = total_amount = 0 #; total_amount = DecNum.new(0)
book = Spreadsheet.open(filename)
sheet = book.worksheet(0)
outfile = open('remittance.txt', 'a')
begin
  sheet.each do |row|
    #puts row.join(' // ') if record_count == 1
    remittance = remittify(row)
    #puts "Remittance: #{remittance}"
    next if remittance.nil?
    remittance[:ebill_id] = "EB#{remitinfo[:year]}#{remitinfo[:month_no]}"
    remittance[:invoice_no] = remitinfo[:invoice_no]
    ### Add tab at start of line to allow for autonumber ID field
    outfile.puts "\t"+remittance.to_a.join("\t")
    record_count += 1 ; total_hours += remittance[:units]
    total_amount += remittance[:amount] #DecNum(remittance[:amount].to_s)
  end 
rescue Exception => e
  pp e.backtrace
  emit_error_and_exit "Error in #{filename}: #{$!}. Terminating!"
ensure  
  outfile.close
end
#outfile.close
emit_msg(<<EOF
Records.................... #{'%7d' % [record_count]}
Hours...................... #{'%10.2f' % [total_hours]}
Amount..................... #{'%10.2f' % [total_amount]}
EOF
        )
