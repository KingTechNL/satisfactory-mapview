# Map service for satisfactory server

[Satisfactory calculator](https://satisfactory-calculator.com/) can load a custom map if you access it with the url `https://satisfactory-calculator?url=<my_url>`. Where your browser needs to be able to access `<my_url>` (i.e., download the file) and the CORS policy needs to be set properly.
Since this can be a pain to setup, we created a docker image that takes care of most of the work for you.

> Note: Since this system relies on your server saving the game, this is not a truly 'live' view. With the default autosave time this view can be up to 5 minutes late.

> Note: This docker image is heavily inspired by [this repository](https://github.com/jmigual/satisfactory-server-with-map) and automatically build/published using the KingTechNL GitHub Actions.

![example image](example-map.png)

## Getting started
In order to get a live-view of your server, simply add the [kingtechnl/satisfactory-mapview](https://hub.docker.com/r/kingtechnl/satisfactory-mapview) image to your docker environment, mount the satisfactory savegame directory to the container and pass the URL you want to use in the environment variables. Now route your favorite proxy (e.g. nginx proxy manager or traefik) to the image, and you're done. 

An example docker-compose:
```yaml
version: "3.8"

services:
  satisfactory-map:
    container_name: 'satisfactory-mapview'
    hostname: 'satisfactory-mapview'
    image: kingtechnl/satisfactory-mapview:latest
    ports:
      - 8002:80
    environment:
      - USER_DOMAIN=satisfactory.kingtech.nl
      - SCHEME=https
    volumes:
      - '/root/satisfactory/saved/server:/var/www/html/saves:ro'
```

### Environment variables:
The compose file features a couple of environment variables to configure it:
- USER_DOMAIN: This is the domain name you want people to use to reach your map view.
- SCHEME: The scheme that is used (http/https), default = https.
- SAVE_NAME: The name for the symlink that is created internally, default = latest.sav. This feature doesnt always play nice.

## How does it work

What we do is we create an nginx server that provides two urls:
- `mydomain.com/saves/*`: This one serves any savefile of the satisfactory server such that it can be downloaded.
- `mydomain.com`: This one redirects to `https://satisfactory-calculator?url=https://mydomain.com/saves/latest.sav`.

The save `latest.sav` is a symlink created by the `satisfactory-latest` docker image which runs a cronjob on the saves folder and updates the the symlink to point to the last modified save. See `build-scripts/satisfactory-latest` for the details of how the symlink is created. 