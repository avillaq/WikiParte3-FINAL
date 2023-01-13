#!C:/xampp/perl/bin/perl.exe
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;
my $usuario = $q->param('user');

my $dsn = "DBI:mysql:database=datospaginafinal;host=127.0.0.1";
my $dbh = DBI->connect($dsn, "root", "") or die "No se pudo conectar";

my $sth = $dbh->prepare("select title from articles where owner = ?");
$sth->execute($usuario);


my $contenido = "";
while(my @array = $sth->fetchrow_array()){
  $contenido .= "<article><owner>$usuario</owner><title>$array[0]</title></article>";
}

$sth->finish;
$dbh->disconnect;

print $q->header('text/xml');    
print<<XML;
<?xml version='1.0' encoding='utf-8'?>
    <articles>
      $contenido
    </articles>
XML