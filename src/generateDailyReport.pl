#!/usr/bin/perl -w
# #####################################################################################################
#    Script:
#   	generateDailyReport.pl
#
#    Description:
#   	This script collect the data from DB and Logfile, based at shft.
#   	The idea is not split the routines in different files/scripts,
#   		because should be simple to adapt and use in another projects and situations.
#
#    Author:
#   	renanpelicari@gmail.com
#
#    Revision:
#   	1.1b	- 2016-08-12	- First stable version
#   	1.2b	- 2016-08-15	- Fixed some queries
#   	1.3b	- 2016-08-16	- Added function to generate html file with table
#   	1.4b	- 2016-08-17	- Added function to generate graphs (this one has a pre requirement: morris js)
#   	1.5b	- 2016-08-18	- Function to collect information from log file were added (not working yet)
#   	2.0b	- 2016-08-19	- Added comments and fixed the function to collect from logfile
#   	2.1b	- 2016-08-19	- Added queries and changed the css to be more clear the labels for graphs
#   	2.2b	- 2016-08-24	- Improvement in the way that graphs are being shown / Added some queries
#   	2.3b	- 2016-08-28	- Public and shared script
#       2.4b    - 2017-11-09    - Refactor script (split functions in files, generify the execution of scripts)
#
#    About graphs:
#   	To work the graphs in the HTML, you must use the Morris.js
#   	http://morrisjs.github.io/morris.js/
#
#    How TO Use:
#      You need to run in Linux or Unix like.
#      Also need to be prepared to run perl scripts.
#      A execute permission should be configured (chmod +x generateDailyReport.pl)
#      And to check how to use, you just need to view the help menu: ./generateDailyReport.pl -h
# #####################################################################################################

#############################################################################
# imports
#############################################################################

# import essential libs
use strict;
use warnings;
use Data::Dumper qw(Dumper);
use Switch;

# lib to use text format (color/bold)
use Term::ANSIColor qw(:constants);

# lib to handle date/time
use POSIX qw(strftime);

# lib to handle with database
use DBI;

# lib to get parameter options
use Getopt::Std;




#############################################################################
# golbal variables 
#############################################################################

# define the parameters that will be available
my %options=();
getopts('hs:b:d', \%options);

# define global var to debug mode
my $debug = false; 		# var for debug mode
my $lineDif = false;	# var to control the colored tr in table
my $graphCtrl = 0;		# counter for graphs, to use different numbers for divs and internal js ctrl


#############################################################################
# sub with a simple for to generate the same size for headers
#############################################################################
sub header
{
	my $strSeparator = $_[0];
	my $separator = "";

	for (my $i=0; $i < 67; $i++) {
		$separator .= $strSeparator;
	}

	print "\n".$separator."\n";
}

#############################################################################
# subroutine to exit the script
#############################################################################
sub quit
{
	header("=");
	print "\nBye...\n\n";
	exit;
}

#############################################################################
# subroutine to connect to database
#############################################################################
sub dbConnect
{
 	# execute connection
	my $db = DBI->connect( "dbi:Oracle:host=".SERVER_IP.";sid=".DB_SID.";port=".SERVER_PORT."", "".DB_USER."/".DB_PASS."" )
				|| die( $DBI::errstr . "\n" );
		$db->{AutoCommit}    = 0;
		$db->{RaiseError}    = 1;
		$db->{ora_check_sql} = 0;
		$db->{RowCacheSize}  = 16;

	# return connection var
	return $db;
}

#############################################################################
# subroutine to close the database connection
#############################################################################
sub dbDisconnect
{
	# received the db var
	my $db = $_[0];

	# execute the command to disconnect
	$db->disconnect if defined($db);
}

#############################################################################
# subroutine to set the session to handling with date easily
#############################################################################
sub dbAlterSession
{
	my $db = $_[0];

	my $query = "ALTER SESSION SET NLS_TIMESTAMP_FORMAT = '".DB_TIMESTAMP_FORMAT."'";
	if ($debug) { showDebug("Alter Session to set the timestamp properly to handle", $query); }
	my $def = $db->prepare($query);
	$def->execute();
}

#############################################################################
# subroutine to show the help
#############################################################################
sub help
{
	header("=");
	print "SCRIPT:";
	print "\n\tgenerateDailyReport.pl";
	print "\n\nDESCRIPTION:";
	print "\n\tScript to generate metrics of production day.";
	print "\n\nOPTIONS:";
	print "\n\t-h \t\t\t (help)";
	print "\n\t-s [integer] \t\t (Shift: 1 or 2 / 0 for all shifts)";
	print "\n\t-b [integer] \t\t (Days before)";
	print "\n\t-d \t\t\t (Debug Mode)";
	print "\n\nUSAGE:";
	print "\n\t[-h][-s 1][-s 2]";
	print "\n\nEXAMPLES:";
	print "\n\t./generateDailyReport.pl -h";
	print "\n\t./generateDailyReport.pl -s 1";
	print "\n\t./generateDailyReport.pl -s 2";
	print "\n\t./generateDailyReport.pl -s 1 -d";
	print "\n\t./generateDailyReport.pl -s 2 -b 2";
	print "\n\nVERSION:";
	print "\n\t2.3b\t- 2016-08-28";
	header("=");
	quit();
}

#############################################################################
# subroutine to show debug message
#############################################################################
sub showDebug
{
	my $message = $_[0];
	my $query = $_[1];

	if ($query) { $query =~ s/\t//g; }

	header("=");
	print "DEBUG MODE";
	print "\nINFO: \t".$message;
	if ($query) { print "\nQUERY: \n".$query.";"."\n"; }
	header("=");
	print "\n";
}

#############################################################################
# subroutine to show the wrong messages
#############################################################################
sub wrongUsage
{
	my $errorMsg = $_[0];

	header("=");
	print "ERROR: \t\tWrong option or value.";
	print "\nMESSAGE: \t".$errorMsg;
	print "\nTODO: \t\tPlease check the options and examples on the menu!";
	header("=");
	print "\n";
	help();
}

#############################################################################
# subroutine to show file results
#############################################################################
sub showFiles
{
	my $resultFile = $_[0];

	header("=");
	print BOLD, RED, "> Generated files:", RESET;
	print "\n\t".$resultFile;
	header("=");
	print "\n";
}

#############################################################################
# subroutine to create file
#############################################################################
sub createFile
{
	my $content = $_[0];
	my $file = $_[1];
	my $filename = "";

	chomp $content;

	my $date =  `date +%Y%m%d-%H%M%S`;
	chomp $date;


	if ($debug) { 
		print "\nRESULT:";
		header("=");
		print $content;
		header("=");
	}

	$filename = $file."_".$date.".html";
	chomp $filename;

	system("touch $filename");

	open(my $fh, '>:encoding(UTF-8)', $filename)
  		or die "Could not open file '$filename'";

  	print $fh $content;
  	close $fh;

  	return $filename;
}

#############################################################################
# sub to handle with days are less than 10
# to guarantee 2 digits
#############################################################################
sub handleDay
{
	my $day = $_[0];

	$day = ($day < 10) ? "0".$day : $day;

	return $day;
}

#############################################################################
# generate between date to use in the queries
# based on the constants and alter session
#############################################################################
sub generateBetweenDate
{
	my $shift = $_[0];
	my $daysBefore = $_[1];
	
	my $between_date_a = "";
	my $between_date_b = "";

	my $year = strftime "%Y", localtime;
	my $mon = strftime "%m", localtime;
	my $day = strftime "%d", localtime;
	my $hour = strftime "%H", localtime;

	$day = ($daysBefore ne 0) ? $day - $daysBefore : $day;

	$day = handleDay($day);

	my $today = $year."-".$mon."-".$day;

	if ($shift eq 1) {
		$between_date_a = $today." ".TIME_SHIFT_01_START;
		$between_date_b = $today." ".TIME_SHIFT_01_FINISH;
	} else {
		if (($daysBefore ne 0) || (($hour >= 0) && ($hour <= 7))) {

			($day eq 1) ? $mon-- : $day--;
			
			$day = handleDay($day);
			my $yesterday = $year."-".$mon."-".$day;

			$between_date_a = $yesterday." ".(($shift eq 2) ? TIME_SHIFT_02_START : TIME_SHIFT_01_START);
			$between_date_b = $today." ".TIME_SHIFT_02_FINISH;

		} else {
			
			$day++;
			$day = handleDay($day);
			my $tomorrow = $year."-".$mon."-".$day;

			$between_date_a = $today." ".(($shift eq 2) ? TIME_SHIFT_02_START : TIME_SHIFT_01_START);
			$between_date_b = $tomorrow." ".TIME_SHIFT_02_FINISH;
		}
	}

	print "\nStart at: \t".$between_date_a;
	print "\nFinish at: \t".$between_date_b."\n";

	return ($between_date_a, $between_date_b);
}

#############################################################################
# add line in the "table" to output on the server
#############################################################################
sub addTableLine
{
	my @columns = @{$_[0]};

	foreach (@columns) {
		if (defined($_)) {
			printf "+---------------------";
		}
	}
	print "+\n";
}

#############################################################################
# add info in the html tables, also show in the server
#############################################################################
sub addTableElement
{
	my @data = @{$_[0]};
	my $elementType = $_[1];

	my $fileContent = "";

	# check if the header will be for a header, otherwise a simple tr will be used
	$fileContent .= ($elementType eq "header") ? handleHTML("line_head_ini") : handleHTML("line_ini");
	foreach (@data) {
		if (defined($_)) {
			printf "| %-20s", $_;
			$fileContent .= handleHTML("col_ini");
			$fileContent .= $_;
			$fileContent .= handleHTML("col_end");
		}
	}

	# close the tr
	$fileContent .= handleHTML("line_end");
	
	print "|\n";
	return $fileContent;
}

#############################################################################
# sub to handle the html contents
# the js, css and html are in the cases
# the html should be AVOID in the rest of script, so put the HTML HERE
#############################################################################
sub handleHTML
{
	my $element = $_[0];
	my $value = $_[1];
	my $content = "";

	switch ($element) { 
		case "html_ini" {
			$content = "<!doctype html>";
		}
		case "define_graphs" {
			$content = "<script src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.0.3/jquery.min.js'></script>";
			$content .= "<script src='http://cdnjs.cloudflare.com/ajax/libs/raphael/2.1.2/raphael-min.js'></script>";
			$content .= "<script src='morris/morris.js'></script>";
			$content .= "<script src='http://cdnjs.cloudflare.com/ajax/libs/prettify/r224/prettify.min.js'></script>";
			$content .= "<script src='morris/examples/lib/example.js'></script>";
			$content .= "<link rel='stylesheet' href='morris/examples/lib/example.css'>";
			$content .= "<link rel='stylesheet' href='http://cdnjs.cloudflare.com/ajax/libs/prettify/r224/prettify.min.css'>";
			$content .= "<link rel='stylesheet' href='morris/morris.css'>";
		}
		case "set_css" {
			$content = "<style type='text/css'>";
			$content .= "
				table {
					table-layout:fixed;
					width: 100%;
					border: 1px solid #ccc;
				}
				table tr {
					border: 1px solid #ccc;
				}
				table tr td { 
					background: #fff;
					font-family: tahoma;
					font-size: 12px;
					color: #585858;	
				} 
				table tr.dif td {
					background: #f5f5f5; 
					font-family: tahoma;
					font-size: 12px;
					color: #585858;	
				}
				table tr.head td {
					background: #BDBDBD; 
					font-family: tahoma;
					font-size: 14px;
					color: #424242;
				}
				.page {
					height: 1150px;
				}
				h1 {
					font-family: tahoma;
					font-size: 22px;
					color: #424242;	
				}";
			$content .= "</style>";
		}
		case "head_ini" {
			$content = "<head>";
		}
		case "head_end" {
			$content = "</head>";
		}
		case "body_ini" {
			$content = "<body>";
		}
		case "body_end" {
			$content = "</body>";
		}
		case "table_ini" {
			$content = "<table cellpadding='4px' cellspacing='0px'>";
		}
		case "table_end" {
			$content = "</table>";
		}
		case "line_head_ini" {
			$content = "<tr class='head'>";
		}
		case "line_ini" {
			if ($lineDif) {
				$content = "<tr class='dif'>";
				$lineDif = false;
			} else {
				$content = "<tr>";
				$lineDif = true;
			}
		}
		case "line_end" {
			$content = "</tr>";
		}
		case "col_ini" {
			$content = "<td>";
		}
		case "col_end" {
			$content = "</td>";
		}
		case "header_01" {
			$content = "<h1>".$value."</h1>";
		}
		case "div_graph_ini" {
			$content = "<div id='graph_".$value."'></div>";
			$content .= "<script type=\"text/javascript\">";
		}
		case "div_page_ini" {
			$content = " <div class=\"page\">";
		}
		case "div_page_end" {
			$content = " </div>";
		}
		case "blank_line" {
			for (my $i=0; $i < $value; $i++) {
				$content = "<br/>";
			}
		}
		case "div_graph_end" {
			$content = "</script>";
		}
		else { wrongUsage("The html sintaxe does not exists! Contact the administrator."); }
	}

	return $content;
}

#############################################################################
# sub to set the graphs
# this will only works with the Morris.js
#############################################################################
sub setGraphs
{
	# my @content = @{$_[0]};
	my $sth = $_[0];
	my $graphType = $_[1];
	my $goal = $_[2];
	my $arraySize = $_[3];
	my @graphColumns = @{$_[4]};
	my $fileContent = "";

	if ($graphType eq 'line') { $graphType = "Line"; }
	if ($graphType eq 'bar') { $graphType = "Bar"; }

	# counter to handle the different graphs in the same html file
	$graphCtrl++;

	# add a graph div
	$fileContent .= handleHTML("div_graph_ini", $graphCtrl);

	# start to add the content of graph
	$fileContent .= "Morris.".$graphType."({";
	$fileContent .= "element: 'graph_".$graphCtrl."',";
	$fileContent .= "data: [";

	my $j = 0;
	while (my @data = $sth->fetchrow_array()) {
	#foreach my $data (@content) {
		my $i = 0;
	
		foreach my $elem (@data) {
		#foreach my $elem (@$data) {
			if ($i eq $graphColumns[0]) { $fileContent .= "{y:'".$elem; }
			if ($i eq $graphColumns[1]) { 
				$fileContent .= ($goal) ? "', a: '".$goal."', b: ".$elem : "', a: ".$elem;	
			}
			$i++;
		}

		$j++;
		if ($j eq $arraySize) {
			$fileContent .= "}";
		} else {
			$fileContent .= "}, ";
		}
	}

	$fileContent .= "],
						xkey: 'y',
						lineColors: ['#20457a', '#7dba27', '#af3d4a'],
						 barColors: ['#20457a','#7dba27','#af3d4a'],
						parseTime: false,";
	$fileContent .= ($goal) ? "	ykeys: ['a', 'b']," : "ykeys: ['a'],";
	$fileContent .= ($goal) ? "	labels: ['Goal', 'Reached']" : "labels: ['Reached']";
	$fileContent .=" , hideHover: 'always', xLabelAngle: 60";
	$fileContent .=" }).on('click', function(i, row){
					console.log(i, row);
					});";
	# end the content of graph

	$fileContent .= handleHTML("div_graph_end");

	return $fileContent;
}

#############################################################################
# sub to execute the queries
#############################################################################
sub executeQuery
{
	my $query = $_[0];
	my @columns = @{$_[1]};
	my $graphType = $_[2];
	my $goal = $_[3];
	my @graphColumns = @{$_[4]};

	my $fileContent = "";
	my $sth = "";

	my $db = dbConnect();
	dbAlterSession($db);
	
	if ($debug) { showDebug("Getting info from DB", $query); }

	# check if the constant to set graphs is true
	if (SET_GRAPHS) {
		$sth = $db->prepare($query);
		$sth->execute();

		my $cnt = $db->prepare($query);
		my $arraySize;
		$cnt->execute();

		# execute the query to get the quantity of rows
		while ( my @data = $cnt->fetchrow_array() ) { $arraySize = $cnt->rows; }

		# call the sub to set the graphs
		#my @row = $sth->fetchrow_array();
		$fileContent .= setGraphs($sth, $graphType, $goal, $arraySize, \@graphColumns);
	}

	# call the table definitions
	$fileContent .= handleHTML("table_ini");

	print "\n\n";
	# add the first lines according with the quantity of array / lines with dashes ---
	addTableLine(\@columns);

	# add the content for header
	$fileContent .= addTableElement(\@columns, "header");

	# add more lines with dash ---
	addTableLine(\@columns);

	$sth = $db->prepare($query);
	$sth->execute();
	while ( my @data = $sth->fetchrow_array() ) {
		# add content for tables
		$fileContent .= addTableElement(\@data, "element");
	}

	# add more lines with dash ---
	addTableLine(\@columns);

	dbDisconnect($db);
	print "\n";

	$fileContent .= handleHTML("table_end");

	return $fileContent;
}

#############################################################################
# execute commands in server
#############################################################################
sub executeCommand
{
	my $command = $_[0];
	my $result = "";

	$result = `$command`;

	# remove the blank space
	chomp $result;
	$result =~ s/\t//g;;

	return $result;
}

# handle log files
sub handleLogs
{
	my $logname = "";
	my $fileContent = "";
	my $title = "Logs from server";
	my @columns = ("Info", "Quantity");
	my $graphType = "bar";
	my $goal;
	my $arraySize = 2;

	# loop to collect all the lognames that need to be executed
	$logname = LOG_FILE_APPLICATION.LOG_FILENAME;

	# array with commands to get logs from server
	# this array is composed with 2 columns
	# first one: The name that will be shown in the result / Kind of alias
	# second one: the command
	# if you need add more elements here, you need to guarantee the last element will not have a comma
	#
	# example with less info, to be more clear:
	# my @info = (
	# 	["title",
	#		"command"],
	# 	["title",
	#		"command"],
	# 	["title",
	#		"command"],
	# 	["title",
	#		"command"]
	# );
	my @info = (
		["Server Down",
			"grep \"Connection refused\" ".$logname." | cut -d: -f1 | wc -l;"],
		["WMS / Conn Failed",
			"grep -e \"Trying to reestablish connection\" ".$logname." | wc -l"]
	);

	my @result;
	my $i = 0;
	my $j = 0;

	# for each element in the array, do:
	for my $row (@info) {
		# for each element in a row of array, do:
		for my $element (@$row) {
			if ($i eq 1) {
				# if is the second element, call the sub to execute the command on the server
				# save the result in another array, that will be used to output results
				$result[$j][$i] = executeCommand($element);
			} else {
				# else, save the title another array, that will be used to output results
				$result[$j][$i] = $element;
			}

			$i++;
		}
		$i = 0;
		$j++;
	}

	# starting to create html content
	$fileContent .= handleHTML("div_page_ini");
	$fileContent .= handleHTML("header_01", $title);

	# check if the constant to set graphs is true
	if (SET_GRAPHS) {
		# call the sub to set the graphs
		#$fileContent .= setGraphs(\@result, $graphType, $goal, $arraySize, \@columns);
	}

	header("=");
	print BOLD, YELLOW, "> ".$title, RESET;

	# call the table definitions
	$fileContent .= handleHTML("table_ini");

	print "\n\n";
	# add the first lines according with the quantity of array / lines with dashes ---
	addTableLine(\@columns);

	# fill with the header content
	$fileContent .= addTableElement(\@columns, "header");
	# add more lines with dash ---
	addTableLine(\@columns);
	
	# foreach element in the result array, do:
	foreach my $array (@result) {
		# fill with the content
		$fileContent .= addTableElement($array, "element");
	}

	# add more lines with dash ---
	addTableLine(\@columns);

	$fileContent .= handleHTML("table_end");
	$fileContent .= handleHTML("div_page_end");

	return $fileContent;
}

#############################################################################
# handle with queries
# each query are in the case
#############################################################################
sub handleReport
{
	my $query_id = $_[0];
	my $date_a = $_[1];
	my $date_b = $_[2];
	my $query;
	my $title;
	my @columns;
	my @graphColumns = (0,1);
	my $graphType;
	my $goal;
	my $fileContent;

	header("=");

	# set query
	# to add new query, you just need to add a new case
	# elements:
	#	- the name in the case will be used in the call
	#	- $title: title, in the html will be used betwwen h1 tag
	#	- @columns: alias for column that will be retrieve from DB
	#				this array is also important to define how many times the td will be included in the table
	#	- $graphTYpe: options are bar and line
	#	- @graphColumns: you can chose the fields that will be shown in the graphs / default is 0,1
	#				IMPORTANT to know: the graphs are prepared to show just 2 columns, you can show more in the tables, but in the graphs just 2
	# 	- $query:	db query
	#				IMPORTANT to know: you can use the date between date_a and date_b
	# WARNING 01: if the graphs did not work, check if the quantity is the second column and the label is the first one
	# WARNING 02: do not insert after the else
	switch ($query_id) {
		case "tasks_worked" {
			$title = "Tasks that were worked during the shift";
			@columns = ("Status", "Quantity"); 
			$graphType = "bar";
			$query = "
				select status, count(*) quantity
				from tasks 
				where date_performed between '".$date_a."' and '".$date_b."'
				group by status";
		}
		case "overview_by_status" {
			$title = "Overview tasks by status";
			@columns = ("Status", "Quantity"); 
			$graphType = "bar";			
			$query = "
				select status, count(*) quantity
				from tasks 
				group by status";
		}
		else { wrongUsage("The report requested does not exists! Contact the administrator."); }
	}

	print BOLD, YELLOW, "> ".$title, RESET;

	$fileContent = handleHTML("div_page_ini");
	$fileContent .= handleHTML("header_01", $title);
	$fileContent .= executeQuery($query, \@columns, $graphType, $goal, \@graphColumns);
	$fileContent .= handleHTML("div_page_end");
	return $fileContent;
}

#############################################################################
# execute the report 
# call the subs to define and execute queries and get logs from server
#############################################################################
sub execute
{
	my $shift = $_[0];
	my $daysBefore = $_[1];
	my $title = "";
	my $query = "";
	my $fileContente = "";
	my $resultFile = "";

	# definitions for html report (eg: head, body, css, js)
	$fileContente .= handleHTML("html_ini");
	$fileContente .= handleHTML("head_ini");
	$fileContente .= (SET_GRAPHS) ? handleHTML("define_graphs") : "";
	$fileContente .= handleHTML("set_css");
	$fileContente .= handleHTML("head_end");
	$fileContente .= handleHTML("body_ini");

	header("=");
	print "Shift: \t\t".$shift;

	# generate between date
	my ($between_date_a, $between_date_b) = generateBetweenDate($shift, $daysBefore);

	# call the sub to handle with queries
	$fileContente .= handleReport("tasks_worked", $between_date_a, $between_date_b);
	$fileContente .= handleReport("overview_by_status");

	# call the sub to handle with logs
	$fileContente .= handleLogs();

	# end the html
	$fileContente .= handleHTML("body_end");

	# generate the html file
	$resultFile = createFile($fileContente, HTML_REPORT_NAME);

	return $resultFile;
}

#############################################################################
# main function
# this one checks the parameters that was informed for script
#############################################################################
sub main
{
	# check if the parameter to show menu was used
	if (defined($options{h})) {
		help();
	}

	# check if the parameter debug was informed
	if (defined($options{d})) {
		$debug = true;
	}

	my $daysBefore = 0;
	# check if the report should be for some days before
	if (defined($options{b})) {
		$daysBefore = $options{b};
		chomp $daysBefore;
	}

	# check the shift that were informed
	if (defined($options{s})) {
		my $shift = $options{s};
		chomp $shift;

		if (($shift eq 0 || $shift eq 1 || $shift eq 2)) {

			my $resultFile = execute($shift, $daysBefore);
			showFiles($resultFile);
			quit();
		}

		wrongUsage("Wrong shift was informed. Only 1 and 2 are available!");
	}

	wrongUsage("None or wrong parameter was informed!");
}

# start script
main();
