# longink
Offline HTML5/iOS/Android/Playbook feed and web page reader

[http://longink.ampdat.com](http://longink.ampdat.com)

* On an iOS or Playbook device, save a bookmark to the desktop to try out offline usage
* Wrap in phonegap, point www folder to the 'client' folder, build and run

## Why?
* I'm addicted to HN.
* I hate the cognitive dissonance of ripping through articles with radically different text styles. 
* My son's school is out of cell range and I like to read articles while waiting in the pickup line.
* I wanted to try on for size a variety of emerging technologies including HTML5, coffee-script, backbonejs, jquery mobile, phonegap and nodejs

## Features
* Pulls latest HN feed from a nodejs server
* Downloads the text of the articles via viewtext.org and stores them using HTML5 offline storage.
* Swipe to go to the next article

## Running locally
* Install nodejs
* npm node-static
* npm coffee-script
* cd longink/server
* coffee server.coffee (coffee run_dev_server.coffee if you want auto re-load ala rails)
* Open a browser to http://localhost:8000

## ToDo
* Switch from storing page content in articles array to separate key'd item on disk...to save disk space
* Scroll to top after swiping right/left