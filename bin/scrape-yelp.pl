#!/usr/bin/env perl
use Modern::Perl;
use Getopt::Long;
use Pod::Usage;
use WWW::Mechanize;
use YAML;
use Web::Scraper;
use Data::Dumper;
use FindBin qw/$Bin/;
use lib "$Bin/../lib";
use Yelp::DB::Schema;
use JSON::XS;
use Text::CSV_XS;
use DateTime;
use URI;
use URI::Escape;
use Facebook::Graph;
use Log::Any::App '$log', -screen => 1, -file => "$Bin/scrape-yelp.log", -level => "debug";

=head1 NAME

  scrape-yelp.pl


=head1 SYNOPSIS

  perl scrape-yelp.pl [options]

  Options:
  -h                  brief help message
  -proxy              not implemented yet
  -delay              pause between request, default to 3 seconds
  -loc                location
  -desc               keywords
  -dump               dump to csv

  example: 
  perl scrape-yelp.pl --loc "San Francisco, CA" --desc "boutique" --delay 4

=cut


=head1 DESCRIPTION

B<This program> will simulate yelp.com's search form and save the result into database (SQLite). 

Just before saving information into DB, scraper will also looks for specified informations like:

=over

=item *

Do they have a website?

=item *

Can we find facebook account (likes) in their website ?

=item *

Can we find twitter account (followers) in their website ?

=item *

How many their fb likes or tweet's followers ? 

=item *

Do they have sign up for their newsletter ?

=back

Then save them all !

B<Note:>  You can also dump from database to csv format with <code>--dump</code> option

=cut


my ($help, $proxy, $delay, $loc, $desc, $dump);

GetOptions(
  "help|?"    => \$help,
  "proxy|p"   => \$proxy,
  "delay|d=i" => \$delay,
  "loc=s"     => \$loc,
  "desc=s"    => \$desc,
  "dump"      => \$dump
);

pod2usage(1) if $help;
pod2usage("--desc is a mandatory") unless $loc;
pod2usage("--loc is a mandatory") unless $loc;

my $cfg   = YAML::LoadFile("$Bin/../config/config.yaml");
my $base  = "http://www.yelp.com";
my $fb    = Facebook::Graph->new;  

$delay    = 3 unless $delay;
my $agent = WWW::Mechanize->new(autocheck => 0);

$agent->proxy(['http', 'ftp'], $cfg->{proxy}[0]) if $proxy;

$agent->agent_alias("Linux Mozilla");

my $signup_rgx = join "|", @{$cfg->{signup_keywords}};

#connect to DB
my $schema = Yelp::DB::Schema->connect("dbi:SQLite:$Bin/../db/yelp.sqlite3");
my $table  = $schema->resultset("Yelp");

dump_to_csv() if $dump;

get_fb_token();

$log->debug("finding $desc in $loc");

$agent->get($base);

unless ($agent->success) {
	$log->error($agent->res->status_line);
	die;
}

$agent->get("http://www.yelp.com/search?find_desc=$desc&find_loc=$loc&ns=1");

unless ($agent->success) {
	$log->error($agent->res->status_line);
	die;
}

my $mini_crawler = mini_crawler();
my $res = $mini_crawler->scrape($agent->content);
crawl_and_create($res);

my $page = 2;
while ($agent->find_link(text_regex => qr/next/i)) {
	$agent->follow_link(text_regex => qr/next/i);

	unless ($agent->success) {
		$log->error("following page $page is failed: " . $agent->res->status_line);
		die;
	}

	say "following page: $page";
	my $res = $mini_crawler->scrape($agent->content);
	
	#getting fb, tweet and more info
	crawl_and_create($res);

	$page++;
	sleep $delay;
}


sub crawl_and_create {
	my $res = shift;
	for my $r (@{$res->{list}}) {
		say $r->{url};
		my $rs = $table->search({url => $r->{url}},{rows => 1})->single;

		next if $rs;

		#add desc and loc to hash
		$r->{desc} = $desc;
		$r->{location} = $loc;

		my $page = $base . $r->{url};

		my $new_agent = WWW::Mechanize->new(autocheck => 0);
		$new_agent->proxy(['http', 'ftp'], $cfg->{proxy}[0]) if $proxy;

		
		sleep $delay;
		
		$new_agent->get($page);

		unless ($new_agent->success) {
			$log->error($new_agent->res->status_line);
			return;	
		}
		


		my $detail = maxi_crawler()->scrape($new_agent->content);

		if ($detail->{website}) {
			$r->{website} = $detail->{website};

			$log->debug("getting " . $r->{website});

			$new_agent->get($r->{website});
			

			if ($agent->success) {
				#do they have email newsletter signup box or something
				$r->{email_newsletter} = $new_agent->content =~ /($signup_rgx)/si ? "yes" : "no";

				#do they have flash?
				if $agent->content = ~ /AC_RunActiveContent.js/si) {
					$r->{flash} = "yes";
				} else {
					$r->{flash} = "no";
				}

				#find facebook link and likes
				my $fb_link = find_fb_widget($agent->content);
				my $fb_id   = get_fb_id_or_url($fb_link);

				if (defined $fb_id) {
					if ($fb_id =~ /^(http|www\.)/) {
						my $fb_like = likes_by_fql($fb_id);
						$r->{facebook} = "yes";
						$r->{fb_like} = $fb_like;
					} else {
						my $fb_like = fb_like($fb_id);
						$r->{facebook} = "yes";
						$r->{fb_like} = $fb_like;
					}

					#die Dumper $r;
				}

				#find twitter link and likes
				my $tweet_link = find_twitter_widget($agent->content);
				my $tweet_id   = get_tweet_id($tweet_link);

				if ($tweet_id) {
					my $followers = twitter_follower($tweet_id);
					$r->{twitter} = "yes";
					$r->{twitter_follower} = $followers;

					#die Dumper $r;
				} else {
					$r->{twitter} = "no"
				}
			} else {
				$log->error($agent->res->status_line);
			}
		}
		$table->create($r);
	}
}

sub get_tweet_id {
	my $link = shift;

	if ($link =~ /\/share$/i) { return undef }

	if ($link =~ /twitter.com\/(@?\w+(\.\w+)?)\/?$/i) {
		return $1;
	}elsif($link =~ /twitter.com\/#!\/(\w+)\/?$/i) {
		return $1;
	}elsif($link =~ /twitter.com\/#%21\/(\w+)\/?$/i) {
		return $1;
	}elsif($link =~ /(\w+)\/status\/\d+$/i) {
		return $1;
	}elsif($link =~ /(\w+)\/following$/i) {
		return $1;
	} else {
		die $link;
	}
}

sub get_fb_id_or_url {
	my $link = shift;

	return $link if $link !~ /facebook\.com/i;

	if ($link =~ /facebook.com\/(\w+)\/?$/i) {
		return $1;
	}elsif($link =~ /facebook.com\/(\w+)\?/i) {
		return $1;
	} elsif ($link =~ /facebook.com\/(\w+\.\w+(.\w+)?)\/?$/i) {
		return $1;
		
	} elsif ($link =~ /pages\/.*?\/(\d+)\??/i) {

		return $1;
	} elsif ($link =~ /facebook.com\/home.php\?.*?\/pages\/.*?\/(\d+)\??/i) {
		return $1;
	} elsif ($link =~ /facebook.com\/home.php\??(#!|%21)\/pages\/.*?\/(\d+)\??/i) {
		return $1;
	} elsif ($link =~ /facebook.com\/sharer.php\?u=(.*)&/i) {
		
		return uri_unescape($1);
	} elsif ($link =~ /facebook.com\/share.php\?u=(.*)(&|)/i) {
		
		return uri_unescape($1);
	} else {
		return undef;
	}
}


sub twitter_follower {
	my $user = shift;

	my $agent = WWW::Mechanize->new(autocheck => 0);
	$agent->proxy(['http', 'ftp'], $cfg->{proxy}[0]) if $proxy;

	$agent->get("https://api.twitter.com/1/users/show.json?screen_name=$user&include_entities=true");

	my $info = decode_json($agent->content);
	
	if (defined $info->{errors}[0]{message}) {
		say join ", ", $info->{errors}[0]{message};
	} else {
		return $info->{followers_count} if defined $info->{followers_count}
	}
}

sub likes_by_fql {
	my $like_url = shift;

	say $like_url;
	$agent->get(
		"https://api.facebook.com/method/fql.query?".
		"query=select like_count,total_count from link_stat ".
		"where url='$like_url'&format=json");

	unless ($agent->success) {
		$log->error($agent->res->status_line);
		die;
	}

	say $agent->content;
	my $json_like = decode_json($agent->content);

	if (defined $json_like->{error_msg}) {
		$log->error($json_like->{error_msg});
		return 0;
	}

	unless (@$json_like) {
		$log->error("search of $like_url return nil");
		return 0;
	}

	return $json_like->[0]{total_count} || 0;
}


sub fb_like {
	my $id = shift;
	my $user= eval{$fb->fetch($id);};
	if ($@) {
		$log->error("$@");
		return 0;
	}

	if ($user->{error}) {
		if (defined $user->{error}{message} && $user->{error}{message} =~ /(Session has expired|The session has been invalidated|Error validating access token|The session is invalid)/i) {
			$log->warn("$id : " . $user->{error}{message} );		
			get_fb_token();	
			fb_like($id);	
		}else{
			die $user;
		}
	} else {

		return $user->{likes} if defined $user->{likes};
		return 0;

	}
}

sub maxi_crawler {
	scraper { 
		process '//div[@id="bizUrl"]/a', 'website' => sub {
			if (defined $_[0]->attr("href") && $_[0]->attr("href") =~ /url=(.*?)&/) {
				return uri_unescape($1);
			}
		};
	};
}

sub mini_crawler {
	scraper {
		process '//div[@class="businessresult clearfix"]', "list[]" => scraper{
			process '//div[@class="media-story"]/h4/a', 'title' => sub {
				my $title = $_[0]->as_text;
				$title =~ s/(^\d+\.\s+|\s+$)//g;
				$title;
			};
			process '//div[@class="media-story"]/h4/a', 'url' => '@href',

			process '//div[@class="media-story"]/div[@class="itemcategories"]', 'category' => sub {
				my $cat = $_[0]->as_text;
				$cat      =~ s/(^\s+Category:\s+|\s+$)//g;
				$cat;
			};
			process '//div[@class="media-story"]/div[@class="itemneighborhoods"]', 'neighborhood' => sub {
				my $neighbor = $_[0]->as_text;
				
				$neighbor =~ s/(^\s+Neighborhood:\s+|\s+$)//g;
				$neighbor;

			};

			process '//div[@class="rating"]/i', 'rating' => sub {
				my $rating = $1 if $_[0]->attr("title") =~ /(\d+\.\d+)/;
				$rating;
			
			};

			process '//span[@class="reviews"]', 'review' => sub {
				my $text = $1 if $_[0]->as_text =~ /(\d+)/;
				$text;
			};

			process '//address/div', 'address' => sub {
				my $html = $_[0]->as_HTML;
				$html =~ s/<br \/>/, /g;
				$html =~ s/<\/?div>//g;
				$html =~ s/(^\s+|\s+$)//g;
				
				$html;
			};
			process '//address/div[@class="phone"]', 'phone' => sub {
				my $text = $_[0]->as_text;
				$text =~ s/(^\s+|\s+$)//g;
				$text;
			}
		};
	};
}

sub dump_to_csv {
	my $fn = DateTime->now->datetime;
	my $csv = Text::CSV_XS->new({binary => 1, sep_char => ",", eol => "\n"});
	$fn =~ s/:/_/g;

	open my $fh, ">", "$Bin/../result/$fn.csv" or die $!;
	my $rs = $table->search({location => $loc, desc => $desc, facebook => "yes"});

	my @columns = $table->result_source->columns;
	 
	$csv->print($fh, \@columns);
	while (my $row = $rs->next) {
		my @rows = map { $row->$_ } @columns;
		$csv->print($fh, \@rows);

	}
	say "Dump done";
	exit;
}


=over

=item get_fb_token()

=back

Will try to get access token from facebook.

=cut

=over 

=item 1

At first, URI's build_query is used to find $authorize_url

=item 2

Then login to facebook using WWW::Mechanize

=item 3

Then use Mechanize's object to get request to $authorize_url

=item 4

Use URI's object to request access token based on auth's code we have before

=item 5.

Set new access token to Facebook::Graph's object

=back

B<If any steps above is failed then the script will (should) die !!!!>


=cut

sub get_fb_token {
	$log->debug("Getting new FB Access Token");
	my $cfg_fb = $cfg->{fb};

	#create new mech's object
	my $agent = WWW::Mechanize->new();
	$agent->proxy(['http', 'ftp'], $cfg->{proxy}[0]) if $proxy;
	$agent->agent_alias("Linux Mozilla");
	
	my $authorize_url = build_query(
		$cfg_fb->{dialog_oauth},
  		client_id    => $cfg_fb->{app_id},
  		redirect_uri => $cfg_fb->{redirect_uri},
  		scope        => $cfg_fb->{scope}
  	);
  	$log->debug("auth url: $authorize_url");
	say "$authorize_url";


	#login before GET authorize_url
	$agent->get($cfg_fb->{login_url});
	$agent->submit_form(
  		fields => {
    		email => $cfg_fb->{email},
    		pass =>  $cfg_fb->{pass}
  		}
	);


	$agent->get($authorize_url);

	my $auth_code = $1 if $agent->base->as_string =~ /code=(.*)/i;
	die "Error: no secret code returned for auth URL" unless $auth_code;

	my $access_token_url = build_query(
		$cfg_fb->{access_token_url},
		client_id     => $cfg_fb->{app_id},
  		redirect_uri  => $cfg_fb->{redirect_uri},
		client_secret => $cfg_fb->{app_secret},
	    code          => $auth_code
	);
  
	$agent->get($access_token_url);
	my $access_token = $1 if $agent->content =~ /access_token=(.*?)&/;

	die "no access token found\n" unless $access_token;

	$fb->access_token($access_token);
}


=over

=item build_query()

=back


Will query facebook and get some info from them, we should refactor 

this soon (as we have WWW::Mechanize and we can do it with Mechanize Not URI)

=cut

sub build_query {
	my $uri = URI->new(shift);
	$uri->query_form(@_);
	return $uri->as_string;
}



sub find_fb_widget {
	my $content = shift;

	if ($content =~ /<fb:like.*? href=["''](.*?)['"].*?>/si) {
		return $1;
	}

	my $node = HTML::TreeBuilder->new;
	$node->parse($content);

	my @fb_html5 = $node->find_by_attribute(class => "fb-like");

	for my $key (@fb_html5) {
		my $fb_id = $key->attr("data-href");
		$node->delete;
		return $fb_id;
	}

	
	my @iframes = $node->look_down(
		_tag => 'iframe',
		sub { 
			defined $_[0]->attr("src") && 
			$_[0]->attr("src") =~ /(www\.)?facebook.com\/plugins\/like\.php/
		}
	);

	for my $f (@iframes) {
		my $link = $f->as_HTML;

		my $src = $1 if $link =~ /src=['"](.*?)['"]/i;
		die unless $src;
		
		some sites put invalid unescaped so we have to unescape twice
		my $fb_url = uri_unescape(uri_unescape($1)) if $src =~ /href=(.*?)(&|$)/i;
		#die $src unless $fb_url;

		$node->delete;
		return $src;
	}
	

	my @links_1 = $node->look_down(
		_tag => 'a',
		sub {
			defined $_[0]->attr("href") &&
			$_[0]->attr("href") =~ /(www.)?facebook.com\/plugins\/like.php/
		}
	);

	for my $f (@links_1) {
		$log->warn("found unexpected :". $f->as_HTML);
		$log->warn("contact developer");
		die;
	}

	my @links_2 = $node->look_down(
		_tag => "a",
		sub {
			defined $_[0]->attr("href") &&
			$_[0]->attr("href") =~ /(www\.)?facebook.com\/*/
		}
	);

	for my $link (@links_2) {
		if ($link->attr('href') =~ /\/pages\//) {
			my $fb_link = $link->attr("href");
			$node->delete;
			return $fb_link;	
		}

		my $uri = URI->new($link->attr("href"));
		if ($uri->path =~ /^\/([a-zA-Z_]+([a-zA-Z.]+)?)(\w+)(\/)?$/) {
			my $fb_link = $link->attr("href");
			$node->delete;
			return $fb_link;
		} elsif ($uri->path =~ /\/pages\//) {
			my $fb_link = $link->attr("href");
			$node->delete;
			return $fb_link;	
		} else {
			say $uri->path;
			$log->warn("found fb url: ". $link->attr("href"));
			$node->delete;

			$log->warn("are you sure above is invalid?");
			sleep 5;
			return 0;
		}
	}
	return undef;
}

sub find_tweet_widget {
	my $content = shift;

	my $node = HTML::TreeBuilder->new;
	$node->parse($content);
	
	my @links_1 = $node->look_down(
		_tag => 'a',
		sub {
			defined $_[0]->attr("href") &&
			$_[0]->attr("href") =~ /twitter.com/i /		
		}
	);

	for my $f (@links_1) {
		next if $f->attr("href") !~ /home\/status\?/;
		my $link = $f->as_HTML;
		$node->delete;
		return $link;
	}

	die;
	my @iframes = $node->look_down(
		_tag => 'iframe',
		sub { 
			defined $_[0]->attr("src") && 
			$_[0]->attr("src") =~ /twitter\.com/i
		}
	);

	for my $f (@iframes) {
		my $link = $f->as_HTML;

		$node->delete;
		return undef
	}
	
	return undef;
}