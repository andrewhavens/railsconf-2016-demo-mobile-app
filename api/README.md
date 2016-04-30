## Installation

1. Run `bin/setup` to install the dependencies and set up your database.
2. Start the Rails application server: `bundle exec rails server`

## Tutorial

If you'd like to know how this app was built, follow these steps.

Add these lines to your `Gemfile`:
```ruby
gem "devise"
gem "paperclip", "~> 4.3"
```

```
bundle install
bundle exec rails generate devise:install
rails generate devise User
bundle exec rails g scaffold meme
bundle exec rails generate paperclip meme image
bundle exec rake db:migrate
```

Set an expiration on the session cookie, otherwise our session will expire every time the iOS app is closed:
```ruby
Rails.application.config.session_store :cookie_store, key: '_memez_session', expire_after: 1.year
```
Update `app/controllers/application_controller.rb` and add this line to require all routes to be authenticated:

```ruby
skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

before_action :authenticate_user!
```

Update `config/routes.rb` to make `root "memes#index"`.

Add this line to `app/models/meme.rb`:

```ruby
has_attached_file :image
validates_attachment :image, content_type: { content_type: /\Aimage/ }
```

Add this line to `app/views/memes/_form.html.erb`:

```
<%= f.file_field :image %>
```

Update `app/controllers/memes_controller.rb` to allow our `:image` param:

```ruby
def meme_params
  params.require(:meme).permit(:image)
end
```

Add the ability to view our uploaded image by adding this line to `app/views/memes/show.html.erb`:

```
<p><%= image_tag @meme.image.url %></p>
```

Add the `image_url` to our json response by adding this line to `app/views/memes/index.json.jbuilder`:

```ruby
json.image_url meme.image.url
```

...and this to our `app/views/memes/show.json.jbuilder`:

```ruby
json.image_url @meme.image.url
```

Start the app server:
```
bundle exec rails s -p 9999
```

Note that our iOS app expects the app to be running on port 9999.

Optional: Add these lines to `app/views/layouts/application.html.erb`:

```html
<% if user_signed_in? %>
<%= link_to 'Logout', destroy_user_session_path, method: :delete %>
<% else %>
<%= link_to 'Login', new_user_session_path %>
<% end %>

<p id="notice"><%= notice %></p>
<p id="alert"><%= alert %></p>
```
