## Installation

Note: the setup script only works on a Mac.

1. Run [`bin/setup`](https://github.com/andrewhavens/railsconf-2016-demo-mobile-app/blob/master/api/bin/setup) to install the dependencies and set up your database.
2. Start the Rails application server: `bundle exec rails server`

## Tutorial

If you'd like to know how this app was built, follow these steps:

Generate a new Rails app:

    rails new memez

Add these gems to your `Gemfile` then run `bundle install`:
```ruby
gem "devise"
gem "active_model_serializers"
gem "le_meme"
```

Generate a controller for our Meme Templates:

    rails g controller api/v1/meme_templates index

Generate our Meme Template model (without a namespace):

    rails g model meme_template name image_url

Generate a serializer for our Meme Template JSON response:

    rails g serializer meme_template name image_url

Update the `config/routes.rb` file to be:

```ruby
namespace :api, defaults: { format: :json } do
  namespace :v1 do
    resources :meme_templates, only: [:index]
  end
end
```

Update our `meme_templates_controller.rb` to have an index action which returns all of the Meme Templates:

```ruby
def index
  meme_templates = MemeTemplate.all
  render json: meme_templates
end
```

Migrate the database and seed the database with some Meme Templates:

    bundle exec rake db:migrate
    bundle exec rake db:seed

Generate the Memes resource:

    rails g resource meme name meme_template:belongs_to

Open `config/routes.rb` and move our new route within our api/v1 namespace:

```ruby
namespace :api, defaults: { format: :json } do
  namespace :v1 do
    resources :meme_templates, only: [:index]
    resources :memes
  end
end
```

We'll also need to move the controller to the right place:

    mv app/controllers/memes_controller.rb app/controllers/api/v1/

...and update the class name to `Api::V1::MemesController`.

Update your `application_controller.rb` to not use CSRF protection:

```ruby
protect_from_forgery with: :null_session
```

## Adding Authentication

Add `devise` to your `Gemfile` and run `bundle install`.

Use the Devise generator and create the `User` model.
```
bundle exec rails g devise:install
bundle exec rails g devise User
bundle exec rails g migration AddAuthTokenToUsers authentication_token:index
bundle exec rake db:migrate
```

Add these lines to your `User` model so that every user has a unique auth token:
```ruby

before_save do
  if authentication_token.blank?
    self.authentication_token = generate_authentication_token
  end
end

def generate_authentication_token
  loop do
    token = Devise.friendly_token
    break token unless User.where(authentication_token: token).first
  end
end
```

We'll need to update our route in order to namespace our sign in route:

```ruby
namespace :api, defaults: { format: :json } do
  namespace :v1 do
    devise_for :users, singular: :user, controllers: {
      sessions: 'api/v1/sessions'
    }
  end
end
```

Create a new controller at `app/controllers/api/v1/sessions_controller.rb` to override the `Devise::SessionsController` to return our user's auth token in the response:

```ruby
class Api::V1::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    super do |user|
      data = {
        token: user.authentication_token,
        email: user.email
      }
      render json: data, status: 201 and return
    end
  end
end
```

In your `application_controller.rb`, add this method to support token-based authentication:

```ruby
before_action :authenticate_user_from_token!

def authenticate_user_from_token!
  authenticate_with_http_token do |token, options|
    user = User.find_by(email: options.fetch(:email))
    if user && Devise.secure_compare(user.authentication_token, token)
      sign_in user, store: false
    end
  end
end
```

That method doesn't require authentication, so if you want to protect a route, add this line to the controllers that you want to protect:

```
before_action :authenticate_user!
```
