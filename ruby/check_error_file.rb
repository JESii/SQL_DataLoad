#!/usr/bin/env ruby
#
require 'json'
require 'pp'

ARGV[0] =~ /([^_]*)$/
group_id = $1
json = File.read(ARGV[0])
if json.size == 0 then
  STDERR.puts "Empty file #{ARGV[0]}"
  groups= []
else
  groups = JSON.parse(json)
end
puts "The '#{group_id}' error list contains #{groups.size} groups"
puts "GROUP,ACCT_NO,BILL_CODE,MASTER,MERGE,COMPANY"
groups.each do |group|
  group.each do |row|
    puts "#{row[0]},#{row[1]},#{row[2]},#{row[3]},#{row[4]},\"#{row[5]}\""
  end
end


