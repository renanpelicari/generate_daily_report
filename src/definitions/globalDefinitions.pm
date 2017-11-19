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

# debug mode on/off
use constant DEBUG_MODE => false;

# separator definitions
use constant HEADER_SEPARATOR_SIZE => 67;
use constant DEFAULT_SEPARATOR => "=";

# global counter to avoid same graph name
our $_GLOBAL_GRAPH_COUNTER = 0;

#############################################################################
# export constants/variables
#############################################################################
our @EXPORT = qw($_GLOBAL_GRAPH_COUNTER);
our @EXPORT_OK = qw(false true DEBUG_MODE HEADER_SEPARATOR_SIZE DEFAULT_SEPARATOR);

#############################################################################
return true;
