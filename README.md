<pre>
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
</pre>

#How to deploy this app to your environment

<pre>
$ git clone https://github.com/neejgore/crcl1.git
Cloning into crcl1...
remote: Counting objects: 36, done.
remote: Compressing objects: 100% (21/21), done.
remote: Total 36 (delta 7), reused 33 (delta 4)
Unpacking objects: 100% (36/36), done.


$ cd crcl1
$ cpanm --sudo .

$ cd bin

$ perl scrape-yelp.pl --loc "San Francisco, CA" --desc "boutique" --delay 4
</pre>



#Description

This program will simulate yelp.com's search form and save the result into database (SQLite). 

Just before saving information into DB, scraper will also looks for specified informations like:

* Do they have a website?

* Can we find facebook account (likes) in their website ?

* Can we find twitter account (followers) in their website ?

* How many their fb likes or tweet's followers ? 

* Do they have sign up for their newsletter ?

Then save them all !

Note:  You can also dump from database to csv format with <code>--dump</code> option


