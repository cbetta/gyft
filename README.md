# Ruby API library for the Gyft API

[![Gem Version](https://badge.fury.io/rb/gyft.svg)](https://badge.fury.io/rb/gyft) [![Build Status](https://travis-ci.org/cbetta/gyft.svg?branch=master)](https://travis-ci.org/cbetta/gyft)

A wrapper for the [Gyft API](http://developer.gyft.com). Specification as per the [developer documentation](http://developer.gyft.com/io-docs).

## Installation

Either install directly or via bundler.

```rb
gem 'gyft'
```

## Usage

The gem will either take initializer parameters or environment variables.

```rb
require 'gyft'

# using parameters
client = Gyft::Client.new(api_key: '...', api_secret: '...', environment: 'production')

# using these environment variables are set:
# * GYFT_RESELLER_API_KEY
# * GYFT_RESELLER_API_SECRET
# * GYFT_RESELLER_API_ENVIRONMENT
client = Gyft::Client.new
```

The environment can either be `production` or `sandbox`.

### GET /health/check

```rb
# with a connection
> client.health.check
true

# without a connection
> client.health.check
false
```

### GET /reseller/shop_cards

```rb
> client.reseller.shop_cards
true
```
