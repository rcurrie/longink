# longink
Offline HTML5/iOS/Android/Playbook feed and web page reader

## Features
* Pulls latest HN feed from a nodejs server, downloads the text of the articles via viewtext.org and stores it using HTML5 offline storage.

## Why?
* I'm addicted to HN.
* I hate the cognitive dissonance of ripping through articles with radically different text styles. 
* My son's school it out of cell range and I like to read articles while waiting in the pickup line.
* I wanted to try on for size a variety of emerging technologies including HTML5, coffee-script, backbonejs, jquery mobile, phonegap and nodejs

## Usage
* Install nodejs
* npm node-static
* npm coffee-script
* cd server
* coffee run_dev_server.coffee
* http://localhost:8000

## ToDo
* Switch from storing page content in articles array to separate key'd item on disk...to save disk space
* Scroll to top after swiping right/left

## Depends On
* node-static