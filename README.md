# Corzinus
Corzinus is plugin which have logic of cart and checkout. That will be useful for your online-store

[Get started](#get-started)
[Configuration](#configuration)
[What you will get?](#what-you-will-get?)
  - [Cart](#cart)
  - [Checkout](#checkout)
  - [Corzinus models](#corzinus-components)
    - [Order](#order)
    - [Address](#address)

---

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
config.checkout_steps = [:step_1, :step_2, ... :confirm, :complete]
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

## What you will get?

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
 5. `:complete` – show success message about finished order and sent a [letter](#order-letter) to the user's mail

`[:address, :delivery, :payment]` – are not required, so you can [disable](#disable-step) one/all of them
`[:confirm, :complete]` – are required and can not be removed.

`:delivery` depends on the `:address`


### Corzinus models

#### Order

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

Order has 5 states by aasm

| State          | Description                                
| -------------- | -------------------------------------------
| `:in_progress` | User don't complete order (**default state**)
| `:processing`  | User completed order and this order sent to administrator for processing
| `:in_transit`  | Order in transit
| `:delivered`   | Order delivered to the customer (**finish state**)
| `:canceled`    | Canceled by the manager (**finish state**)

You can change this states by aasm-transactions

| Event          | Changing state                                
| -------------- | -------------------------------------------
| `:confirm`     | from: `:in_progress` to: `:processing`
| `:sent`        | from: `:processing` to: `:in_transit`
| `:delivered`   | from: `:in_transit` to: `:delivered`
| `:cancel`      | from: `:processing` to: `:canceled`

#### Address
Address has attributes:
- `string :first_name`
- `string :last_name`
- `string :name`
- `string :city`
- `string :zip`
- `string :phone`

Address has relationships:
- `addressable`
- `country`

##### Work with relationships
You can use Corzinus helper `include Corzinus::Relatable::Address` for add relationship to your model
```ruby
...
include Corzinus::Relatable::Address

has_addresses # For has_one: :billing and :shipping addresses
has_addres :billing # or :shipping
...
```

##### Work with address form object
You can generate instance variable of form object with Corzinus helpers.
You need include concern `Corzinus::AddressableAttrubutes` in your controller or something else.
```ruby
...
include Corzinus::AddressableAttrubutes
...
```
Then you have:

| Method                         | Description                                
| ------------------------------ | -------------------------------------------
| `addresses_by_model(object)`   | Return form object varibles `@billing` and `@shipping` from the `object` attributes
| `addresses_by_params(params)`  | Return form object varibles `@billing` and `@shipping` from `params`
| `address_by_params(params)`    | Return form object with name `params[:address_type]` from `params`
| `set_countries`                | Return all countries with :id, :name, :code in varible `@countries`

##### Work with address form object
Corzinus use [Rectify::Command](https://github.com/andypike/rectify#commands)
You can update object's address by use command `Corzinus::UpdateAddress`
```ruby
Corzinus::UpdateAddress.call(addressable: user, params: params)
```

##### Full example
You can use corzinus address for your model
Full example for `User`:

In `models/user.rb`:
```ruby
class User < ApplicationRecord
  include Corzinus::Relatable::Address

  has_address :billing # or :shipping
end
```

In `controllers/users_controller.rb`
```ruby
class UsersController < ApplicationController
  include Corzinus::AddressableAttrubutes
  include Rectify::ControllerHelpers

  def edit
    addresses_by_model(current_user) #return instance varibles: @billing and @shipping form objects
    set_countries
  end

  def update
    Corzinus::UpdateAddress.call(addressable: current_user, params: params) do
      on(:valid) do
        redirect_to edit_user_path, notice: 'Success update',
      end
      on(:invalid) do |addresses|
        expose addresses #return instance varibles: @billing and @shipping form objects
        render :edit, alert: 'Failure update'
      end
    end
  end
end
```

In `views/users/edit.html.haml`
```
= simple_form_for @billing, url: user_path, method: :patch do |field|
  = render 'corzinus/addresses/fields', field: field, type: 'billing'
  = field.button :submit, 'Save'
```
