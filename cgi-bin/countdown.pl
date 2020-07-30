#!/usr/bin/perl
#======================================================================#
# Program => clock.pl (In Perl 5.0)                      version 0.0.1 #
#======================================================================#
# Autor => Fernando "El Pop" Romo                   (pop@cofradia.org) #
# Creation date => 26/jul/2020                                         #
#----------------------------------------------------------------------#
# Info => This program is a clock widget.                              #
#----------------------------------------------------------------------#
#        This code are released under the GPL 3.0 License.             #
#                                                                      #
#                     (c) 2020 - Fernando Romo                         #
#                                                                      #
# This program is free software: you can redistribute it and/or modify #
# it under the terms of the GNU General Public License as published by #
# the Free Software Foundation, either version 3 of the License, or    #
# (at your option) any later version.                                  #
#                                                                      #
# This program is distributed in the hope that it will be useful, but  #
# WITHOUT ANY WARRANTY; without even the implied warranty of           #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU    #
# General Public License for more details.                             #
#                                                                      #
# You should have received a copy of the GNU General Public License    #
# along with this program. If not, see <https://www.gnu.org/licenses/> #
#======================================================================#

use strict;
use CGI;
use Config::Simple;

my %Config;
Config::Simple->import_from("$ENV{CONF_FILE}", \%Config) or die Config::Simple->error();

my $param = new CGI;
my $seconds = $param->param('seconds');
my $dark = $param->param('dark');

unless($seconds) {
    $seconds = 60;
}

unless($dark) {
    $dark = 0;
}

my $milliseconds = ($seconds + 1) * 1000;

# Create web response 
print "Content-type: text/html\n\n";
print "<HTML>\n<HEAD>\n";
print "<META HTTP-EQUIV=\"Pragma\" CONTENT=\"no-cache\">\n";
print "<META HTTP-EQUIV=\"Expires\" CONTENT=\"-1\">\n";
print "<TITLE>Clock</TITLE>\n";
print "<link rel=\"stylesheet\" type=\"text/css\" href=\"/css/countdown.css\" title=\"Clock\" media=\"screen\" />\n";
print "</HEAD>\n";
print "<script>\n";
print "function Pad(number, digits) {\n";
print "    return Array(Math.max(digits - String(number).length + 1, 0)).join(0) + number;\n";
print "}\n";
print "// Set the date we're counting down to\n";
print "var countDownDate = new Date().getTime() + $milliseconds;\n";
print "// Update the count down every 1 second\n";
print "var x = setInterval(function() {\n";
print "  // Get today's date and time\n";
print "  var now = new Date().getTime();\n";
print "  // Find the distance between now and the count down date\n";
print "  var distance = countDownDate - now;\n";
print "  // Time calculations for days, hours, minutes and seconds\n";
print "  var seconds = Math.floor((distance % (1000 * 60)) / 1000);\n";
print "  var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));\n";
print "  var hours   = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));\n";

print "  var days = Math.floor(distance / (1000 * 60 * 60 * 24));\n";

print "  // Output the result in an element with id=\"countdown\"\n";
print "  //document.getElementById(\"countdown\").innerHTML = Pad(hours,2) + \":\" + Pad(minutes,2) + \":\" + Pad(seconds,2);\n";
print "  document.getElementById(\"countdown\").innerHTML = Pad(hours,2) + \":\" + Pad(minutes,2) + \":\" + Pad(seconds,2);\n";
print "  // If the count down is over, write some text \n";
print "  if (distance < 1000) {\n";
print "    clearInterval(x);\n";
print "    document.getElementById(\"countdown\").innerHTML = \"LIVE\";\n";
print "  }\n";
print "}, 100);\n";
print "</script>\n";

print "<BODY>\n";
print "    <div id=\"countdown\"  ";
if ($dark == 1) {
    print "class=\"dark\"";
}
print ">\n";
print "</div>\n";
print "<div>\n";
print "</BODY>\n</HTML>\n";
