#!/usr/bin/perl

use strict;
use warnings;
use utf8;

use OAuth::Lite::Consumer;
use OAuth::Lite::Token;

use Data::Dumper;
use JSON qw/decode_json encode_json/;

my $consumer_key        = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
my $consumer_secret     = 'YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY';

my $access_token        = 'ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ';
my $access_token_secret = 'WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW';

my $api_url             = q{https://api.zaim.net/v2};

my $consumer = OAuth::Lite::Consumer->new(
    consumer_key    => $consumer_key,
    consumer_secret => $consumer_secret,
    );

my $token = OAuth::Lite::Token->new(
    token  => $access_token,
    secret => $access_token_secret,
    );



#認証できているか確認

my $url = "$api_url".q{/home/user/verify};

#print $url;

my $res = $consumer->request(
    method => 'GET',
    url    => $url,
    token  => $token,
    );

#print Dumper $res->decoded_content;

#print Dumper decode_json($res->decoded_content);


#カテゴリを取得
$url = "$api_url".q{/home/category};

$res = $consumer->request(
    method => 'GET',
    url    => $url,
    token  => $token,
    );

print Dumper decode_json($res->decoded_content);

#input dataを取得する
$url = "$api_url".q{/home/money};

$res = $consumer->request(
    method => 'GET',
    url    => $url,
    params => {'mapping' => 1,'limit' => 100},
    token => $token,
    );

print Dumper decode_json($res->decoded_content);

