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
https://developers.trueconf.ru/api/server/#api-Users

**Entities**

```ruby
TrueConf::Entity::User

user = client.by_user(id: "andy").get
user.disabled?   # false
user.enabled?    # true
user.not_active? # false
user.invalid?    # false
user.offline?    # false
user.online?     # true
user.busy?       # false
user.multihost?  # false

```
```ruby
TrueConf::Entity::UserList

```

```ruby
TrueConf::Entity::UserSimple

```
**Actions**
```ruby
users = client.users.all url_type:      "dynamic",     # optional
                         page_id:       1,             # optional
                         page_size:     10,            # optional
                         login_name:    "Andy",        # optional
                         display_name:  "Andy",        # optional
                         first_name:    "",            # optional
                         last_name:     "",            # optional
                         email:         "andy@tb.com"  # optional
# => TrueConf::Entity::UserList

user = client.users.create(**params)
# => TrueConf::Entity::User

user = client.by_user(id: "andy").get
# => TrueConf::Entity::User

user = client.by_user(id: "andy").update(**params)
# => TrueConf::Entity::User

user = client.by_user(id: "andy").delete
# => TrueConf::Entity::UserSimple

user = client.by_user(id: "andy").disconnect
# => TrueConf::Entity::UserSimple
```

### Invitations
https://developers.trueconf.ru/api/server/#api-Conferences_Invitations

**Entities**

```ruby
TrueConf::Entity::Invitation

invitation = client.by_conference(conference_id: "3390770247")
                   .by_invitation(id: "user")
                   .get

invitation.owner?   # true
invitation.user?    # true
invitation.custom?  # false

```
```ruby
TrueConf::Entity::InvitationList
```

```ruby
TrueConf::Entity::InvitationSimple
```

**Actions**
```ruby
# Add Invitation
invitation = client.by_conference(conference_id: "3390770247")
                   .invitations
                   .create(id: "user", display_name: "user")
# => TrueConf::Entity::Invitation

# Get Invitation List
invitations = client.by_conference(conference_id: "3390770247")
                   .invitations
                   .all
# => TrueConf::Entity::InvitationList

# Get Invitation
invitation = client.by_conference(conference_id: "3390770247")
                   .by_invitation(id: "user")
                   .get
# => TrueConf::Entity::Invitation

# Update Invitation
invitation = client.by_conference(conference_id: "3390770247")
                   .by_invitation(id: "user")
                   .update(display_name: "andy")
# => TrueConf::Entity::Invitation

# Delete Invitation
invitation = client.by_conference(conference_id: "3390770247")
                   .by_invitation(id: "user")
                   .delete
# => TrueConf::Entity::InvitationSimple
```

### Error



## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/true-conf. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the True::Conf project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/true-conf/blob/master/CODE_OF_CONDUCT.md).
