package BdConnect;

use strict;
use warnings;
use DBI;

sub new {
    my ($class) = @_;

    my $database = "Helicoptera";
    my $user     = "root";
    my $password = "root";
    my $host     = "localhost";

    my $dsn = "DBI:mysql:database=$database;host=$host";
    my $self = {
        dsn      => $dsn,
        user     => $user,
        password => $password,
        dbh      => undef,
    };
    bless $self, $class;
    return $self;
}

sub connect {
    my ($self) = @_;
    $self->{dbh} = DBI->connect($self->{dsn}, $self->{user}, $self->{password}, { PrintError => 0, RaiseError => 1 })
        or die "Impossible de se connecter à la base de données: " . $DBI::errstr;
}

sub disconnect {
    my ($self) = @_;
    $self->{dbh}->disconnect if $self->{dbh};
}

1;
