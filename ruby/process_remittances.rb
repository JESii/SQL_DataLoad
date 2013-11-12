#!/usr/bin/env ruby
#
# Walk the directory tree to process all remittances

require 'pp'
#require "win32/process"
#require 'sys/proctable'
#include Win32
#include Sys
load "utility_module.rb"
include UtilityModule

emit_error_and_exit("Missing starting directory parameter") if ARGV[0].nil?
emit_error_and_exit("Invalid starting directory parameter #{ARGV[0]}") if ! File.exist?(ARGV[0])
exec_dir = Dir.pwd
start_dir = ARGV[0]
emit_msg("Starting directory is: #{start_dir}")
#Dir.chdir(start_dir)
ebill_dirs = Dir.glob(start_dir+"/*")
pp "EBill directory root: #{ebill_dirs}"
File.delete('remittance.txt') if File.exists?("remittance.txt")
ebill_dirs.each do |ebill_dir|
  ebill_dir =~ /(\d\d\d\d)_(\d\d)_(\d\d)/
  ebill_year = $1 ; ebill_month = $2 ; ebill_day = $3
  ebill_YYMM = ebill_year + "/" + ebill_month
  puts "Files for #{ebill_YYMM}"
  ebill_files = Dir.glob(ebill_dir + "/Remittance/*.xls")
  pp "EBill files: #{ebill_files}"
  ebill_files.each do |ebill_file|
    begin
      ARGV[0] = ebill_file
      ARGV[1] = ebill_YYMM
      load 'process_1_remittance.rb'
    rescue SystemExit
      puts "...Continuing"
    end
    #system("ruby #{exec_dir}/process_1_remittance.rb '#{ebill_file}' #{ebill_YYMM}")
    ### Following didn't work
    #%x[ruby #{exec_dir}/process_1_remittance.rb '#{ebill_file}' #{ebill_YYMM}]
    #Process.wait(Process.spawn("ruby #{exec_dir}/process_1_remittance.rb '#{ebill_file}' #{ebill_YYMM}"))
    #`"ruby process_1_remittance #{ebill_file} #{ebill_YYMM}"`
    #system("ruby process_1_remittance #{ebill_file} #{ebill_YYMM}"
  end       
  puts "Finished remittance files for #{ebill_dir}"
end
emit_msg("Finished!")

