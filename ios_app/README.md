## Installation

To run this app, you should have the following dependencies installed:

* Latest version of Xcode
* iOS 9.3 SDK
* RubyMotion (the free version is fine) - http://www.rubymotion.com

## Tutorial

Install the gem:

    gem install redpotion

Create the app:

    potion new memez

This will generate an application directory, install the gem dependencies, then install the CocoaPod dependencies. If you run into any errors, see the troubleshooting section below.

### Troubleshooting:

Using Ruby 2.3? Did you see this error?

    NoMethodError: undefined method `to_ary' for #<Pod::Specification name="AFNetworking">

Update your `Gemfile` to use the latest version of `motion-cocoapods`:

    gem "motion-cocoapods", "1.8.0.beta.4"

Run `bundle update motion-cocoapods`, then `bundle exec rake pod:install`, then you should be back to normal.
