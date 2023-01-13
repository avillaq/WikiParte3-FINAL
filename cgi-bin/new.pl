#!C:/xampp/perl/bin/perl.exe
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;
my $titulo = $q->param('titulo');
my $texto = $q->param('texto');
my $usuario = $q->param('usuario');
my $isNuevo = $q->param('esNuevo');

my $dsn = "DBI:mysql:database=datospaginaxml;host=127.0.0.1";
my $dbh = DBI->connect($dsn, "Alex", "") or die "No se pudo conectar";

my $sth = $dbh->prepare("Select userName from users where userName=?");
$sth->execute($usuario);

my @array = $sth->fetchrow_array();
my $contenido = "";
#Combrobamos que el usuario ingresado exista en la tabla users
if (@array != 0) {
   #Añadiremos un nuevo articulo con "true"
    if($isNuevo eq "true"){
        $sth = $dbh->prepare("INSERT INTO articles VALUES(?,?,?)");
        $sth->execute($titulo,$usuario,$texto);
        
        $contenido = "<title>$titulo</title>
                    <text>$texto</text>";
    }
    #Si queremos actualizar el texto con "false" (uptade.pl y new.pl son practicamente lo mismo, por eso ambos estan en este script )
    elsif($isNuevo eq "false"){
        #Existe el caso de que se ingrese usuarios que no tengan ningun articulo en la tabla articles,
        # entonces no habria nada que actualizar.
        #Es necesario comprobar que el usuario tenga algun articulo en la tabla articles
        $sth = $dbh->prepare("select text from articles where title=? and owner=?");
        $sth->execute($titulo,$usuario);
        my @array_2 = $sth->fetchrow_array();

        #Si existen, se procedera a actualizar
        if (@array_2 != 0){
            $sth = $dbh->prepare("UPDATE articles SET text=? where title=? and owner=?");
            $sth->execute($texto,$titulo,$usuario);

            $contenido = "<title>$titulo</title>
                    <text>$texto</text>";
        }
    }
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
