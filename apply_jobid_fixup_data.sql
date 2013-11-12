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
    PRINT '==>Ignoring row 3: change zero values POS Number 0 or JobID 999'
    SET @change_zeros_count += 1
    PRINT '==>Ignoring row 4: change zero values POS Number 0 or JobID 998'
    SET @change_zeros_count += 1
    PRINT '==>Ignoring row 5: change zero values POS Number 0 or JobID 997'
    SET @change_zeros_count += 1
    -- More of the same until...
  ----------------------
  BEGIN     -- Row 35
    update tblPOSContracts
      SET PONumber = '99999999'
      WHERE JobID = '9999'
    SET @change_pos_poscontracts_count += @@ROWCOUNT  
    update tblPOSHrs
      SET PONumber = '99999999'
      WHERE JobID = '9999'
    SET @change_pos_poshrs_count += @@ROWCOUNT  
    update tblAssignments
      SET PONumber = '99999999'
      WHERE JobID = '9999'
    SET @change_pos_assignments_count += @@ROWCOUNT  
    update tblVisits
      SET PONumber = '99999999'
      WHERE JobID = '9999'
    update ttmpVisits_Rates
      SET PO_Number = '99999999'
      WHERE Job_ID = '9999'
    SET @change_pos_visits_count += @@ROWCOUNT  
    PRINT '==>JobID 9999 (row 35) changed to POS #99999999'
    SET @change_pos_count = @change_pos_count +1
  END
  ----------------------
  BEGIN     -- Row 36
    update tblPOSContracts
      SET PONumber = '99999999'
      WHERE JobID = '9998'
    SET @change_pos_poscontracts_count += @@ROWCOUNT  
    update tblPOSHrs
      SET PONumber = '99999999'
      WHERE JobID = '9998'
    SET @change_pos_poshrs_count += @@ROWCOUNT  
    update tblAssignments
      SET PONumber = '99999999'
      WHERE JobID = '9998'
    SET @change_pos_assignments_count += @@ROWCOUNT  
    update tblVisits
      SET PONumber = '99999999'
      WHERE JobID = '9998'
    update ttmpVisits_Rates
      SET PO_Number = '99999999'
      WHERE Job_ID = '9998'
    SET @change_pos_visits_count += @@ROWCOUNT  
    PRINT '==>JobID 9998 (row 36) changed to POS #99999999'
    SET @change_pos_count = @change_pos_count +1
  END
  ----------------------
  -- And more of the same for the same PONumber, different Job_ID
    PRINT '==>Ignoring row 66: change zero values POS Number 0 or JobID 997'
    SET @change_zeros_count += 1
    PRINT '==>Ignoring row 67: change zero values POS Number 0 or JobID 996'
    SET @change_zeros_count += 1
  ----------------------
  -- Lots more of the same
  ----------------------
  BEGIN     -- Row 1354
  SET @tmp = (select count(*) from tblVisits V where V.JobID = 59999) 
  IF @tmp = 0
  BEGIN
    delete tblPOSContracts where JobID = 59999
    delete tblPOSHrs where JobID = 59999
    delete tblAssignments where JobID = 59999
    PRINT '==>JobID 59999 (row 1354) deleted '
    SET @delete_count = @delete_count +1
  END
  ELSE
  BEGIN
    PRINT '==>JobID 59999 (row 1354) not deleted; active in tblVisits'
    SET @delete_error_count = @delete_error_count +1
  END
  END  
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
