#!C:/xampp/perl/bin/perl.exe
use strict;
use warnings;
use CGI;
use DBI;
my $q = CGI->new;

my $dsn = "DBI:mysql:database=datospaginafinal;host=127.0.0.1";
my $dbh = DBI->connect($dsn, "root", "") or die "No se pudo conectar";

my $usuario = $q->param('usuario');
my $titulo = $q->param('titulo');

my $sth = $dbh->prepare("select text from articles where title=? AND owner=?");
$sth->execute($titulo, $usuario);

my $contenido = "";
my @array = $sth->fetchrow_array();

$sth->finish;
$dbh->disconnect;

if (@array != 0) {
     my $text = $array[0];

     $text =~ s/\n/ /g;

     #FALLA: Si el texto tiene 1 #  o  2 # , siempre entrara al primer if
     if($text =~ /######([a-zA-Z\t\h]+)/) {
          $contenido .= "<h6>$1</h6>";
     }
     elsif($text =~ /##([a-zA-Z\t\h]+)/) {
          $contenido .= "<h2>$1</h2>";
     }
     elsif($text =~ /#([a-zA-Z\t\h]+)/) {
          $contenido .= "<h1>$1</h1>";
     }

     #Los 5 siguientes me funcionan correctamente. Fallará si se ejecuta en ubuntu?
     if($text =~ /\*\*\*([a-zA-Z\t\h]+)\*\*\*/) {
          $contenido .= "<p><strong><em>$1</em></strong></p>";     
     }
     if($text =~ /\*\*([a-zA-Z\t\h]+)\*\*/) {
          $contenido .= "<p><strong>$1</strong></p>";     
     }
     if($text =~ /\*([a-zA-Z\t\h]+)\*/) {
          $contenido .= "<p><em>$1</em></p>";     
     }

     if($text =~ /~~([a-zA-Z\t\h]+)~~/) {
          $contenido .= "<p><del>$1</del></p>";     
     }
     if($text =~ /\*\*([a-zA-Z\t\h]+)_([a-zA-Z\t\h]+)_([a-zA-Z\t\h]+)\*\*/) {
          $contenido .= "<p><strong>$1<em>$2</em>$3</strong></p>";     
     }

     #FALLA: No reconoce el ejemplo del profesor : ``` git status ...
     if($text =~ /```([a-zA-Z\t\h]+)```/) {
          $contenido .= "<p><code>$1</code></p><br>";     
     }

     #Este regex solo reconoce la parte del texto que tiene el link. Ademas toma el estilo de general.css
     if($text =~ /\[([a-zA-Z\t\h]+)\]\(([a-zA-Z\t\h\:\.\/]+)\)/) {
          $contenido .= "<p><a href='$2'>$1</a></p><br>";     
     }

#Devolvemos el texto markdown en formato html
print $q->header('text/html');
print<<HTML;
<!DOCTYPE html>
<html>
<head>
     <link rel="stylesheet" href="../styles/general.css">
     <title>Wikipedia 0.1</title>
</head>
<body>
     <div class="wrap">
           $contenido
     </div>
</body>
</html>
HTML

}

#Si los datos son incorrectos devolvemos un xml vacio
else{
print $q->header('text/xml');    
print<<XML;
<?xml version='1.0' encoding='utf-8'?>
    <article>
    </article>
XML
}





