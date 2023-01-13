#!C:/xampp/perl/bin/perl.exe
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;

my $dsn = "DBI:mysql:database=datospaginafinal;host=127.0.0.1";
my $dbh = DBI->connect($dsn, "root", "") or die "No se pudo conectar";

my $titulo = $q->param('titulo');
my $usuario = $q->param('usuario');

#Comprobamos que los datos sean correctos
my $sth = $dbh->prepare("select text from articles where title=? and owner=?");
$sth->execute($titulo, $usuario);

my @array = $sth->fetchrow_array();
#Si el usuario y titulo existe, se procedera a borrar sus datos
#Si no existe, devolveremos un xml vacio
my $contenido="";
if (@array != 0) {
    $sth = $dbh->prepare("delete from articles where title=? and owner=?");
    $sth->execute($titulo, $usuario);

    $contenido ="<owner>$usuario</owner>
                <title>$titulo</title>";
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
