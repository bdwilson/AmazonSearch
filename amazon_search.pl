#!/usr/bin/perl
# Use the Amazon API to search for the lowest price by ASIN and 
# send a notification via Pushover. Includes all items, see comments
# on how to turn off used/new/3rd party.
# 
# bubba@bubba.org 

use Net::Amazon;
use Data::Dumper;
use LWP::UserAgent;

# Create an application in Pushover put the App ID here
# Use this icon to make it look super special:
# http://www.hmlglaw.com/uploads/images/amazon-icon.png
$pushover_app="ahYwLXowbGvH6TefBu5gy5iQ4Qxxxx";
# Put your user key here
$pushover_user="uszZUqnxg3E2bqLbm5J8w5UCrQxxxx";

# Sign up for an API key here (need Affiliate Program Account)
# https://affiliate-program.amazon.com/gp/advertising/api/detail/your-account.html
# get these from here:
# https://console.aws.amazon.com/iam/home then Access Keys
$amzn_associate_tag = "IHateAds-20";
$amzn_access_key = "AKIAJLDDGSJAGXXXX";
$amzn_secret_key = "UnladknXge/hmqqXdhRta+OGbkiMnOtRealOk";

# Items to search for format = ASIN/Name => Max Price
# Name can be whatever you want.
%searches = ("B00X6A8N1Y/Darth Lego Kit" => "25",
	     "0761168117/Beer Bible" => "10",
	     "B007JR532M/SanDisk Cruzer 32GB" => "8");
# Only notify every x seconds per item. Keeps from getting
# notified over and over again.
$notify_secs = "18000";

my $ua = Net::Amazon->new(
 associate_tag => $amzn_associate_tag,
 token      => $amzn_access_key,
 secret_key => $amzn_secret_key);

sub fix {
	$t = shift;
	$t =~ s/\$//g;
	return $t;
}

foreach my $s (keys %searches) {
	($item,$desc)=split(/\//,$s);
	$file = "/tmp/$item.cache";
	if (-f $file) {
		my $mtime = (stat $file)[9];
		$age = time() - $mtime;
		if ($age > $notify_secs) {
			system("rm -f $file");
		}
	}
	$price = $searches{$s};
	%items=();
	my $response = $ua->search(asin =>"$item");
	if($response->is_success()) {
	    for($response->properties) {
		# comment out to exclude new items
		$items{$item}{'new'}=&fix($_->OurPrice());
		# comment out to exclude 3rd party items
		$items{$item}{'third'}=&fix($_->ThirdPartyNewPrice());
		# comment out to exclude used items
		$items{$item}{'used'}=&fix($_->UsedPrice());
		$count = 0;
		#print Dumper %items;
		foreach my $i (reverse sort keys %{$items{$item}}) {
			if ($items{$item}{$i} =~ /\d+/ && $count == 0 && $items{$item}{$i} <= $price ) {
				if (!-f $file) {
	 				system("touch $file");
					my $message = "$desc is available $i for less than \$" . $price ." ($items{$item}{$i})\n";
					my $subject = "$desc";
					my $link= "http://www.amazon.com/gp/offer-listing/$item";
					&pushover($pushover_app,$pushover_user,$subject,$message,$link);
					$count++;
				}
			}
		}

	     }
	} else {
 		print "Error: ", $response->message(), "\n";
	}
}

sub pushover {
	my $app=shift;
	my $user=shift;
	my $subject=shift;
	my $msg=shift;
	my $link=shift;

	LWP::UserAgent->new()->post(
  	"https://api.pushover.net/1/messages.json", [
  	"token" => "$app",
  	"user" => "$user",
        "title" => "Amazon Price Alert: $subject",
  	"message" => "$msg",
        "url" => "$link",
]);
}
