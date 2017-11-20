# #####################################################################################################
# 	Script:
# 		htmlStyleSheet.pm
#
# 	Description:
#		This script contains subroutines to define css
#
# 	Author:
#		renanpelicari@gmail.com
#
#	Revision:
#		1.0b	- 2017-11-13	- First version
#
# #####################################################################################################

package htmlStyleSheet;

#############################################################################
# imports essentials
#############################################################################
use strict;
use warnings;

#############################################################################
# Routine to get CSS definitions
#
# return:
#   string containing css definitions
#############################################################################
sub getCss() {
    return "<style type='text/css'>
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
				table tr.diff td {
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
				}
			</style>";
}

#############################################################################
return 1;

