#!/usr/bin/perl
#======================================================================#
# Program => votting_poll.pl (In Perl 5.0)               version 0.0.1 #
#======================================================================#
# Autor => Fernando "El Pop" Romo                   (pop@cofradia.org) #
# Creation date => 24/jul/2020                                         #
#----------------------------------------------------------------------#
# Info => This program is a votting poll widget to display results of  #
#         Polls from a postgres database.                              #
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
use DBI;
use Encode;
use Config::Simple;

my %Config;
Config::Simple->import_from("$ENV{CONF_FILE}", \%Config) or die Config::Simple->error();

my $param = new CGI;
my $poll_id = $param->param('poll_id');

unless($poll_id) {
    $poll_id = 1;
}

# Convert number to a string (v.g. 1,234)
sub Cant {
    my $number = sprintf "%.0f", shift @_;
    1 while $number =~ s/^(-?\d+)(\d\d\d)/$1,$2/;
    return $number;
}

# Working variables
my $ok   = 0;
my %pivot = ();
my $SQL_Code = '';
my $poll_name = '';

# Connect to the Database Server
my $dbh = DBI->connect($Config{'db_pg.name'}, $Config{'db_pg.user'}, $Config{'db_pg.pass'});
$dbh->{PrintError} = 0; # Disable automatic  Error Handling

$SQL_Code = "select description from poll where ID = $poll_id;";
my $sth = $dbh->prepare($SQL_Code);
my $ret = $sth->execute;
my $count=$sth->rows;
if ($count > 0) {
    while (my ($info) = $sth->fetchrow_array) {
        $poll_name = $info;
    }
    $ok = 1; # if have data procced with the report
}
else {
    $sth->finish();
}

$SQL_Code = "select q.description,
                    q.color,
                    sum(v.value) as votes
             from poll_questions as q,
                  votes as v
             where q.poll_id = $poll_id and
                   v.poll_question_id = q.id
             group by q.description,
                   q.color
             order by  q.description;";
my $sth = $dbh->prepare($SQL_Code);
my $ret = $sth->execute;
my $count=$sth->rows;
if ($count > 0) {
    while (my ($desc, $color, $votes) = $sth->fetchrow_array) {
        # Load info in the hash %pivot
        my @rgb_color = unpack 'C*', pack 'H*', $color;
        $pivot{$desc} = { color => [ $rgb_color[0], $rgb_color[1], $rgb_color[2] ], votes => $votes,};
    }
    $ok = 1; # if have data procced with the report
}
else {
    $sth->finish();
}

$dbh->disconnect;

# Create web response 

print "Content-type: text/html\n\n";
print "<HTML>\n<HEAD>\n";
print "<META HTTP-EQUIV=\"refresh\" content=\"10\">\n";
print "<META HTTP-EQUIV=\"Pragma\" CONTENT=\"no-cache\">\n";
print "<META HTTP-EQUIV=\"Expires\" CONTENT=\"-1\">\n";
print "<TITLE>Poll Results</TITLE>\n";
print "<link rel=\"stylesheet\" type=\"text/css\" href=\"/css/voting_poll.css\" title=\"Poll Results\" media=\"screen\" />\n";
print "<script language='JavaScript' SRC='/js/Chart.min.js'></script>\n";
print "</HEAD>\n";
print "<script>\n";
print "function graph(){\n";
print "    var url_base64 = document.getElementById('Reporte').toDataURL('image/png');\n";
print "    var g = document.createElement('A');\n";
print "    g.href = url_base64;\n";
print "    g.download = 'graph.png';\n";
print "    g.type = 'image/png';\n";
print "    document.body.appendChild(g);\n";
print "    g.click();\n";
print "}\n";
print "</script>\n";
print "<BODY>\n";
print '<center>';
print "<div id=\"SquareGraphConteiner\">\n";
# Create graph using Chart.js API
print "    <div id=\"SquareGraph\">\n";
print "        <canvas id=\"Reporte\"></canvas>\n";
print "    </div>\n"; #SquareGraph
print "<script>\n";
print "var ctx = document.getElementById(\"Reporte\");\n";
print "var myChart = new Chart(ctx, {\n";
print "    type: 'bar',\n";
print "    data: {\n";
print "        labels: \['Preferences'\],\n";
print "        datasets: \[\n";

foreach my $question (sort { $a cmp $b } keys %pivot) {
    print "        {\n";
    print "            type: 'bar',\n";
    print "            lineTension: 0.2,\n";
    print "            label: '$question (" . Cant($pivot{$question}{votes}) .")',\n";
    print "            fill: false,\n";
    print "            borderWidth: 1,\n";            
    print "            data: \[$pivot{$question}{votes}\],\n";
    print "            backgroundColor: 'rgba( $pivot{$question}{color}[0], $pivot{$question}{color}[1], $pivot{$question}{color}[2], 1)',\n";
    print "            borderColor:'rgba($pivot{$question}{color}[0], $pivot{$question}{color}[1], $pivot{$question}{color}[2], 1)',\n";
    print "            borderWidth: 1\n";
    print "        },\n";
}

print "        \]\n";
print "    },\n";
print "    options: {\n";
print "       title: {\n";
print "            display: true,\n";
print "            text: ['" . decode("UTF-8","$poll_name") . "'],\n";
print "            fontSize: 18\n";
print "        },\n";
print "        scales: {\n";
print "            xAxes: [{\n";
print "                stacked: false,\n";
print "            }],\n";
print "            yAxes: [{\n";
print "                scaleLabel: { labelString: 'Tipo de cambio', display: true,},\n";
print "            }]\n";
print "        },\n";
print "        animation: false,";
print "    }\n";
print "});\n";
print "</script>\n";

print "</div>\n"; #SquareGraphConteiner
print '</center>';
print "</BODY>\n</HTML>\n";
