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

my @misTitulos;
my $i = 0;
while(my @array = $sth->fetchrow_array()){
  $misTitulos[$i] = $array[0];
  $i++;
}

$sth->finish;
$dbh->disconnect;

my $contenido = "";
if(@misTitulos != 0){
  foreach my $j(@misTitulos){
      $contenido .= "<article><owner>$usuario</owner><title>$j</title></article>";
  }
}
print $q->header('text/xml');    
print<<XML;
<?xml version='1.0' encoding='utf-8'?>
    <articles>
      $contenido
    </articles>
XML