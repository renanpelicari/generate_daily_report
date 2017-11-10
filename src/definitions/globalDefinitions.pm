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
# export constants/variables
#############################################################################
our @EXPORT = qw();
our @EXPORT_OK = qw(false true DEBUG_MODE);

#############################################################################
# define constants
#############################################################################

# define bool constants
use constant false => 0;
use constant true => 1;

# debug mode on/off
use constant DEBUG_MODE => false;

#############################################################################

return true;
