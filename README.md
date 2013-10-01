# CarrierWave::ImageOptimizer example

### Steps to reproduce this app:

Install the following utilities for optimizing images:

1. jpegoptim: installed from [freecode.com](http://freecode.com/projects/jpegoptim)

2. OptiPNG: installed from [sourceforge.net](http://optipng.sourceforge.net/)

Or install the utilities via homebrew:

```bash
$ brew install optipng jpegoptim
```

#### Clone this repo or build from scratch via the following commands:

Create new Rails app:

```bash 
$ rails new carrierwave_imageoptimizer_example
```

Add [carrierwave](https://github.com/carrierwaveuploader/carrierwave/) and 
[carrierwave-imageoptimizer](https://github.com/jtescher/carrierwave-imageoptimizer) to the Gemfile:

```bash
$ echo "gem 'carrierwave', '~> 0.9.0'" >> Gemfile
$ echo "gem 'carrierwave-imageoptimizer', '~> 1.0.1'" >> Gemfile
$ bundle install
```

Add User model and mount an uploader:

```bash
$ rails generate model user
$ rails generate uploader Avatar 
$ rails generate migration add_avatar_to_users avatar:string
$ bundle exec rake db:migrate
```

Add CarrierWave::ImageOptimizer to the uploader `app/uploaders/avatar_uploader.rb`
```ruby
class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::ImageOptimizer
  process :optimize
  ...  
end
```

Mount the uploader in User `app/models/user.rb`
```ruby
class User < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
end
```

Add test images:

```bash
$ mkdir vendor/assets/images
$ curl http://ie.microsoft.com/testdrive/Graphics/ImageSupport/jpeg.jpg -o 'vendor/assets/images/monkey.jpg'
$ curl http://fc05.deviantart.net/fs70/f/2012/035/4/4/png_dog_by_rebeccabekybeka-d4onood.png -o 'vendor/assets/images/dog.png' 
```

### Steps to try image optimization

Start the rails console:

```bash
$ rails console
```

Add eiter image to the user avatar (vendor/assets/images/dog.png or vendor/assets/images/monkey.jpg):

```ruby
user = User.new
user.avatar = File.open('vendor/assets/images/dog.png')
user.save!
```

Check `public/uploads/user/avatar/1/dog.png` to see the optimized version 
(328023 bytes to 204563 bytes 37.64% decrease in my case)
