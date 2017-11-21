# #####################################################################################################
# 	Script:
# 		htmlGraphDefine.pm
#
# 	Description:
#		This script contains subroutines to define framework for graphs
#
# 	Author:
#		renanpelicari@gmail.com
#
#   About graphs:
#       Framework used: Morris.JS
#   	http://morrisjs.github.io/morris.js/
#
#	Revision:
#		1.0b	- 2017-11-13	- First version
#
# #####################################################################################################

package htmlGraphDefine;

#############################################################################
# imports essentials
#############################################################################
use strict;
use warnings;

#############################################################################
# Routine to get css and js imports for Morris Graphs
# The src links are external, so if you need to use locally, you can do this:
#   1. Download Morris Framework here:
#       https://github.com/morrisjs/morris.js/archive/0.5.1.zip
#   2. Create "lib" folder at root of project;
#   3. Extract contents of .zip into this lib folder;
#   4. Change src/rel ref in this routine to use from lib instead of web
#
# return:
#   string containing javascript and css imports
#############################################################################
sub getGraphImport {
    return "<link rel='stylesheet' href='//cdnjs.cloudflare.com/ajax/libs/morris.js/0.5.1/morris.css'>
            <script src='//ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js'></script>
            <script src='//cdnjs.cloudflare.com/ajax/libs/raphael/2.1.0/raphael-min.js'></script>
            <script src='//cdnjs.cloudflare.com/ajax/libs/morris.js/0.5.1/morris.min.js'></script>";
}

#############################################################################
# Routine to start and close div, and start script for Graph.
#
#  To build graph, you should follow this structure:
#   <div id='graph_88'></div>
#   <script type='text/javascript'>
#       <!-- contents of graph HERE -->
#   </script>
#
# Foreach graph, its necessary to have one different div (changing the id).
# So, you need to handle with id to inform for this routine...
#
# params:
#   $_[0]   -> graph id (unique)
#
# return:
#   string containing div and javascript reference
#############################################################################
sub getDivStart {
    return "<div id='".$_[0]."'></div>
            <script type=\"text/javascript\">";
}


#############################################################################
# Routine to close script.
#
# return:
#   string containing close script statement
#############################################################################
sub getDivClose {
    return "</script>";
}

#############################################################################
return 1;
