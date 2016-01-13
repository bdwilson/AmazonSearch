Amazon Search
=======
<br>
This script allows you to search for certain Amazon ASIN's and be notified 
(via [Pushover](https://pushover.net/)) when a price falls below your
threshold.

Requirements
------------
- Linux system (or Raspberry Pi)
- [Pushover account](https://pushover.net/) - You will also need to [register
  an application](https://pushover.net/apps/build) and you can use my logo
(https://pushover.net/icons/TKeuSZYBwATtanz.png). There is a free trial period
available so you can see if you like the app; it's awesome and definately money
well spent.
- Perl (and these modules: Net::Amazon LWP::UserAgent Data::Dumper)

I recommend installing [cpanminus](https://github.com/miyagawa/cpanminus) and
installing the Perl modules that way, or you can intall them via your distro
packaging system.
<pre>
sudo apt-get install curl
curl -L http://cpanmin.us | perl - --sudo App::cpanminus
</pre>

Then install the modules..
<pre>
sudo cpanm Net::Amazon LWP::UserAgent Data::Dumper
</pre>

Installation
--------------------
1. Install Perl modules.
2. Create an app within [Pushover](http://pushover.net) and get the app key and
your user key. 
3. Create/Retrieve your [Amazon API
information](https://affiliate-program.amazon.com/gp/advertising/api/detail/your-account.html)
and fill in the info in the script.  You need to create an affiliate account
and get your affiliate ID as well. 
4. Get the items you want to search for and extract the ASIN ID from the URL.
When adding these to the script the format is ''ASIN/Whatever name you give
your search'' and then the threshold amount. 
5. Adjust the notify threshold to how often you want to be bugged about a price
reaching it's threshold (this is per-item).  
6. (Optional): If you only want new, used, or 3rd party items, look in the code
for the comments and comment out the types you DON'T want.
7. Setup a cronjob for every 5 minutes or so. 

Bugs/Contact Info
-----------------
Bug me on Twitter at [@brianwilson](http://twitter.com/brianwilson) or email me [here](http://cronological.com/comment.php?ref=bubba).

