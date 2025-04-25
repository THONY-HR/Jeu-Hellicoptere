use strict;
use warnings;
use Tk;
use lib 'D:\ITU DS PROM 3\S4\Programmation\Perl\Helicoptera Game';
use Fonction;

# Créer une nouvelle fenêtre
my $fenetre = MainWindow->new;

# Obtenir les dimensions de l'écran
my $screen_width = 800;
my $screen_height = 800;

# Définir la géométrie en plein écran
$fenetre->geometry("${screen_width}x${screen_height}+0+0");

# Créer un canevas dans la fenêtre
my $canevas = $fenetre->Canvas(-width => $screen_width, -height => $screen_height)->pack;

# Créer une instance de la classe Fonction
my $fonction = Fonction->new();

# Appeler les méthodes pointDepart_Arriver et obstacle
$fonction->backGround($fenetre,$canevas);
$fonction->obstacle($canevas);
$fonction->pointDepart_Arriver($canevas);
$fonction->helicoptera($fenetre,$canevas);
$fonction->direction($fenetre);
# $fonction->point();
# $fonction->timeOut($canevas,$fenetre);
# Boucle principale
MainLoop;
