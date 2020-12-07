# TrueConf Server API Client

[![Gem Version][gem-badger]][gem]
[![TrueConf](https://circleci.com/gh/paderinandrey/true-conf.svg?style=svg)](https://circleci.com/gh/paderinandrey/true-conf)

[gem-badger]: https://img.shields.io/gem/v/true-conf.svg?style=flat&color=blue
[gem]: https://rubygems.org/gems/true-conf
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
The TrueConf API uses OAuth2 or API Key to authenticate API request. By defaut, a OAuth2 client will be used.

```ruby
# OAuth
response = TrueConf::Client.new auth_method:   'oauth', # default: oauth
                                client_id:     '<client_id>',    # required
                                client_secret: '<client_secret>', # required
                                api_server:    '<server_name>', # required
                                version:       '3.2' # optional, default: 3.2

# API Key
response = TrueConf::Client.new auth_method:   'api_key',
                                api_key:       '<api_key>', # required
                                api_server:    '<server_name>', # required
                                version:       '3.2' # optional, default: 3.2

# => TrueConf::Client
response.success?
response.error?
```

### Conferences
https://developers.trueconf.ru/api/server/#api-Conferences

```ruby
params = {
    topic: "My first conference"
    owner: "andy@example.com",
    type: 0,
    schedule: { type: -1 }
}

conference = client.conferences.create(**params)
# => TrueConf::Entity::Conference

conference = client.by_conference(conference_id: 12345).get
# => TrueConf::Entity::Conference

conference = client.by_conference(conference_id: 12345).update(**params)
# => TrueConf::Entity::Conference

conference = client.by_conference(conference_id: 12345).delete
# => TrueConf::Entity::ConferenceSimple

conference = client.by_conference(conference_id: 12345).start
# => TrueConf::Entity::ConferenceSimple

conference = client.by_conference(conference_id: 12345).stop
# => TrueConf::Entity::ConferenceSimple
```

### Users
https://developers.trueconf.ru/api/server/#api-Users

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
user.disabled?   # false
user.enabled?    # true
user.not_active? # false
user.invalid?    # false
user.offline?    # false
user.online?     # true
user.busy?       # false
user.multihost?  # false

user = client.by_user(id: "andy").update(**params)
# => TrueConf::Entity::User

user = client.by_user(id: "andy").delete
# => TrueConf::Entity::UserSimple

user = client.by_user(id: "andy").disconnect
# => TrueConf::Entity::UserSimple
```

### Invitations
https://developers.trueconf.ru/api/server/#api-Conferences_Invitations

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

invitation.owner?   # true
invitation.user?    # true
invitation.custom?  # false

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

### Records
https://developers.trueconf.ru/api/server/#api-Conferences_Records
```ruby
records = client.by_conference(conference_id: "3390770247").records.all
# => TrueConf::Entity::RecordList

record = client.by_conference(conference_id: "3390770247").by_record(id: 12345).get
# => TrueConf::Entity::Record

record = client.by_conference(conference_id: "3390770247").by_record(id: 12345).download
# => TrueConf::Entity::Record
```
### Calls
https://developers.trueconf.ru/api/server/#api-Logs

```ruby
calls = client.logs.calls.all()
# => TrueConf::Entity::CallList

call = client.logs.by_call(id: "3390770247").get
# => TrueConf::Entity::Call

participants = client.logs.by_call(id: "3390770247").participants
# => TrueConf::Entity::CallParticipantList
```

## Contributing
Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/paderinandrey/true-conf/issues)
- Fix bugs and [submit pull requests](https://github.com/paderinandrey/true-conf/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
