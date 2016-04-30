# RailsConf 2016 Demo

This repository contains the code used in the RailsConf 2016 "Learn how to build a Rails API-Backed Mobile App with RubyMotion" workshop.

The demo app allows you to create and save your own memes.

* The `api` directory contains the code for the API.
* The `ios_app` directory contains the code for the iOS app.

To learn how these apps were built, each directory contains a tutorial:
* [API Tutorial](https://github.com/andrewhavens/railsconf-2016-demo-mobile-app/blob/master/api/README.md)
* [iOS App Tutorial](https://github.com/andrewhavens/railsconf-2016-demo-mobile-app/blob/master/ios_app/README.md)

To run the API:
```
cd api
bin/setup
bundle exec rails server
```

To run the iOS app in the simulator:
```
cd ios_app
bundle install
bundle exec rake pod:install
bundle exec rake
```
