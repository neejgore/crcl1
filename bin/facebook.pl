#!/usr/bin/env perl
use Modern::Perl;
use URI;
use WWW::Mechanize;
use Facebook::Graph;
use Data::Dumper;

my $agent = WWW::Mechanize->new();
my $scope      = 'publish_stream,offline_access';
my $app_id     = "177879965642759";
my $app_secret = "21557556a02a3396415fde8f672d0bd5";

$agent->agent_alias("Linux Mozilla");

my $authorize_url = build_query('http://www.facebook.com/dialog/oauth',
  client_id    => $app_id,
  redirect_uri => 'http://www.facebook.com/connect/login_success.html',
  scope        => $scope
  );

$agent->get("https://www.facebook.com/login.php");

$agent->submit_form(
  fields => {
    email => 'email.com',
    pass => 'foobarfoobar'
  }
);

$agent->get($authorize_url);

my $auth_code = $1 if $agent->base->as_string =~ /code=(.*)/i;

die "Error: no secret code returned for auth URL" unless $auth_code;

say "auth code: $auth_code";

my $access_token_url = build_query("https://graph.facebook.com/oauth/access_token",
    client_id     => $app_id,
    client_secret => $app_secret,
    redirect_uri  => 'http://www.facebook.com/connect/login_success.html',
    code          => $auth_code
);
  
my $response = $agent->get($access_token_url);
my $access_token = $1 if $agent->content =~ /access_token=(.*?)&/;

die "no access token found]\n" unless $access_token;

say "Token $access_token";
my $fb = Facebook::Graph->new;  
$fb->access_token($access_token);

say Dumper $fb->fetch("kishastudio");

sub build_query {
  my $uri = URI->new(shift);
  $uri->query_form(@_);
  return $uri->as_string;
}

