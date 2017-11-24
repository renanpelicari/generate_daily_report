# #####################################################################################################
# 	Script:
# 		graphHandler.pm
#
# 	Description:
#		This script contains subroutines to handle with graphs
#
# 	Author:
#		renanpelicari@gmail.com
#
#   About graphs:
#   	Framework used: Morris.JS
#   	http://morrisjs.github.io/morris.js/
#
#	Revision:
#		1.0b	- 2017-11-13	- First version
#
# #####################################################################################################

package graphHandler;

#############################################################################
# imports essentials
#############################################################################
use strict;
use warnings;
use Exporter qw(import);

# include definitions
use globalDefinitions qw(true);

require 'htmlGraphDefine.pm';

#############################################################################
# routine to get global graph counter and increment new one
#
# return:
#   int with global graph counter
#############################################################################
sub getGraphCounter {
    return ++$globalDefinitions::_GLOBAL_GRAPH_COUNTER;
}

#############################################################################
# sub to populate the graphs
# this will only works with the Morris.js
#
# params:
#   $graphType          -> type of graph (accepted values: Line or Bar)
#   @columns            -> containing columns
#   @values             -> containing value list, and the parameters of
#                          each element should be the same of @columns
#   $goal               -> boolean to say if show the target or not
#   $graphCtrl          -> used to create divs for each graph element
#
# return:
#   string containing html content to build graph
#############################################################################
sub getGraphContent {
    my $graphType = $_[0];
    my @values = @{$_[1]};
    my $goal = $_[2];

    my $graphCtrl = "graph-".getGraphCounter();

    # add a graph div
    my $fileContent = htmlGraphDefine::getDivStart($graphCtrl);

    # start to add the content of graph
    $fileContent .= "Morris.".$graphType."({ element: '".$graphCtrl."', data: [";

    my $j = 0;
    foreach my $data (@values) {
        my $i = 0;

        if ($graphType eq 'Donut') {
            foreach my $line (@{$data}) {
                my @elem = $line;
                $fileContent .= "{label:'".$elem[0].", value:".$elem[1]."}";
                $fileContent .= ($i ne $#values) ? "," : "";
                $i++;
            }
        } else {
            foreach my $elem (@{$data}) {
                if ($i eq 0) {
                    $fileContent .= "{y:'".$elem;
                } elsif ($i eq 1 && $#values > 1) {
                    $fileContent .= ($goal) ? "', a: '".$goal."', b: ".$elem : "', a: ".$elem;
                }
            }
            $i++;
            $fileContent .= "}";

            if ($#values eq $j) {
                $fileContent .= ", ";
            }
        }
        $j++;
    }

    $fileContent .= "], xkey: 'y',
                    lineColors: ['#20457a', '#7dba27', '#af3d4a'],
					barColors: ['#20457a','#7dba27','#af3d4a'],
					parseTime: false,";
    if ($goal) {
        $fileContent .= " ykeys: ['a', 'b'], labels: ['Goal', 'Reached']";
    } else {
        $fileContent .= " ykeys: ['a'], labels: ['Reached']";
    }
    $fileContent .= " , hideHover: 'always', xLabelAngle: 60 }).on('click', function(i, row){ console.log(i, row);});";

    $fileContent .= htmlGraphDefine::getDivClose();

    return $fileContent;
}

#############################################################################
return true;
