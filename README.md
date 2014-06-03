Motion1
=======

Salesforce1 is a revolutionary new interface for Salesforce that is not only gorgeous, but for many use cases it's faster! Unfortunately, Salesforce1 is understood by many to be a mobile only interface, available only on iOS and Android devices. Motion1 changes that. With Motion1, Mac users running OS X on their desktops and laptops, can securely log into their Salesforce orgs and utilize the Salesforce1 interface. 

## All the features of Salesforce1 that we've come to know and love are present here: 
+ Push Notifications *If your org has them enabled.*
+ Org Admin controlled object and app settings
+ SF1 Enabled Apps like TaskRay
+ The Tasks and Dashboards apps
+ Publisher Actions 

## In addition to all that, Motion1 has a few extra tricks up it's sleeve:
+ Motion1 is multi-org by default. You can log into 1 or all of your orgs. Simply use the file menu and select the type of org you want to log into. At the moment, Production (which includes developer and my-Domain orgs), Sandbox and Pre-Release orgs are supported. 
+ Native app integration for Mail. Use Mail.app to write emails? when you click on an email link in Motion1, the link is transparently handed off to your selected Mail client. 

## Sadly, somethings don't work yet:
+ You can't make a call from within Motion1, at least until osX 10.10 Yosimite is released this fall.
+ You can't login to the Success Community (yet)

## How does it work?
Motion1 utilizes RubyMotion to present X number of windows to the user, each with a predefined login url to either a production (login.salesforce.com) or sandbox (test.salesforce.com) and Salesforce presents their standard login form. Once your credentials are submitted to Salesforce (** At no time does Motion1 access, or store your credentials**) and you're successfully authenticated, the App directs you to /one/one.app the web formatted version of Salesforce1. Each window remains independent -- credentials are silo'd to the window presenting that org. 

## Why? 
I hate Chatter desktop. Actually thats not true. I don't like flex / flash and the adobe bit that powers Chatter desktop has always poked my "can you do it better?" brain spot. Additionally, I wanted something that was multi-org. I didn't want to keep multipe browser's or multiple private browsing tabs open to stay in touch with the 5 orgs I'm regularly in. This is a step in the right direction at least. In additition to it's utility as a replacement for Chatter desktop, here are some other things you can do with it:
+ It's a much more lightweight "simulator" when your developing a SF1 mobile app. 
+ It's a great way to have multiple logins (as different roles / profiles) into the same org to see how objects and apps behave
+ It's resizeable to emulate various Android screen sizes/resolutions

## How can I help?
+ File bug reports that tell me how to reproduce the issue regardless of the org I log into. If an issue is only reproduceable in your org ... hard to help. You can file issues here: [https://github.com/noeticpenguin/Motion1/issues]
+ Come up with awesome ideas of what to do next. File an issue!
+ Edit the wiki!
+ Buy me a beer, or whatever.
+ Hey, I just met you, and I know this sounds crazy, But here's my GitTip [https://www.gittip.com/noeticpenguin/] so Tip me, maybe?