# TrueConf Server API Client [![TrueConf](https://circleci.com/gh/paderinandrey/true-conf.svg?style=svg)](https://circleci.com/gh/paderinandrey/true-conf)

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/true/conf`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'true-conf'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install true-conf

## Usage
Initialize a client with `client_id` and `client_secret`:

```ruby
client = TrueConf::Client.new client_id: <client_id>,    # required
                              client_secret: <client_secret>, # required
                              api_server: <server_name>, # required
                              version: '3.2' # optional, default: 3.2
```

```ruby
success?
error?
```

### Conferences


### Users

Helpers methods
```ruby
user = client.users.get(user_id: "09369628")

user.disabled?   => false
user.enabled?    =>  true

user.not_active? => false
user.invalid?    => false
user.offline?    => false
user.online?     => true
user.busy?       => false
user.multihost?  => false
```

### Error



## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/true-conf. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the True::Conf project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/true-conf/blob/master/CODE_OF_CONDUCT.md).
