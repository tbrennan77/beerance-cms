BeeranceApp
===========
***

About
-----

This is a simple Rails 3 app that uses [parse_resource](http://github.com/adelevie/parse_resource) for model persistence. The app is designed to allow bar owners to sign up for a paid account (payments are integrated with [Stripe.com](http://stripe.com)) that allows them to publish "Beerance" sales to the iOS application "Beerance".

Setup
-----

For this app to function in any environment the following configuration/accounts need to be established:

1. Create a [Stripe.com](https://stripe.com/) account.

2. Create a [Parse.com](https://parse.com/) account. Once you have the Parse.com account you will need to make a "Parse App" for each environment you wish to use.

***The below example files should be replaced and updated with the correct credentials***

```bash
cp config/initializers/stripe.rb.example config/initializers/stripe.rb
```

```bash
cp config/parse_resource.yml.example config/parse_resource.yml
```

Testing
-------

Due to using Parse.com as the database, testing requires a test account to be setup with Parse. Test::Unit is currently being used and can be run by simply calling ```rake``` from the application root.

Rake Tasks
----------

There are a number of rake tasks available to aid development and testing.

### Development

**Sets up default subscription plans in development.**

```bash
rake parse:dev:setup
```


### Testing

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

## Credits

[![Boondock Walker](https://farm4.staticflickr.com/3684/9677153149_c7f7cac09d_o.png)](http://www.boondockwalker.com)

BeeranceApp is maintained by [Boondock Walker](http://www.boondockwalker.com)

## License

BeeranceApp is Copyright © 2013 Dillon Hafer and Boondock Walker, LLC. It is free software, and may be redistributed under the terms specified in the MIT-LICENSE file.
