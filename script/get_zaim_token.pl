#!/usr/bin/perl

=head1 NAME
get zaim OAuth tokens
=head1 SYNOPSIS

get_zaim_tokens.pl [--filename filename]|[--key consumer_key --secret consumer_secret]

=cut

use strict;
use warnings;

use OAuth::Lite::Consumer;
use OAuth::Lite::Token;

use JSON qw/decode_json encode_json/;

use Pod::Usage;
use Getopt::Long qw/:config posix_default no_ignore_case bundling auto_help/;

GetOptions(
    \my %opts,qw/
    filename|f=s
    key|k=s
    secret|s=s
    /) or pod2usage(verbose => 0);


my $consumer_key;
my $consumer_secret;

my $json_data;

#filinameが指定されている場合
if(defined $opts{filename}){
    my $filename = $opts{filename};
    open my $fh,'<',$filename or die "$!";
    my $json_in = do{
        local $/ = undef;
        <$fh>;
    };
    close $fh;
    $json_data = decode_json($json_in);

    $consumer_key    = $json_data->{'consumer_key'};
    $consumer_secret = $json_data->{'consumer_secret'};
}else{
#指定されていない場合
    $consumer_key    = $opts{key};
    $consumer_secret = $opts{secret};
    if(!defined $consumer_key || !defined $consumer_secret){
        print STDERR "input correct consume key or consumer secret";
        exit;
    }
}


#print "$consumer_key\n";
#print "$consumer_secret\n";

my $consumer = OAuth::Lite::Consumer->new(
    consumer_key          => $consumer_key,
    consumer_secret       => $consumer_secret,
    site                  => q{https://api.zaim.net},
    request_token_path    => q{https://api.zaim.net/v2/auth/request},
    access_token_path     => q{https://api.zaim.net/v2/auth/access},
    authorize_path        => q{https://www.zaim.net/users/auth},
    );

my $request_token = $consumer->get_request_token(
    callback_url => 'http://google.com/' #適当なURLを入れておく
    ) or die $consumer->errstr."\n";

     
#print "request token:$request_token\n;";

my $url = $consumer->url_to_authorize(
    token   => $request_token,
    );


print "$url\n";
print "上記URLにアクセス後、Verifierを入力してください:\n";

my $verifier = <STDIN>;
$verifier =~ s/\x0D?\x0A$//g; #cygwinの場合
#chomp $verifier             #cygwin以外

print "verifier:$verifier\n";

my $access_token = $consumer->get_access_token(
    token       => $request_token,
    verifier    => $verifier,
    ) or die $consumer->errstr;

print "access token:       $access_token->{'token'}\n";
print "access_token_secret:$access_token->{'secret'}\n";

$json_data->{'access_token'}        = $access_token->{'token'};
$json_data->{'access_token_secret'} = $access_token->{'secret'};

my $json_out = encode_json($json_data);
open my $ofh,'>','config.json' or die "$!";
print $ofh $json_out;
close $ofh;


