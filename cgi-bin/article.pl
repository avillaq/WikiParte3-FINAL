#!C:/xampp/perl/bin/perl.exe
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;

my $dsn = "DBI:mysql:database=datospaginaxml;host=127.0.0.1";
my $dbh = DBI->connect($dsn, "Alex", "") or die "No se pudo conectar";

my $titulo = $q->param('titulo');
my $usuario = $q->param('usuario');

my $sth = $dbh->prepare("select text from articles where title=? and owner=?");
$sth->execute($titulo, $usuario);

my $contenido = "";
my @array = $sth->fetchrow_array();
if (@array != 0) {
    $contenido = "<owner>$usuario</owner>
        <title>$titulo</title>
        <text>$array[0]</text>";
}

$sth->finish;
$dbh->disconnect;

print $q->header('text/xml');    
print<<XML;
<?xml version='1.0' encoding='utf-8'?>
    <article>
        $contenido
    </article>
XML