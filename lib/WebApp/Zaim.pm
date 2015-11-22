package WebApp::Zaim;

use 5.006;
use strict;
use warnings;

use utf8;

use OAuth::Lite::Consumer;
use OAuth::Lite::Token;

use Data::Dumper;
use JSON qw/decode_json encode_json/;


=head1 NAME

WebApp::Zaim - The great new WebApp::Zaim!

=head1 VERSION

Version 0.00001

=cut

our $VERSION = '0.00001';

=head1 SYNOPSIS



=head1 EXPORT

=head1 SUBROUTINES/METHODS

=head2 function1

=cut

sub new{ 
    my ($class,%args) =@_;

        
    if(defined $args{'filename'}){
        my $filename = $args{'filename'};
        open my $fh,'<',$filename or die "$!\n";
        my $json_in =  do{
            local $/ = undef;
            <$fh>;
        };
        
        my $data = decode_json($json_in);

        
        $args{'consumer_key'}        = $data->{'consumer_key'};
        $args{'consumer_secret'}     = $data->{'consumer_secret'};
        $args{'access_token'}        = $data->{'access_token'};
        $args{'access_token_secret'} = $data->{'access_token_secret'};
    }
    
    my $consumer = OAuth::Lite::Consumer->new(
        consumer_key    => $args{'consumer_key'},
        consumer_secret => $args{'consumer_secret'},
        );
    
    my $token = OAuth::Lite::Token->new(
        token  => $args{'access_token'},
        secret => $args{'access_token_secret'},
        );

    bless +{
        consumer => $consumer,
        token    => $token,
    },$class;
}

=head2 function1

=cut

sub call_api{
    my $self = shift;
    
    my $api_url             = q{https://api.zaim.net/v2};
    
    my %func_param = @_;
    my $method = $func_param{'method'};
    my $url    = "$api_url".$func_param{'url'};
    my $token  = $func_param{'token'};
    my $param  = $func_param{'param'} if(defined $func_param{'prama'});
    
    my $res = $self->{'consumer'}->request(
        method => $method,
        url    => $url,
        token  => $self->{'token'},
        param  => $param,
        );
    if(!$res->is_success){
        print STDERR $res->decoded_content;
        exit;
    }

    return decode_json($res->decoded_content); 
}


=head1 AUTHOR

cielo_ee, C<< <cielo.ee+github at gmail.com> >>

=cut

1; # End of WebApp::Zaim
