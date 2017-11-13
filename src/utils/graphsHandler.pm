use strict;
use warnings;
use Exporter qw(import);

require 'htmlGraphs.pm';

#############################################################################
# sub to set the graphs
# this will only works with the Morris.js
#############################################################################
sub setGraphs {
    my $graphType = $_[0];
    my @columnsToShow = @{$_[1]};
    my @values = @{$_[2]};
    my $goal = $_[3];
    my $graphCtrl = $_[4];

    # add a graph div
    my $fileContent = htmlGraps::startDiv($graphCtrl);

    # start to add the content of graph
    $fileContent .= "Morris.".$graphType."({ element: 'graph_".$graphCtrl."', data: [";

    my $j = 0;
    foreach my $data (@values) {
        my $i = 0;

        foreach my $elem (@{$data}) {
            if ($i eq $columnsToShow[0]) {$fileContent .= "{y:'".$elem;}
            if ($i eq $columnsToShow[1]) {
                $fileContent .= ($goal) ? "', a: '".$goal."', b: ".$elem : "', a: ".$elem;
            }
            $i++;
        }

        $fileContent .= "}";

        if ($#values eq $j) {
            $fileContent .= ", ";
        }
        $j++;
    }

    $fileContent .= "], xkey: 'y', lineColors: ['#20457a', '#7dba27', '#af3d4a'],
					 barColors: ['#20457a','#7dba27','#af3d4a'], parseTime: false,";
    if ($goal) {
        $fileContent .= " ykeys: ['a', 'b'], labels: ['Goal', 'Reached']";
    } else {
        $fileContent .= " ykeys: ['a'], labels: ['Reached']";
    }
    $fileContent .= " , hideHover: 'always', xLabelAngle: 60 }).on('click', function(i, row){ console.log(i, row);});";

    $fileContent .= htmlGraps::closeDiv();

    return $fileContent;
}
