use utf8;
package Yelp::DB::Schema::Result::Yelp;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Yelp::DB::Schema::Result::Yelp

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::TimeStamp>

=back

=cut

__PACKAGE__->load_components("TimeStamp");

=head1 TABLE: C<yelp>

=cut

__PACKAGE__->table("yelp");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 address

  data_type: 'text'
  is_nullable: 1

=head2 category

  data_type: 'text'
  is_nullable: 1

=head2 neighborhood

  data_type: 'text'
  is_nullable: 1

=head2 rating

  data_type: 'float'
  is_nullable: 1

=head2 phone

  data_type: 'text'
  is_nullable: 1

=head2 review

  data_type: 'text'
  is_nullable: 1

=head2 facebook

  data_type: 'text'
  is_nullable: 1

=head2 fb_like

  data_type: 'integer'
  is_nullable: 1

=head2 url

  data_type: 'text'
  is_nullable: 1

=head2 title

  data_type: 'text'
  is_nullable: 1

=head2 website

  data_type: 'text'
  is_nullable: 1

=head2 desc

  data_type: 'text'
  is_nullable: 1

=head2 location

  data_type: 'text'
  is_nullable: 1

=head2 twitter

  data_type: 'text'
  is_nullable: 1

=head2 twitter_follower

  data_type: 'text'
  is_nullable: 1

=head2 email_newsletter

  data_type: 'text'
  is_nullable: 1

=head2 facebook_url

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "address",
  { data_type => "text", is_nullable => 1 },
  "category",
  { data_type => "text", is_nullable => 1 },
  "neighborhood",
  { data_type => "text", is_nullable => 1 },
  "rating",
  { data_type => "float", is_nullable => 1 },
  "phone",
  { data_type => "text", is_nullable => 1 },
  "review",
  { data_type => "text", is_nullable => 1 },
  "facebook",
  { data_type => "text", is_nullable => 1 },
  "fb_like",
  { data_type => "integer", is_nullable => 1 },
  "url",
  { data_type => "text", is_nullable => 1 },
  "title",
  { data_type => "text", is_nullable => 1 },
  "website",
  { data_type => "text", is_nullable => 1 },
  "desc",
  { data_type => "text", is_nullable => 1 },
  "location",
  { data_type => "text", is_nullable => 1 },
  "twitter",
  { data_type => "text", is_nullable => 1 },
  "twitter_follower",
  { data_type => "text", is_nullable => 1 },
  "email_newsletter",
  { data_type => "text", is_nullable => 1 },
  "facebook_url",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2013-04-03 00:26:35
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:UfqQuFjMPxGmQhXQAMVG8w
# These lines were loaded from '/usr/local/share/perl5/Yelp/DB/Schema/Result/Yelp.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package Yelp::DB::Schema::Result::Yelp;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Yelp::DB::Schema::Result::Yelp

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::TimeStamp>

=back

=cut

__PACKAGE__->load_components("TimeStamp");

=head1 TABLE: C<yelp>

=cut

__PACKAGE__->table("yelp");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 address

  data_type: 'text'
  is_nullable: 1

=head2 category

  data_type: 'text'
  is_nullable: 1

=head2 neighborhood

  data_type: 'text'
  is_nullable: 1

=head2 rating

  data_type: 'float'
  is_nullable: 1

=head2 phone

  data_type: 'text'
  is_nullable: 1

=head2 review

  data_type: 'text'
  is_nullable: 1

=head2 facebook

  data_type: 'text'
  is_nullable: 1

=head2 fb_like

  data_type: 'integer'
  is_nullable: 1

=head2 url

  data_type: 'text'
  is_nullable: 1

=head2 title

  data_type: 'text'
  is_nullable: 1

=head2 website

  data_type: 'text'
  is_nullable: 1

=head2 desc

  data_type: 'text'
  is_nullable: 1

=head2 location

  data_type: 'text'
  is_nullable: 1

=head2 twitter

  data_type: 'text'
  is_nullable: 1

=head2 twitter_follower

  data_type: 'text'
  is_nullable: 1

=head2 email_newsletter

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "address",
  { data_type => "text", is_nullable => 1 },
  "category",
  { data_type => "text", is_nullable => 1 },
  "neighborhood",
  { data_type => "text", is_nullable => 1 },
  "rating",
  { data_type => "float", is_nullable => 1 },
  "phone",
  { data_type => "text", is_nullable => 1 },
  "review",
  { data_type => "text", is_nullable => 1 },
  "facebook",
  { data_type => "text", is_nullable => 1 },
  "fb_like",
  { data_type => "integer", is_nullable => 1 },
  "url",
  { data_type => "text", is_nullable => 1 },
  "title",
  { data_type => "text", is_nullable => 1 },
  "website",
  { data_type => "text", is_nullable => 1 },
  "desc",
  { data_type => "text", is_nullable => 1 },
  "location",
  { data_type => "text", is_nullable => 1 },
  "twitter",
  { data_type => "text", is_nullable => 1 },
  "twitter_follower",
  { data_type => "text", is_nullable => 1 },
  "email_newsletter",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2013-03-28 22:07:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3qdMl+9lPrJkLekbAgirNA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/usr/local/share/perl5/Yelp/DB/Schema/Result/Yelp.pm' 
# These lines were loaded from '/usr/local/share/perl5/Yelp/DB/Schema/Result/Yelp.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package Yelp::DB::Schema::Result::Yelp;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Yelp::DB::Schema::Result::Yelp

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::TimeStamp>

=back

=cut

__PACKAGE__->load_components("TimeStamp");

=head1 TABLE: C<yelp>

=cut

__PACKAGE__->table("yelp");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 address

  data_type: 'text'
  is_nullable: 1

=head2 category

  data_type: 'text'
  is_nullable: 1

=head2 neighborhood

  data_type: 'text'
  is_nullable: 1

=head2 rating

  data_type: 'float'
  is_nullable: 1

=head2 phone

  data_type: 'text'
  is_nullable: 1

=head2 review

  data_type: 'text'
  is_nullable: 1

=head2 facebook

  data_type: 'text'
  is_nullable: 1

=head2 fb_like

  data_type: 'integer'
  is_nullable: 1

=head2 url

  data_type: 'text'
  is_nullable: 1

=head2 title

  data_type: 'text'
  is_nullable: 1

=head2 website

  data_type: 'text'
  is_nullable: 1

=head2 desc

  data_type: 'text'
  is_nullable: 1

=head2 location

  data_type: 'text'
  is_nullable: 1

=head2 twitter

  data_type: 'text'
  is_nullable: 1

=head2 twitter_follower

  data_type: 'text'
  is_nullable: 1

=head2 email_newsletter

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "address",
  { data_type => "text", is_nullable => 1 },
  "category",
  { data_type => "text", is_nullable => 1 },
  "neighborhood",
  { data_type => "text", is_nullable => 1 },
  "rating",
  { data_type => "float", is_nullable => 1 },
  "phone",
  { data_type => "text", is_nullable => 1 },
  "review",
  { data_type => "text", is_nullable => 1 },
  "facebook",
  { data_type => "text", is_nullable => 1 },
  "fb_like",
  { data_type => "integer", is_nullable => 1 },
  "url",
  { data_type => "text", is_nullable => 1 },
  "title",
  { data_type => "text", is_nullable => 1 },
  "website",
  { data_type => "text", is_nullable => 1 },
  "desc",
  { data_type => "text", is_nullable => 1 },
  "location",
  { data_type => "text", is_nullable => 1 },
  "twitter",
  { data_type => "text", is_nullable => 1 },
  "twitter_follower",
  { data_type => "text", is_nullable => 1 },
  "email_newsletter",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2013-03-28 22:07:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3qdMl+9lPrJkLekbAgirNA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/usr/local/share/perl5/Yelp/DB/Schema/Result/Yelp.pm' 
# These lines were loaded from '/usr/local/share/perl5/Yelp/DB/Schema/Result/Yelp.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package Yelp::DB::Schema::Result::Yelp;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Yelp::DB::Schema::Result::Yelp

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::TimeStamp>

=back

=cut

__PACKAGE__->load_components("TimeStamp");

=head1 TABLE: C<yelp>

=cut

__PACKAGE__->table("yelp");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 address

  data_type: 'text'
  is_nullable: 1

=head2 category

  data_type: 'text'
  is_nullable: 1

=head2 neighborhood

  data_type: 'text'
  is_nullable: 1

=head2 rating

  data_type: 'float'
  is_nullable: 1

=head2 phone

  data_type: 'text'
  is_nullable: 1

=head2 review

  data_type: 'text'
  is_nullable: 1

=head2 facebook

  data_type: 'text'
  is_nullable: 1

=head2 fb_like

  data_type: 'integer'
  is_nullable: 1

=head2 url

  data_type: 'text'
  is_nullable: 1

=head2 title

  data_type: 'text'
  is_nullable: 1

=head2 website

  data_type: 'text'
  is_nullable: 1

=head2 desc

  data_type: 'text'
  is_nullable: 1

=head2 location

  data_type: 'text'
  is_nullable: 1

=head2 twitter

  data_type: 'text'
  is_nullable: 1

=head2 twitter_follower

  data_type: 'text'
  is_nullable: 1

=head2 email_newsletter

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "address",
  { data_type => "text", is_nullable => 1 },
  "category",
  { data_type => "text", is_nullable => 1 },
  "neighborhood",
  { data_type => "text", is_nullable => 1 },
  "rating",
  { data_type => "float", is_nullable => 1 },
  "phone",
  { data_type => "text", is_nullable => 1 },
  "review",
  { data_type => "text", is_nullable => 1 },
  "facebook",
  { data_type => "text", is_nullable => 1 },
  "fb_like",
  { data_type => "integer", is_nullable => 1 },
  "url",
  { data_type => "text", is_nullable => 1 },
  "title",
  { data_type => "text", is_nullable => 1 },
  "website",
  { data_type => "text", is_nullable => 1 },
  "desc",
  { data_type => "text", is_nullable => 1 },
  "location",
  { data_type => "text", is_nullable => 1 },
  "twitter",
  { data_type => "text", is_nullable => 1 },
  "twitter_follower",
  { data_type => "text", is_nullable => 1 },
  "email_newsletter",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2013-03-28 22:07:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3qdMl+9lPrJkLekbAgirNA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/usr/local/share/perl5/Yelp/DB/Schema/Result/Yelp.pm' 


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
