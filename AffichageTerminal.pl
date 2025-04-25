# Utilisation du chemin d'accès pour inclure la bibliothèque
use lib 'D:\ITU DS PROM 3\S4\Programmation\Perl\Helicoptera Game';

use strict;
use warnings;
use Fonction;

# Création d'une instance de la classe Fonction
my $fonction = Fonction->new();

# Appel de la fonction pour récupérer les données
my $donnees_recuperees_ref = $fonction->recuperer_donnees();

# Affichage des données récupérées
foreach my $donnees (@$donnees_recuperees_ref) {
    print "idCoordonner: $donnees->{idCoordonner}, typeCoordonner: $donnees->{typeCoordonner}, x1: $donnees->{x1}, x2: $donnees->{x2}, y1: $donnees->{y1}, y2: $donnees->{y2}\n";
}

1;
