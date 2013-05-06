BeeranceApp
===========

About
-----

This is a simple Rails 3 app that uses [parse_resource](http://github.com/adelevie/parse_resource) for model persistence. The app is designed to allow bar owners to sign up for a paid account (payments are integrated with [Stripe.com](http://stripe.com)) that allows them to publish "Beerance" sales to the iOS application "Beerance".

Testing
-------

Due to using Parse.com as the database, testing requires a test account to be setup with Parse. Test::Unit is currently being used and can be run by simply calling ```rake``` from the application root.

Rake Tasks
==========

There are a number of rake tasks available to aid development and testing.

Development
-----------

**Sets up default subscription plans in development.**

```bash
rake parse:dev:setup
```


Testing
-------

**Sets up mock database records.**

```bash
rake parse:test:prepare
```

**Completely dump all data in the test database.**

```bash
rake parse:test:clean
```

**Completely dump all data in the test database and prepare it.**

```bash
rake parse:test:all
```

Copyright
---------

Copyright (c) 2013 Boondock Walker.