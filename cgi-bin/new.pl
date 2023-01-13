#!C:/xampp/perl/bin/perl.exe
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;
my $titulo = $q->param('titulo');
my $texto = $q->param('texto');
my $usuario = $q->param('user');

my $dsn = "DBI:mysql:database=datospaginafinal;host=127.0.0.1";
my $dbh = DBI->connect($dsn, "root", "") or die "No se pudo conectar";

my $sth = $dbh->prepare("INSERT INTO articles VALUES(?,?,?)");
$sth->execute($titulo,$usuario,$texto);
        
$sth->finish;
$dbh->disconnect;

print $q->header('text/xml');    
print<<XML;
<?xml version='1.0' encoding='utf-8'?>
    <article>
        <title>$titulo</title>
        <text>$texto</text>
    </article>
XML
