sub startTable() {
    return "<table cellpadding='4px' cellspacing='0px'>";
}

sub closeTable() {
    return "</table>";
}

sub startHeaderLine() {
    return "<tr class='head'>";
}

sub closeHeaderLine() {
    return "</tr>";
}

# handle odd/even line (to change color)
sub startHeader() {
    if ($_[0]) {
        return "<tr class='diff'>";
    }
    return "<tr>";
}

sub closeLine() {
    return "</tr>";
}

sub applyColumn() {
    return "<td>".$_[0]."</td>";
}


