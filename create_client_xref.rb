#!/usr/bin/env ruby

require 'pp'
load 'utility_module.rb'
include UtilityModule

ClientXref = Struct.new(:client_no, :btrs_client_name, :btrs_uci_match_name)
def make_xref(line)
  array = line.split("\t")
  ClientXref.new(
    array[0],
    array[1],
    x = create_btrs_match_name(array[1])
  )
end
outfile = File.open('export_client_xref.txt','w')
File.open('export_clients.txt','r').each_line do |line|
  ##pp line
  cx = make_xref(line)
  ##pp cx
  # Put in leading tab as place-holder for id
  outline = "\t" + cx.to_a.join("\t")
  outfile.puts outline
end

