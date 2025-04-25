package Fonction;

use strict;
use warnings;
use Tk;
use Tk::PNG;
use BdConnect;

# Déclaration des variables globales pour la direction de l'hélicoptère
my $vy = 0;  # Direction verticale de l'hélicoptère
my $vx = 0;  # Direction horizontale de l'hélicoptère
my $helicoY = 625;       # Position initiale de l'hélicoptère
my $helicoX = 20;
my $timer = 60;
my $tailleMur = 10;
my $pause = 0;
my $reculHelico = 5;
#compte ananany
my $compte = 0;
my $score =0;
# parametre anle helicoptera
# vitesse na aingampande anilay hlico
my $helicoSpeed = 4; 
my $tailleHelico = 20;
my $donnees_recuperees_ref = recuperer_donnees();

# Constructeur de la classe Fonction
sub new {
    my ($class) = @_;
    return bless {}, $class;
}
# Fonction pour récupérer les données des obstacles depuis la base de données
sub recuperer_donnees {
    my ($self) = @_;

    my $bdd = BdConnect->new();
    $bdd->connect;  # Connexion à la base de données

    my $query = "SELECT * FROM Coordonner";
    my $sth = $bdd->{dbh}->prepare($query);

    $sth->execute;  # Exécution de la requête SQL

    my @donnees;  # Tableau pour stocker les données récupérées
    while (my $row = $sth->fetchrow_hashref) {
        push @donnees, $row;  # Ajout des données au tableau
    }

    $bdd->disconnect;

    return \@donnees;
}

# Fonction pour afficher les points de départ et d'arrivée sur le canevas
sub pointDepart_Arriver {
    my ($self, $canevas) = @_;  # Récupération des données des obstacles
    foreach my $donnees (@$donnees_recuperees_ref) {
        if ($donnees->{typeCoordonner} == 1) {
            if($donnees->{idCoordonner} == 1)
            {
                my $rectangle = $canevas->createRectangle($donnees->{x1}, $donnees->{y1}, $donnees->{x2}, $donnees->{y2}, -fill => 'blue');
            }
            else
            {
                my $rectangle = $canevas->createRectangle($donnees->{x1}, $donnees->{y1}, $donnees->{x2}, $donnees->{y2}, -fill => 'red');
            }
        }
    }
}

# Fonction pour afficher les obstacles sur le canevas
sub obstacle {
    my ($self, $canevas) = @_;  # Récupération des données des obstacles
    foreach my $donnees (@$donnees_recuperees_ref) {
        if ($donnees->{typeCoordonner} == 0) {
            my $rectangle = $canevas->createRectangle($donnees->{x1}, $donnees->{y1}, $donnees->{x2}, $donnees->{y2}, -fill => 'green');
        }
    }
}

# Fonctions pour déplacer l'hélicoptère dans différentes directions
sub haut {
    $vy = -1;
}

sub bas {
    $vy = 1;
}

sub gauche {
    $vx = -1;
}

sub droite {
    $vx = 1;
}

# Fonction pour définir l'arrière-plan du jeu
sub backGround {
    my ($self, $fenetre, $canevas) = @_;
    my $image = $fenetre->Photo(-file => 'image/ciel.png');
    my $helicopteres = $canevas->createImage(
        400, 400,
        -image => $image
    );
}

#fonction restarter game
sub restart_game{
    my ($self,$canevas,$fenetre) = @_;  # maka anle donne obstacles any anaty base de donne
    $helicoX = 20;
    $helicoY = 625;
    print "@ Rejouer";
}

#Game over
sub gameOver{
    my ($fenetre,$canevas) = @_;
    foreach my $donnees (@$donnees_recuperees_ref) {
        my $message;
        if($timer <= 0)
        {
            $message = "Game Over. Time Out ?";
        }
        else{
            $message = "Game Over. Restart ?";
        }
        if ($helicoX + $tailleHelico >= $donnees->{x1} - $tailleMur&& 
            $helicoX <= $donnees->{x2} + $tailleMur&&
            $helicoY + $tailleHelico >= $donnees->{y1} &&
            $helicoY <= $donnees->{y2} + $tailleMur && $donnees->{typeCoordonner} == 0 || $timer <= 0) {
                my $response =$fenetre->messageBox(
                -message => $message,
                -type    => 'yesno',
                -icon    => 'question',
                -title   => 'fin de jeu'
            );
            if($response eq 'Yes')
            {
                $timer = 60;
                restart_game($canevas,$fenetre);
            }
            elsif($response eq 'No')
            {
                $fenetre->destroy;
            }
        }
    }
}
#fonction arriver
sub jeuTerminer{
    my ($fenetre,$canevas) = @_;
    foreach my $donnees (@$donnees_recuperees_ref) 
    {
        if($donnees->{idCoordonner} == 2)
        {
            if($helicoX + $tailleHelico >= $donnees->{x1} - $tailleMur&& 
                $helicoX <= $donnees->{x2} + $tailleMur&&
                $helicoY + $tailleHelico >= $donnees->{y1} &&
                $helicoY <= $donnees->{y2} + $tailleMur){
                my $response =$fenetre->messageBox(
                -message => "le jeu est terminé. Recommencer ?",
                -type    => 'yesno',
                -icon    => 'question',
                -title   => 'fin de jeu'
            );
            if($response eq 'Yes')
            {
                restart_game($canevas,$fenetre);
            }
            elsif($response eq 'No')
            {
                $fenetre->destroy;
            }
                print "Tonga @ arriver";
            }
        }
    }
}

#fonction manisy point anle jeux
sub point{
    my ($self) = @_;
    my $hauteurHelico = 25;
    foreach my $donnees (@$donnees_recuperees_ref) {
        if ($donnees->{typeCoordonner} == 0) {
            if ($helicoX >= $donnees->{x1} - 2.5 && 
                $helicoX <= $donnees->{x1}&&
                $helicoY + $tailleHelico >= $donnees->{y1} - $donnees->{y1} &&
                $helicoY <= 800) {
                #raha 3 fois ny taille any no idirany dia 4 points
                $compte +=1;
                if($compte == 1)
                {
                    $score = 2;
                }
                elsif($compte == 2)
                {
                    $score += 2;
                }
                else{
                    $score += 4;
                }
                print "compte = $score\n";
            }
        }
    }
    
}
# Fonction pour animer l'hélicoptère
sub helicoptera {
    my ($self, $fenetre, $canevas) = @_;
    # Créer l'hélicoptère sur le canevas
    my $path = "image/Hellicoptera2.png";

    my $image = $fenetre->Photo(-file => $path);
    my $helicopteres = $canevas->createImage(
        $helicoX +50, $helicoY - 2,
        -image => $image
    );
    my $move_Hellico;

    # Fonction pour animer l'hélicoptère
    $move_Hellico = sub {
        # Mettre à jour la position de l'hélicoptère
        $helicoY += $helicoSpeed * $vy;
        $helicoX += $helicoSpeed * $vx;
        point();
        # timeOut($canevas,$fenetre);
        # mi verifier collision @ zay obstacle missi
        # maka anle donne obstacles any anaty base de donne
        if ($helicoY <= 0) {
            $vy *= 0;  # atao 0 ny vitesse de mijanona izi
            $helicoY = $helicoY + $reculHelico;
            print "x: $helicoX \n y: $helicoY \n";
        }
        if ($helicoY >= 800 - $tailleHelico) {
            $vy *= 0;  # atao 0 ny vitesse de mijanona izi
            $helicoY = $helicoY - $reculHelico;
            print "x: $helicoX \n y: $helicoY \n";
        }
        if ($helicoX <= 0) {
            $vx *= 0;  # atao 0 ny vitesse de mijanona izi
            $helicoX = $helicoX + $reculHelico;
            print "x: $helicoX \n y: $helicoY \n";
        }
        if ($helicoX >= 800 - $tailleHelico) {
            $vx *= 0;  # atao 0 ny vitesse de mijanona izi
            $helicoX = $helicoX - $reculHelico;
            print "x: $helicoX \n y: $helicoY \n";
        }
        foreach my $donnees (@$donnees_recuperees_ref) {
            if ($helicoX + $tailleHelico >= $donnees->{x1} - $tailleMur&& 
                $helicoX <= $donnees->{x2} + $tailleMur&&
                $helicoY + $tailleHelico >= $donnees->{y1} &&
                $helicoY <= $donnees->{y2} + $tailleMur) { #&& $donnees->{typeCoordonner} == 0

                # gameOver($fenetre, $canevas);
                jeuTerminer($fenetre, $canevas);

                # rehefa mahita collision, de ajanona ny vitesse makany @ iny direction iny
                if ($vx > 0) {
                    $vx = 0;
                    $helicoX = $helicoX - $reculHelico;
                    print "x: $helicoX \n y: $helicoY \n";
                } elsif ($vx < 0) {
                    $vx = 0;
                    $helicoX = $helicoX + $reculHelico;
                    print "x: $helicoX \n y: $helicoY \n";
                }
                if ($vy > 0) {
                    $vy = 0;
                    $helicoY = $helicoY - $reculHelico;
                    print "x: $helicoX \n y: $helicoY \n";
                } elsif ($vy < 0) {
                    $vy = 0;
                    $helicoY = $helicoY + $reculHelico;
                    print "x: $helicoX \n y: $helicoY \n";
                }
            }
        }
        #raha apina timer le game 
        if($timer <= 0)
        {
            gameOver($fenetre, $canevas);
        }
        # mamindra anle helicoptera eo @ ilay canevas
        $canevas->coords($helicopteres, $helicoX + 9, $helicoY + 17);

        #miandry ftona kely alohany anovana maj anle fonction
        $canevas->after(20, $move_Hellico);
    };
    # Lancer l'animation
    $move_Hellico->();
}

sub timeOut{
    my ($self,$canevas,$fenetre) = @_;
    my $afficheTime;
    if($timer <= 0)
    {
        $timer = 0;
    }
    else{
        $timer -= 1;
        print "$timer \n";
    }

    Tk::after(1000,\&timeOut);
}
# ito ny ecoute clavier 
sub direction {
    my ($self, $fenetre) = @_;
    $fenetre->bind('<KeyRelease>' => sub{
        #izay voatsindry dia lasa ao @ io variable ito
        my $key = shift; 
        if ($key eq 'Up' || $key eq 'Down' || $key eq 'Left' || $key eq 'Right') {
            return;
        }
        $vx = 0;
        $vy = 0.02;
    });
    $fenetre->bind('<Up>', [\&haut]);
    $fenetre->bind('<Down>', [\&bas]);
    $fenetre->bind('<Left>', [\&gauche]);
    $fenetre->bind('<Right>', [\&droite]);
}
1;
