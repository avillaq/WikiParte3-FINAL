#!C:/xampp/perl/bin/perl.exe -w
use strict;
use CGI;
use DBI;

my $q = CGI->new;
my $newname = $q->param('user');
my $newpassword = $q->param('password');
my $newlastname = $q->param('lastname');
my $newfirstname = $q->param('firstname');

my $dsn = "DBI:mysql:database=datospaginafinal;host=127.0.0.1";
my $dbh = DBI->connect($dsn, "root", "") or die "No se pudo conectar";

#Antes de crear un nuevo registro, podriamos comprobar que los datos
#no esten vacios. En ese caso, tendriamos que hacer pequeñas modificaciones
#a la salida de xml (desde la linea 24) similar a los otros scripts.
my $sth = $dbh->prepare("INSERT INTO users VALUES(?,?,?,?)");
$sth->execute($newname, $newpassword, $newlastname, $newfirstname);

$sth->finish;
$dbh->disconnect;

print $q->header('text/xml');    
print<<XML;
<?xml version='1.0' encoding='utf-8'?>
    <user>
        <owner>$newname</owner>
        <firstName>$newfirstname</firstName>
        <lastName>$newlastname</lastName>
    </user>
XML


