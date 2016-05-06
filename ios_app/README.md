## Installation

To run this app, you should have the following dependencies installed:

* Latest version of Xcode
* iOS 9.3 SDK - `xcodebuild -showsdks`
* RubyMotion (the free version is fine) - http://www.rubymotion.com

## Tutorial

Install the gem:

    gem install redpotion

Create the app:

    potion new memez

This will generate an application directory, install the gem dependencies, then install the CocoaPod dependencies. If you run into any errors, see the troubleshooting section below.

Run the default rake task to run the app in the simulator and make sure everything is working:

    bundle exec rake

Assuming you have the app running without issues, now we can try out the REPL.

```ruby
AFMotion::JSON.get "http://localhost:3000/api/v1/meme_templates" do |response|
  mp response.object
end
```

You will likely see this error:

> App Transport Security has blocked a cleartext HTTP (http://) resource load since it is insecure. Temporary exceptions can be configured via your app's Info.plist file.

We need to add an exception to allow ourselves to access our API over HTTP in development. Add this line to your `Rakefile`:

```ruby
app.info_plist['NSAppTransportSecurity'] = { 'NSAllowsArbitraryLoads' => true } # allow any HTTP request
```

Let's build an API client to start consuming our API. There are model frameworks available, but for this demo we will show how to do this from scratch.

```ruby
class ApiClient
  def self.client
    @client ||= AFMotion::SessionClient.build("http://localhost:3000/api/v1") do
      response_serializer :json
    end
  end
end
```

Next, let's build a `MemeTemplate` model:

```ruby
class MemeTemplate
  attr_accessor :id, :name, :image_url

  def initialize(data)
    @id = data["id"]
    @name = data["name"]
    @image_url = data["image_url"]
  end

  def self.all(&callback)
    ApiClient.client.get "meme_templates" do |response|
      models = nil
      if response.success?
        models = response.object.map do |data|
          new(data)
        end
      end
      callback.call(response, models)
    end
  end
end
```

Now let's build a screen to list our Meme Templates. We can use the RedPotion generator to create a table screen:

    potion g table_screen meme_templates

Open the `app/app_delegate.rb` file and change the line that opens the `HomeScreen`, to open our new `MemeTemplatesScreen`:

```ruby
def on_load(app, options)
  open MemeTemplatesScreen.new(nav_bar: true)
end
```

    potion g screen new_meme
    potion g screen view_meme
    potion g table_screen memes # list all memes

Create a tab bar to be able to navigate to the memes. In `app/app_delegate.rb`:


```ruby
def on_load(app, options)
  open_tab_bar MemesScreen.new(nav_bar: true), MemeTemplatesScreen.new(nav_bar: true)
end
```

### Adding Authentication

Let's enforce authentication for some of our requests. First we'll create a sign in screen.

    potion g screen sign_in

However, this screen is going to be different than our normal screens. We'll use ProMotion-XLForm to create a form screen. Make sure your `Gemfile` includes the `ProMotion-XLForm`. Next, run `bundle install`. Lastly, ProMotion-XLForm relies on a CocoaPod called `XLForm`, so we'll need to install the CocoaPod using `rake pod:install`.

Now let's update our `SignInScreen` to subclass `PM::XlFormScreen`. We'll also specify our form fields:

```ruby
class SignInScreen < PM::XLFormScreen
  title "Sign In"
  stylesheet SignInScreenStylesheet

  def form_data
    [
      {
        cells: [
          {
            title:       'Email',
            name:        :email,
            type:        :email,
            placeholder: 'Enter your email',
            required:    true
          },
          {
            title:       'Password',
            name:        :password,
            type:        :password,
            placeholder: 'Enter your password',
            required:    true
          },
          {
            title: 'Sign In',
            name: :save,
            type: :button,
            on_click: -> (cell) {
              authenticate
            }
          }
        ]
      }
    ]
  end

  def authenticate
    Auth.sign_in(email: values["email"], password: values["password"]) do |response|
      if response.success?
        # TODO
      else
        error_message = response.object["error"] if response.object
        app.alert "Sorry, there was an error. #{error_message}"
        mp response.error.localizedDescription
      end
    end
  end
end
```

### Troubleshooting:

Using Ruby 2.3? Did you see this error?

    NoMethodError: undefined method `to_ary' for #<Pod::Specification name="AFNetworking">

Update your `Gemfile` to use the latest version of `motion-cocoapods`:

    gem "motion-cocoapods", "1.8.0.beta.4"

Run `bundle update motion-cocoapods`, then `bundle exec rake pod:install`, then you should be back to normal.
