#!/usr/bin/env ruby

require 'pp'
require 'spreadsheet'

class Sqlizer

  def self.initialize_output()
    @sqlfile = File.open("SingleLocation.sql", "w")
    @textfile = File.open("SingleLocation.txt", "w")
  end

  def self.finalize_output()
    @sqlfile.close
    @textfile.close
  end

  initialize_output()

  book = Spreadsheet.open(ARGV[0])
  sheet = book.worksheet(0)
  puts "sheet.rows.size: #{sheet.rows.size}"
  puts "book.worksheet(0).rows.size: #{book.worksheet(0).rows.size}"
  row_total = sheet.rows.size
# The above statement fails - empty rows array; therefore, we can't use it in the counter option below
#PRINT CONVERT(VARCHAR(6), #{counter}, 1 + ' of ' + CONVERT(VARCHAR(6), #{row_total}, 1) + ' items.'

  counter = 0

  @sqlfile.puts 'DECLARE @RC INI'
  @sqlfile.puts 'USE SERVMAN97'
  sheet.each do |row|
    next if row[0].is_a? String
    acct_no = row[2]
    next if acct_no == 'ACCT_NO'
    counter += 1
    @textfile.puts acct_no.to_s
    @sqlfile.puts 'EXECUTE @RC = [arborWell_CreateNewLocation] ' + sprintf("%6d", acct_no)
    if counter % 500 == 0 then
      @sqlfile.puts <<EOF
      GO
      DBCC FREESYSTEMCACHE ('ALL')
      DBCC FREESESSIONCACHE
      DBCC FREEPROCCACHE
      PRINT #{counter}
      GO
      DECLARE @RC INT
      USE SERVMAN97
EOF
    end
  end
  summary = <<EOF

  ============================================================
  Total Single Location accounts......................#{counter}
  ============================================================
EOF
  puts summary
  STDERR.puts summary
  finalize_output()
end
