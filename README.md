# ABANDON NOTICE

This gem is no longer maintained. Rails Core supports HStore and JSON fields directly.
You should no longer need this Gem if you are using a newer version of Rails.

# HStore Flags

[![Gem Version](https://img.shields.io/gem/v/hstore_flags.svg)](https://rubygems.org/gems/hstore_flags)
[![License](https://img.shields.io/badge/license-mit-blue.svg)](https://raw.githubusercontent.com/zacheryph/hstore_flags/master/LICENSE)
[![Build Status](https://travis-ci.org/zacheryph/hstore_flags.svg?branch=master)](https://travis-ci.org/zacheryph/hstore_flags)
[![Code Climate](https://codeclimate.com/github/zacheryph/hstore_flags/badges/gpa.svg)](https://codeclimate.com/github/zacheryph/hstore_flags)
[![Test Coverage](https://codeclimate.com/github/zacheryph/hstore_flags/badges/coverage.svg)](https://codeclimate.com/github/zacheryph/hstore_flags/coverage)

integer/bit flags aggrevating you? try this.

## Requirements

* Rails 4.0 or greater
* Postgresql 8.4+ with contrib package
* Read [activerecord-postgres-hstore](https://raw.github.com/engageis/activerecord-postgres-hstore) for index creation

## Installation

_TODO_

## Usage

```ruby
# Add hstore flags column to your table in a migration
def change
  add_column :shipments, :flags, :hstore
end

# defining flags
class User < ActiveRecord::Base
  hstore_flags :active, :admin
  hstore_flags :customer, :vendor, :drop_ship, field: "user_type"
end

class Group < ActiveRecord::Base
  hstore_flags :active, :public, :invite_only, scopes: false
end

# setting flags
u = User.new
u.active = true
u.vendor = false

# automatic scope creation
User.active.to_sql        #=> SELECT * FROM users WHERE (defined(flags, 'active') IS TRUE)
User.not_drop_ship.to_sql #=> SELECT * FROM users WHERE (defined(user_type, 'drop_ship') IS NOT TRUE)
```

* `field` option defaults to `flags`
* `scopes: false` disables scope creation. though im not sure how useful that is

## Contributors

* [Zachery Hostens](https://github.com/zacheryph)
* [Ryan Sonnek](https://github.com/wireframe)
* [Joe Acklin](https://github.com/jacklin10)
* [Andreas Happe](https://github.com/andreashappe)
* [Sven Schwyn](https://github.com/svoop)
