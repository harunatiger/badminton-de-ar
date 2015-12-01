# Video::Js::Rails

Video.js is a JavaScript and CSS library that makes it easier to work with and build on HTML5 video


## Installation

Add this line to your application's Gemfile:

    gem 'video-js-rails'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install video-js-rails

Add the resources to your application.js file
    
    //= require video-js

Add the resources to your application.css file

    *= require video-js

## Usage

Add something like this to your view:

    <%= video_player src: { mp4: '/videos/some.mp4' }, controls: true %>

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
