#SQL DataLoad Project

This project is an ETL (Extract-Transform-Load) project to convert a live database to a new system.

It took as input: 

* an existing MS SQL Server Database representing the live system; 
* several production Excel files containing accounting information (i.e., invoicing and payments). The conversion process covered over a year of live operation, so the historical files, contained in a nested directory structure, had to be found, parsed, and processed for the information they contained; 
* a number of special Excel 'fixup' files (created to deal with bad data in the SQL Server tables; these were parsed by ruby scripts which converted the detailed information into a SQL script to apply the corrections to the live database before the actual conversion process).
and created the new database, properly defined and related.

Some of the issues that had to be dealt with included:

* Multiple individuals assigned the same ids in the original database; thus, James Smith and Jesse James could all have the ID 12345
* Ids and names were changed at various times without correcting the existing data
* The only reference between the tables and the external spreadsheets was individual's names, which had many mis-spellings and typos. I.e., one part of the system might use the name 'James Smith', whereas external systems might refer to that individual using the name 'James S Smith', 'James S. Smith', 'James Smith Jr.', etc...  This required special processing to 'normalize' the names and improve the percentage matched.
* During the original creation of the live system, not all records could be captured (data errors, typos, missing data,...) and thus it was incomplete. However, other instances of that data did appear in several external, related systems.

The goal was to correct as many of these errors as possible and to clearly identify any missing data.

##Languages Used
* Windows CMD scripts to drive the process
* Ruby to process the external spreadsheets and perform other tasks such as generating SQL scripts fo data fixups from the spreadsheets
* SQL scripts to perform the data conversion

Along the way, a number of one-off tests were run to determine precisely how various programs handled specific error or unusual conditions. These simple test scripts are included in the event they help someone else.

##Design Approach
The entire process was designed so that the conversion could be re-run as many times as necessary against a clean/updated database.
This is in contrast to the approach followed in some other conversions where data is converted once to spreadsheets in a 'standard' format
and then changes to the original database are processed manually. The output database structure was originally provided as MySQL statements,
so these were converted to MS SQL Server format (via a ruby script) as part of the initial handiling. Since this was run in a Windows environment, the process was
executed through a series of CMD files to drive the process. A single CMD file - createmors.cmd - drives the entire process. At a few points
in the process, the SQL Server database instance is restarted; this was done to avoid problems wherein MS SQL Server would hang for no 
apparent reason. Also notice that the free version of the SQLSharp extension was used: this is an awesome library for MS SQL Server users - highly
recommended! 

Overall, the process was designed to be quite chatty and all output was redirected to various .out files for subsequent review. [Note that some of these files are provided; however, sever

##Process
The overall sequence runs as follows:

###Manual
* Restore the conversion database from the current production database
* Run the CREATEMORS\_SQLSHARP.CMD to install the extension

###CREATEMORS.CMD
* Ensure that the SQLSharp extension has been loaded
* Run CREATEMORS1.CMD to perform the basic creation/conversion
    * Run various data fixup procedures
    * Create some basic views and new client tables
    * Insert data into the tables
    * Test the various tables for accuracy / completeness
    * Start the invoice/payment (remittance) processing
* Run CREATEMORS2.CMD to incorporate the invoice/payment data from external spreadsheets and produce final statistics
   * Process the remittance data and update output tables with data acquired from this step
   * Export data for missing information
   * Print summary statistics & error information

At several points throughout the process, ruby scripts were created to process data in the Excel spreadsheets and perform various conversion tasks.

##Results
Output from the various steps was redirected to a variety of .out files, so that the intermediate results could be examined and changes made. 
Numerous errors were tracked throughout the process and matched back to external information about the database contents. In the end,
not all errors could be handled: aproximately 1.5% of the data could not be matched, due to poor data quality in the original database,
and had to be handled through an external, manual process.
