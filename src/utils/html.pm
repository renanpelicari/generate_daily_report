sub startHtml() {
    return "<!doctype html>";
}

sub closeHtml() {
    return "</html>";
}

sub startHeader() {
    return "<head>";
}

sub finishHeader() {
    return "</head>";
}

sub startBody() {
    return "<bod>";
}

sub finishBody() {
    return "</body>";
}

sub applyHeader() {
    return "<h1>".$_[0]."</h1>";
}
