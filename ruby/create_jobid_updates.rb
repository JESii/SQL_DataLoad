#!/usr/bin/env ruby
#
# Testing spreadsheet gem
# $CHANGE LOG:
# 2013-02-06 jes  - Add code to process tblAssignments and ttmpVisits_Rates as well
# 2013-02-09 jes  - Fix error in ttmpVisits_Rates column names (caused complete failur)
#                 - Don't replace with zeros; instead print error message and counter
#                 - Fix Old_POS value; no longer have column 'L' in latest s/sheet
# $END LOG:
#
require 'spreadsheet'
require 'flt'
include Flt
require 'pp'
def define_excel_columns()
  num = -1
  for i in ('A'..'AZ').to_a
   eval "#{i} = (num += 1)"
  end
end
@@row_count = 0
define_excel_columns

JobID_Fixup = Struct.new(:jobid, :clientid, :client_name, :action, :status, :new_pos_number,
                          :old_pos_number)
def make_jobid_fixup(row)
  JobID_Fixup.new(
    row[A].to_i,    # JobID /A/
    row[C].to_i,    # ClientID /C/
    row[D],         # ClientName /D/
    row[E],         # Action /E/
    row[F],         # Status /F/
    row[G].to_i,    # New POS # /G/
    row[R]          # old_pos_number
  )
end
def generate_script_start()
return <<EOF
USE XYZBTRS_SQL
DECLARE @tmp INT
PRINT 'Merging JobIDs may be problematic because of doubled Allotter hours?'
DECLARE @delete_count INT = 0
DECLARE @merge_count INT = 0
DECLARE @merge_poscontracts_count INT = 0
DECLARE @merge_poshrs_count INT = 0
DECLARE @merge_visits_count INT = 0
DECLARE @merge_zeros_count INT = 0
DECLARE @merge_assignments_count INT = 0
DECLARE @change_pos_count INT = 0
DECLARE @change_pos_poscontracts_count INT = 0
DECLARE @change_pos_poshrs_count INT = 0
DECLARE @change_pos_visits_count INT = 0
DECLARE @change_pos_assignments_count INT = 0
DECLARE @change_zeros_count INT = 0
DECLARE @delete_error_count INT = 0
EOF
end

def generate_delete_job(jobid)
  return <<-EOF
  ----------------------
  BEGIN     -- Row #{@@row_count}
  SET @tmp = (select count(*) from tblVisits V where V.JobID = #{jobid}) 
  IF @tmp = 0
  BEGIN
    delete tblPOSContracts where JobID = #{jobid}
    delete tblPOSHrs where JobID = #{jobid}
    delete tblAssignments where JobID = #{jobid}
    PRINT '==>JobID #{jobid} (row #{@@row_count}) deleted '
    SET @delete_count = @delete_count +1
  END
  ELSE
  BEGIN
    PRINT '==>JobID #{jobid} (row #{@@row_count}) not deleted; active in tblVisits'
    SET @delete_error_count = @delete_error_count +1
  END
  END  
  EOF
end

def generate_merge_job_into_client(jobid, clientid)
  if clientid == 0 || jobid == 0 then
    return <<-EOF
    PRINT '==>Ignoring row #{@@row_count}: merge zero values POS Number #{clientid} or JobID #{jobid}'
    SET @merge_zeros_count += 1
    EOF
  end
  return <<-EOF
  ----------------------
  BEGIN     -- Row #{@@row_count}
    update tblPOSContracts
      SET ClientID = '#{clientid}'
      WHERE JobID = '#{jobid}'
    SET @merge_poscontracts_count += @@ROWCOUNT  
    update tblPOSHrs
      SET ClientID = '#{clientid}'
      WHERE JobID = '#{jobid}'
    SET @merge_poshrs_count += @@ROWCOUNT  
    update tblVisits
      SET ClientID = '#{clientid}'
      WHERE JobID = '#{jobid}'
    update ttmpVisits_rates
      SET Client_ID = '#{clientid}'
      WHERE Job_ID = '#{jobid}'
    SET @merge_visits_count += @@ROWCOUNT  
    PRINT '==>JobID #{jobid} (row #{@@row_count}) merged into Client #{clientid}'
    SET @merge_count = @merge_count +1
  END
  EOF
end

def generate_change_job_pos_number(jobid, pos_number)
  if pos_number == 0 || jobid == 0 then
    return <<-EOF
    PRINT '==>Ignoring row #{@@row_count}: change zero values POS Number #{pos_number} or JobID #{jobid}'
    SET @change_zeros_count += 1
    EOF
  end
  return <<-EOF
  ----------------------
  BEGIN     -- Row #{@@row_count}
    update tblPOSContracts
      SET PONumber = '#{pos_number}'
      WHERE JobID = '#{jobid}'
    SET @change_pos_poscontracts_count += @@ROWCOUNT  
    update tblPOSHrs
      SET PONumber = '#{pos_number}'
      WHERE JobID = '#{jobid}'
    SET @change_pos_poshrs_count += @@ROWCOUNT  
    update tblAssignments
      SET PONumber = '#{pos_number}'
      WHERE JobID = '#{jobid}'
    SET @change_pos_assignments_count += @@ROWCOUNT  
    update tblVisits
      SET PONumber = '#{pos_number}'
      WHERE JobID = '#{jobid}'
    update ttmpVisits_Rates
      SET PO_Number = '#{pos_number}'
      WHERE Job_ID = '#{jobid}'
    SET @change_pos_visits_count += @@ROWCOUNT  
    PRINT '==>JobID #{jobid} (row #{@@row_count}) changed to POS ##{pos_number}'
    SET @change_pos_count = @change_pos_count +1
  END
  EOF
end
def generate_script_end()
  return <<-EOF
  -----------------------
  print '==> Records deleted................' + SQL#.String_PadLeft(@delete_count,8,' ')
  print '==> Delete errors (not deleted)....' + SQL#.String_PadLeft(@delete_error_count,8,' ')
  print '==> Records merged.................' + SQL#.String_PadLeft(@merge_count,8,' ')
  print '==> POSContracts merged............' + SQL#.String_PadLeft(@merge_poscontracts_count,8,' ')
  print '==> Assignments merged.............' + SQL#.String_PadLeft(@merge_assignments_count,8,' ')
  print '==> POSHrs merged..................' + SQL#.String_PadLeft(@merge_poshrs_count,8,' ')
  print '==> Visits merged..................' + SQL#.String_PadLeft(@merge_visits_count,8,' ')
  print '==> Merges ignored (zeros).........' + SQL#.String_PadLeft(@merge_zeros_count,8,' ')
  print '==> Jobs changed (new POS#)........' + SQL#.String_PadLeft(@change_pos_count,8,' ')
  print '==> POSContracts changed (new POS#)' + SQL#.String_PadLeft(@change_pos_poscontracts_count,8,' ')
  print '==> Assignments changed (new POS#) ' + SQL#.String_PadLeft(@change_pos_assignments_count,8,' ')
  print '==> POSHrs changed (new POS#)......' + SQL#.String_PadLeft(@change_pos_poshrs_count,8,' ')
  print '==> Visits changed (new POS#)......' + SQL#.String_PadLeft(@change_pos_visits_count,8,' ')
  print '==> Changes ignored (zeros)........' + SQL#.String_PadLeft(@change_zeros_count,8,' ')
  EOF
end

filename = ARGV[0]
DecNum.context.precision = 2
record_count = total_hours = total_amount = 0 #; total_amount = DecNum.new(0)
book = Spreadsheet.open(filename)
sheet = book.worksheet("Job Orders")
outfile = open('apply_jobid_fixup_data.sql', 'w')
outfile.puts generate_script_start()
client_id =''
begin
  sheet.each do |row|
    @@row_count += 1
    jf = make_jobid_fixup(row)
    case 
    when jf[:action] =~ /^[Kk]eep$/ && jf[:old_pos_number] == jf[:new_pos_number]
      puts "Keeping job ##{jf[:jobid]} 'as is'"
    when jf[:action] =~ /^[Kk]eep$/ && jf[:old_pos_number] != jf[:new_pos_number]  
      puts "Change job ##{jf[:jobid]} to POS##{jf[:new_pos_number]}"
      outfile.puts generate_change_job_pos_number(jf[:jobid], jf[:new_pos_number])
    when jf[:action] =~ /^[Mm]erge$/
      puts "Merging job ##{jf[:jobid]} into ???"
    when jf[:action] =~ /^[Dd]elete$/
      puts "Deleting job ##{jf[:jobid]}"
      outfile.puts generate_delete_job(jf[:jobid])
    when jf[:action] =~ /^\s*$/ || jf[:action].nil?
      next
    when jf[:action] =~ /^[Mm]erg.*?(?<client_id>\d+)$/
      # For some reason, client_id is not getting set as expected
      # puts "Merging #{jf[:jobid]} into #{client_id}"
      client_id = jf[:action].scan(%r/\d+/)[0].to_i
      puts "Merging job ##{jf[:jobid]} into client ##{client_id}"
      outfile.puts generate_merge_job_into_client(jf[:jobid], client_id)
    else
      puts "Unknown action #{jf[:action]}"
    end
  end
  outfile.puts generate_script_end()
  outfile.close
end

print "finished"
