#!C:/xampp/perl/bin/perl.exe
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;

my $titulo = $q->param('titulo');
my $usuario = $q->param('user');

my $dsn = "DBI:mysql:database=datospaginafinal;host=127.0.0.1";
my $dbh = DBI->connect($dsn, "root", "") or die "No se pudo conectar";

my $sth = $dbh->prepare("select text from articles where title=? and owner=?");
$sth->execute($titulo, $usuario);

my @array = $sth->fetchrow_array();

$sth->finish;
$dbh->disconnect;

print $q->header('text/xml');    
print<<XML;
<?xml version='1.0' encoding='utf-8'?>
    <article>
        <owner>$usuario</owner>
        <title>$titulo</title>
        <text>$array[0]</text>
    </article>
XML