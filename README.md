# Ruby API library for the Gyft API

[![Gem Version](https://badge.fury.io/rb/gyft.svg)](https://badge.fury.io/rb/gyft) [![Build Status](https://travis-ci.org/cbetta/gyft.svg?branch=master)](https://travis-ci.org/cbetta/gyft)

A wrapper for the [Gyft API](http://developer.gyft.com). Specification is as described in the the [developer documentation](http://developer.gyft.com/io-docs).

## Installation

Either install directly or via bundler.

```rb
gem 'gyft'
```

## Getting started

The client will accept the API key and secret either as parameters on initialization,
or as environment variables. Additionally an `environment` parameter can be set to either
`sandbox` (default) or `production`.

```rb
require 'gyft'

# using parameters
client = Gyft::Client.new(api_key: '...', api_secret: '...', environment: 'production')

# using environment variables:
# * GYFT_API_KEY
# * GYFT_API_SECRET
# * GYFT_API_ENVIRONMENT
client = Gyft::Client.new
```

The client provides with direct access to every API call as documented in the
developer documentation. Additionally it also provides some convenience methods.

```rb
# get a card to purchase
card = client.cards.first
# purchase the card for someone
transaction = card.purchase(to_email: 'customer@example.com')
# load more details on the transaction
transaction = transaction.reload
# refund the transaction
transaction.refund
```

## Convenience methods

### `client.cards`

Maps to `client.reseller.shop_cards`, allows for easier access and a less
verbose DSL.

### `card.purchase`

Maps to `client.partner.purchase.gift_card_direct` and passes along all the
same parameters while automatically setting the `shop_card_id`.

### `transaction.reload`

The purchase method returns an incomplete transaction object. This convenience
methods calls `client.reseller.transaction.find` passing along the transaction
`id` and returning a new `Gyft::Transaction` object.

### `transaction.refund`

Maps to `client.reseller.transactions.refund` and automatically passes along
the transaction `id`.

## API

### `GET /health/check`

```rb
# with a connection
> client.health.check
true

# without a connection
> client.health.check
false
```

### `GET /reseller/shop_cards`

Returns the shop cards available for purchase.

```rb
> cards = client.reseller.shop_cards
[#<Gyft::Card id=123, merchant_id="123", ...>, ...]
> cards.first
Gyft::Card {
                            :id => 3028,
                   :merchant_id => "211-1346844972352-24",
                 :merchant_name => "Foot Locker",
              :long_description => "<p>Foot Locker is ...</p>",
            :card_currency_code => "USD",
               :opening_balance => 50.0,
     :merchant_card_template_id => 3750,
            :cover_image_url_hd => "http://imagestest.gyft.com/merchants_cards/c-211-1346844972355-64_cover_hd.png",
    :merchant_icon_image_url_hd => "http://imagestest.gyft.com/merchants/i-211-1346844972353-0_hd.png"
}
```

### `GET /reseller/categories`

Returns all of the categories.

```rb
> categories = client.reseller.categories
[#<Gyft::Category id=4, name="Babies & Children">, ... ]
> categories.first
Gyft::Category {
      :id => 4,
    :name => "Babies & Children"
}
```

### `GET /reseller/merchants`

Returns all of the merchants.

```rb
> merchants = client.reseller.merchants
[#<Gyft::Merchant id="123", name="foobar.com", ...>, ... ]
> merchants.first
Gyft::Merchant {
                       :id => "1406228802381_103",
                     :name => "1-800-Baskets.com",
              :description => "Gift baskets for every occasion. ",
         :long_description => "<p>1-800-Baskets has ...</p>",
             :country_code => "US",
           :homepage_label => "Go to 1800baskets.com",
             :homepage_url => "http://www.1800baskets.com",
              :facebook_id => "229053644398",
               :twitter_id => "1800baskets",
                :google_id => "+1800baskets",
               :shop_cards => [#
        [0] Gyft::Card {
                         :id => 4456,
              :currency_code => "USD",
                      :price => 25.0,
            :opening_balance => 25.0
        },
        [1] Gyft::Card {
                         :id => 4461,
              :currency_code => "USD",
                      :price => 50.0,
            :opening_balance => 50.0
        }
    ],
               :categories => [
        [0] Gyft::Category {
              :id => 12,
            :name => "Home Goods"
        }
    ],
               :meta_title => "Buy 1-800-Baskets.com Gift Cards | Gyft",
         :meta_description => "1-800-Baskets.com",
           :min_card_value => 25.0,
           :max_card_value => 50.0,
       :cover_image_url_hd => "http://imagestest.gyft.com/merchants_cards/default-08_cover_hd.png",
          :google_plus_url => "https://plus.google.com/+1800baskets",
              :twitter_url => "https://twitter.com/1800baskets",
                :card_name => "1-800-Baskets.com",
                 :icon_url => "http://imagestest.gyft.com/merchants/1-800-baskets_hd.png",
    :legal_disclaimer_html => "...",
             :facebook_url => "http://www.facebook.com/229053644398"
}
```

### `GET /reseller/account`

Returns details of the reseller's account.

```rb
> account = client.reseller.account
Gyft::Account {
                      :id => "abc123",
       :global_shop_cards => true,

                :username => "foobar",
                    :name => "FooBar",
        :application_name => "FooBar",
            :contact_name => "FooBar Developer",
           :contact_email => "foo@example.com",
                 :balance => 50000.0,
    :balance_updated_when => 1469051680000
}
```

### `GET /reseller/transactions`

Returns a list of all the transactions for the reseller.

```rb
> transactions = client.reseller.transactions.all
[#<Gyft::Transaction id=123, type=1, amount=25.0, created_when=1469034701000>, ...]
> transactions.first
Gyft::Transaction {
              :id => 123,
            :type => 1,
          :amount => 25.0,
    :created_when => 1469034701000
}
```

### `GET /transactions/last/:number_of_records`

Returns a limited list of recent transactions for the reseller.

```rb
> transactions = client.reseller.transactions.last(1)
[#<Gyft::Transaction id=123, type=1, amount=25.0, created_when=1469034701000>]
> transactions.first
Gyft::Transaction {
              :id => 123,
            :type => 1,
          :amount => 25.0,
    :created_when => 1469034701000
}
```

### `GET /transactions/first/:number_of_records`

Returns a limited list of initial transactions for the reseller.

```rb
> transactions = client.reseller.transactions.first(1)
[#<Gyft::Transaction id=122, type=1, amount=25.0, created_when=1469034701000>]
> transactions.first
Gyft::Transaction {
              :id => 122,
            :type => 1,
          :amount => -25.0,
    :created_when => 1469034701000
}
```

### `GET /transaction/:id`

Returns a full details for a sent transaction

```rb
> client.transactions.find(123)
Gyft::Transaction {
                     :id => 123,
          :merchant_name => "Grotto",

                 :amount => 25.0,
                :sent_to => "customer@example.com",
         :auto_delivered => "N",
               :revealed => "N",
            :gift_status => 6,
            :card_status => 0,
    :transaction_created => 1469034701000,
           :gift_created => 1469034701000
}
```

### `POST /transaction/refund`

Refund transaction and get card details.

```rb
> client.transactions.refund(123)
Gyft::Refund {
                            :id => "OTlkOGM1...k5W",
                        :status => 0,

                :gf_reseller_id => "abc123",
    :gf_reseller_transaction_id => 123333,
                         :email => "client@example.com",
                   :gf_order_id => 123456,
            :gf_order_detail_id => 345678,
             :gf_gyfted_card_id => 678997,
                   :invalidated => false
}
```

### `POST /partner/purchase/gift_card_direct`

Purchase a gift card returning a direct link to the card.

```rb
> client.partner.purchase.gift_card_direct(
      to_email: 'customer@example.com',
      shop_card_id: 1234
  )

Gyft::Transaction {
     :id => 1250483,
    :url => "https://staging.gyft.com/card/#/?c=...."
}
```

## Contributing

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull request** so that we can review your changes

### Development

* `bundle install` to get dependencies
* `rake` to run tests
* `rake console` to run a local console with the library loaded

## License

This library is released under the [MIT License](LICENSE).
