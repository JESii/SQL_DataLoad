#!/usr/bin/env ruby

require 'json'
require 'pp'
load 'utility_module.rb'
include UtilityModule

### This is the merge candidates from Alison's s/sheet
# These MUST be run before the duplicate locations 'master' file

if ARGV[0].nil? then
  STDERR.puts "Usage: create_merge_list.rb <file-name>"
  exit 1
end

json = File.read(ARGV[0])
if json.nil? || json == 'null' then
  STDERR.puts "\t*** No data in merge list file"
  exit 1
end
groups = JSON.parse(json)
STDERR.puts "\tThe merge list contains #{groups.size} items"
err_accounts ||= {}
sl_accounts ||= {}
groups.each do |row|
  a0 = row[0]
  a1 = row[1]
  ### If a single-location account is the recipient, make it the sender
  a1,a0 = a0, a1 if acct_is_a?(a1) == 'S'
  ### If either candidate is a billing account, then we must skip it
  if acct_is_a?(a0) == 'B' || acct_is_a?(a1) == 'B' then
    err_accounts[a0] ||= []
    err_accounts[a0] << a1
    STDERR.puts "Skipping items - can't merge Billing Accounts: #{a0}, #{a1}" 
    STDERR.puts "\tERROR: Double-merge! #{a0}" if err_accounts[a0].size > 1
    next 
  end
  ### Now switch SingleLocation accounts to their Billing Account
  # Also, the "sender" is gone so cannot be used in the master relationships
  if acct_is_a?(a0) == 'S' then
    tmp = get_bill_code(a0)
    tmp2 = acct_is_a?(a1) == 'S' ? get_bill_code(a1) : a1
    sl_accounts[tmp] ||= []
    sl_accounts[tmp] << tmp2
    STDERR.puts "Single Location account #{a0} being merged into #{a1}"
    STDERR.puts "\tERROR: Double-merge! #{tmp}" if sl_accounts[tmp].size > 1
    a0 = get_bill_code(a0)
  end
  a1 = get_bill_code(a1) if acct_is_a?(a1) == 'S'
  puts "EXECUTE @RC = [arborWell_MergeToLocation] '#{a0}', '#{a1}', 0"
  
end

write_json_file("pdl_merge.err", err_accounts)
write_json_file("pdl_merge.sla", sl_accounts)
