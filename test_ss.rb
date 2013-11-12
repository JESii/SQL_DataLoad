#!/usr/bin/env ruby
#
# Testing spreadsheet gem

require 'spreadsheet'
require 'flt'
include Flt
require 'pp'

filename = ARGV[0]
DecNum.context.precision = 2
record_count = total_hours = total_amount = 0 #; total_amount = DecNum.new(0)
book = Spreadsheet.open(filename)
sheet = book.worksheet(0)
outfile = open('remittance.txt', 'a')
begin
  sheet.each do |row|
    puts row.join(' // ') if record_count == 1
    record_count += 1
  end 
rescue Exception => e
  pp e.backtrace
  emit_error_and_exit "Error in #{filename}: #{$!}. Terminating!"
ensure  
  outfile.close
end
