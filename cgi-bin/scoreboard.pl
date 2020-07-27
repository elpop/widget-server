#!/usr/bin/perl
#======================================================================#
# Program => scoreboard.pl (In Perl 5.0)                 version 0.0.1 #
#======================================================================#
# Autor => Fernando "El Pop" Romo                   (pop@cofradia.org) #
# Creation date => 26/jul/2020                                         #
#----------------------------------------------------------------------#
# Info => This program is a scoreboard widget to display results of    #
#         games from a postgres database.                              #
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
my $match_id = $param->param('match_id');

unless($match_id) {
    $match_id = 1;
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
my $match_name = '';
my $match_place = '';
my $multi_score = 0;

# Connect to the Database Server
my $dbh = DBI->connect($Config{'db_pg.name'}, $Config{'db_pg.user'}, $Config{'db_pg.pass'});
$dbh->{PrintError} = 0; # Disable automatic  Error Handling

$SQL_Code = "select Name, Place from Matchs where ID = $match_id;";
my $sth = $dbh->prepare($SQL_Code);
my $ret = $sth->execute;
my $count=$sth->rows;
if ($count > 0) {
    while (my ($name, $place) = $sth->fetchrow_array) {
        $match_name = $name;
        $match_place = $place;
    }
    $ok = 1; # if have data procced with the report
}
else {
    $sth->finish();
}

$SQL_Code ="select mt.id as mt_id,
                   t.name as name,
                   t.color as color,
                   t.logo as logo,
                   (select sum(points) from Points where Points.Matchs_Teams_ID = mt.id) as points
            from teams as t,
                 Matchs_Teams as mt
            where mt.Teams_ID = t.ID and
                  mt.match_id = $match_id;";
$sth = $dbh->prepare($SQL_Code);
$ret = $sth->execute;
$count=$sth->rows;
if ($count > 0) {
    $multi_score = 1 if ($count > 2);
    while (my ($id, $name, $color, $logo, $points) = $sth->fetchrow_array) {
        # Load info in the hash %pivot
        my @rgb_color = unpack 'C*', pack 'H*', $color;
        $pivot{$id} = { name => $name, color => [ $rgb_color[0], $rgb_color[1], $rgb_color[2] ], logo => $logo, points => $points};
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
print "<TITLE>Scoreboard</TITLE>\n";
print "<link rel=\"stylesheet\" type=\"text/css\" href=\"/css/scoreboard.css\" title=\"Scoreboard\" media=\"screen\" />\n";
print "</HEAD>\n";
print "<BODY>\n";
unless ($multi_score) {
    print "<IMG SRC=\"/images/scoreboard/scoreboard_title.png\">";
    print "<div id=\"Match\" class=\"Name\">$match_name</div>";
    my $index = 1;
    foreach my $mt_id (sort { $a cmp $b } keys %pivot) {
        $index++;
        print "<div id=\"Logo\" ";
        if (($index % 2) == 0) {
            print "class=\"Home\"";
        }
        else {
            print " class=\"Visitor\"";
        }
        print "><IMG SRC=\"/images/scoreboard/team_logos/$pivot{$mt_id}{logo}\" class=\"scoreboard\"></div>";
        print "<div id=\"Name\" ";
        if (($index % 2) == 0) {
            print "class=\"Home\"";
        }
        else {
            print " class=\"Visitor\"";
        }
        print ">$pivot{$mt_id}{name}</div>";
        print "<div id=\"Scoreboard\" ";
        if (($index % 2) == 0) {
            print "class=\"Home\"";
        }
        else {
            print " class=\"Visitor\"";
        }
        print ">$pivot{$mt_id}{points}</div>";
    }
}
else {
    print "<div id=\"SquareConteiner\">\n";
    print "<table>\n";
    print "<tr><td align=\"center\">";
    print "<div id=\"SquareData\">\n";
    print "    <IMG SRC=\"/images/scoreboard/match_name.png\">";
    print "    <div id=\"Match\" class=\"Multi\">$match_name</div>\n";
    print "</div>\n";
    print "</td><tr>\n";
    print "<tr><td>";
    foreach my $mt_id (sort { $a cmp $b } keys %pivot) {
        print "<div id=\"SquareData\">\n";
        print "<IMG SRC=\"/images/scoreboard/scoreboard_multi.png\">";
        print "<div id=\"Logo\" class=\"Multi\"><IMG SRC=\"/images/scoreboard/team_logos/$pivot{$mt_id}{logo}\" class=\"scoreboard\"></div>";
        print "<div id=\"Name\" class=\"Multi\">$pivot{$mt_id}{name}</div>";
        print "<div id=\"Scoreboard\" class=\"Multi\">$pivot{$mt_id}{points}</div>";
        print "</div>\n";
    }
    print "</div>\n";
    print "</td><tr>\n";
    print "</table>";

}
print "</BODY>\n</HTML>\n";
