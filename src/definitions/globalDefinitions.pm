# #####################################################################################################
# 	Script:
# 		globalDefinitions.pm
#
# 	Description:
#		This script just define the global constants
#
# 	Author:
#		renanpelicari@gmail.com
#
#	Revision:
#		1.0b	- 2017-11-09	- First version
#
# #####################################################################################################

package globalDefinitions;

#############################################################################
# imports essentials
#############################################################################

use strict;
use warnings;
use Exporter qw(import);

#############################################################################
# define constants
#############################################################################

# define bool constants
use constant false => 0;
use constant true => 1;

# separator definitions
use constant HEADER_SEPARATOR_SIZE => 67;
use constant DEFAULT_SEPARATOR => "=";

# global variables
our $_DEBUG_MODE = false; # debug mode on/off
our $_GLOBAL_GRAPH_COUNTER = 0; # counter for graphs

#############################################################################
# export constants/variables
#############################################################################
our @EXPORT = ($_GLOBAL_GRAPH_COUNTER);
our @EXPORT_OK = qw(false true HEADER_SEPARATOR_SIZE DEFAULT_SEPARATOR);

#############################################################################
return true;
