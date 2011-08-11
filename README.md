# rack-mongrel2

The only Mongrel2 Rack handler you'll ever need.

I wrote this because I wanted to learn Mongrel2, and I didn't like what was out there. I copy-pasted a lot of code from Colin Curtin's m2r project (http://github.com/perplexes/m2r), but I also changed and reorganized it into what I believe is a good setup for a proper rubygem.

## How to use

1. Get mongrel2 installed (http://mongrel2.org/wiki?name=GettingStarted)
1. Get your config for mongrel2 setup (see example directory)
1. Add it to your Gemfile

    gem 'rack-mongrel2', '~> 0.2.0', :require => nil

1. You also need some sort of JSON parsing library installed, like Yajl or JSON (gem i yajl-ruby or gem i json). json-jruby will work too
1. Run Mongrel2
1. Run your rails application

    RACK_MONGREL2_UUID=<my uuid> rails s Mongrel2

1. Profit!

Check out the blog post too: http://blog.darkhax.com/2010/10/26/deploying-your-ruby-app-with-mongrel2

## Advanced setup

### Using custom send and receive socket values

The Mongrel2 rack handler defaults the receive socket to `tcp://127.0.0.1:9997` and the send socket to `tcp://127.0.0.1:9996`. 

To use different values set the `RACK_MONGREL2_RECV` and `RACK_MONGREL2_SEND` environment variables. For example: 

    export RACK_MONGREL2_RECV=<mongrel2 handler send_spec value>
    export RACK_MONGREL2_SEND=<mongrel2 handler recv_spec value>
    export RACK_MONGREL2_UUID=<mongrel2 handler send_ident value>
    rails server Mongrel2

If for example your Mongrel2 handler configuration contains:

    ...
    recv_spec='tcp://127.0.0.1:7771'
    send_spec='tcp://127.0.0.1:7772',
    send_ident='42ffdda3-d151-41b1-923f-899ef6fc530a',
    ...

Then you will need to start your Rails application using:

    export RACK_MONGREL2_RECV=tcp://127.0.0.1:7772
    export RACK_MONGREL2_SEND=tcp://127.0.0.1:7771
    export RACK_MONGREL2_UUID=42ffdda3-d151-41b1-923f-899ef6fc530a
    rails server Mongrel2

## Thanks!

* [Kevin Williams](https://github.com/kevwil) for PULL, specs, and other things.

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010, 2011 Daniel Huckstep. See LICENSE for details.
