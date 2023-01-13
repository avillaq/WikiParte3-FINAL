#!C:/xampp/perl/bin/perl.exe -w
use strict;
use CGI;
use DBI;
my $q = CGI->new;
my $name = $q->param('user');############################
my $password = $q->param('password');

my $dsn = "DBI:mysql:database=datospaginafinal;host=127.0.0.1";
my $dbh = DBI->connect($dsn, "root", "") or die "No se pudo conectar";
    
my $sth = $dbh->prepare("SELECT firstname, lastname FROM users WHERE userName=? AND password=?");
$sth->execute($name, $password);
    
my @array = $sth->fetchrow_array;
$sth->finish();
$dbh->disconnect;

#Si el array tiene elementos, entonces existe el usuario
#$array[0] contiene al nombre
#$array[1] contiene al apellido
my $contenido = "";
if(@array != 0) {
    $contenido = "<owner>$name</owner>
        <firstName>$array[0]</firstName>
        <lastName>$array[1]</lastName>";
}

print $q->header('text/xml');    
print<<XML;
<?xml version='1.0' encoding='utf-8'?>
    <user>
        $contenido
    </user>
XML
