# Corzinus
Corzinus is plugin which have logic of cart and checkout. That will be useful for your online-store

1. [Get started](#get-started)
2. [Configuration](#configuration)
3. [What you get?](#what-you-get?)
    - [Cart](#cart)
    - [Checkout](#checkout)
    - [Order](#order)
4. [Demo](#demo)

## Get started

1. On your gemfile: `gem 'corzinus'`
2. Run bundle install
3. Run `rails g corzinus:install` ([configuration](#configuration) corzinus)
4. Run `rails g corzinus MODEL` (Confirm run migration if you didn't do this)
5. Start a server `rails s` and the cart will be available at /cart (if you chose default namespace: /cart)

## Configuration
In `config/initializers/corzinus.rb`
```ruby
...
# Define person class
config.person_class = 'MyUserClass'

# Define checkout steps
config.checkout_steps = [:address, :delivery, :payment, :confirm, :complete]
...
```
### Integration into the templates
```
= form_tag corzinus.order_items_path, method: :post do
  = hidden_field_tag :productable_id, @product.id
  = hidden_field_tag :productable_type, '@product.class.to_s'
  = hidden_field_tag :quantity, 1
  = button_tag 'Add to cart', type: :submit
```

## What you get?

### Cart

With corzinus you get all the functionality of the cart, necessary for a standard online-store

 - cart page with empty or filled condition
 - change the amount of chosen products
 - remove products from the cart
 - apply a coupon code for discount

### Checkout

With corzinus you get opportunity to ordering purchase by checkout. By default checkout has of 5 steps.

 1. `:address` – fill billing and shipping addresses
 2. `:delivery` – choose delivery method by selected shipping address in the previous step
 3. `:payment` – fill credit card requisites
 4. `:confirm` – show info about `:address` `:delivery` `:payment` steps
 5. `:complete` – show success message about finished order and sent a [letter](https://github.com/bezrukavyi/corzinus/blob/Dev/app/views/corzinus/checkout_mailer/complete.html.haml) to the user's mail

`[:address, :delivery, :payment]` – are not required, so you can remove one/all of them
`[:confirm, :complete]` – are required and can not be removed.

`:delivery` depends on the `:address`


#### You also can add [custom step](https://github.com/bezrukavyi/corzinus/wiki/How-i-can-add-custom-step%3F)

### Order
`Corzinus::Order` is base model of Corzinus. It use in `Cart` and `Checkout`.

Order has attributes:
- `string :state`
- `decimal :total_price`
- `boolean :use_base_address`

Order has relationships:
- `person`
- `delivery`
- `credit_card`
- `coupon`
- `order_items`

Order has 5 states by gem [Aasm](https://github.com/aasm/aasm)

| State          | Description                                
| -------------- | -------------------------------------------
| `:in_progress` | User don't complete order (**default state**)
| `:processing`  | User completed order and this order sent to administrator for processing
| `:in_transit`  | Order in transit
| `:delivered`   | Order delivered to the customer (**finish state**)
| `:canceled`    | Canceled by the manager (**finish state**)

More info in [Order](https://github.com/bezrukavyi/corzinus/wiki/Order)

## Demo
#### http://corzinus555.herokuapp.com
#### https://github.com/bezrukavyi/amazon/tree/Corzinus
