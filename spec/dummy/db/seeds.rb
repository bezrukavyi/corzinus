DAYS = 150
DEMAND = 0..10

10.times do
  TypicalProduct.find_or_create_by!(title: FFaker::Book.title) do |product|
    product.price = rand(10.00..20.00)
    product.inventory = Corzinus::Inventory.create(count: rand(50..100))
  end
end

{ 'Ukraine': '380', 'Russia': '230' }.each do |name, code|
  Corzinus::Country.find_or_create_by!(name: name, code: code)
end

Corzinus::Country.find_each do |country|
  %w(Standart Express).each do |delivery_name|
    Corzinus::Delivery.find_or_create_by!(name: "#{country.name}#{delivery_name}") do |delivery|
      delivery.country = country
      delivery.price = rand(30..100)
      delivery.min_days = rand(5..10)
      delivery.max_days = rand(15..20)
    end
  end
end

TypicalUser.find_or_create_by!(email: 'yaroslav555@gmail.com')

TypicalUser.find_each do |user|
  created_card = Corzinus::CreditCard.find_or_create_by!(person: user) do |card|
    card.number = 5_274_576_394_259_961
    card.name = FFaker::Name.first_name
    card.cvv = '123'
    card.month_year = '12/17'
  end

  country = Corzinus::Country.find(rand(1..Corzinus::Country.count))

  user.shipping = Corzinus::Address.create! do |shipping|
    shipping.address_type = 'shipping'
    shipping.first_name = FFaker::Name.first_name
    shipping.last_name = FFaker::Name.last_name
    shipping.name = FFaker::Address.street_name
    shipping.city = 'Dnepr'
    shipping.zip = 49_000
    shipping.country = country
    shipping.phone = "+#{country.code}632863823"
  end

  user.billing = Corzinus::Address.create! do |billing|
    billing.address_type = 'billing'
    billing.first_name = FFaker::Name.first_name
    billing.last_name = FFaker::Name.last_name
    billing.name = FFaker::Address.street_name
    billing.city = 'Dnepr'
    billing.zip = 49_000
    billing.country = country
    billing.phone = "+#{country.code}632863823"
  end

  DAYS.downto(0) do |day_number|
    date = DateTime.now - day_number.to_i.day

    rand(1..5).times do
      created_order = Corzinus::Order.create! do |order|
        order.credit_card = created_card.dup
        order.shipping = user.shipping.dup
        order.billing = user.billing.dup
        order.delivery = country.deliveries.first
        order.created_at = date
      end

      Corzinus::OrderItem.create do |item|
        item.quantity = rand(DEMAND)
        item.productable_id = rand(1..TypicalProduct.count)
        item.productable_type = 'TypicalProduct'
        created_order.order_items << item
      end

      created_order.confirm!
      user.orders << created_order
    end

    TypicalProduct.all.each do |product|
      product.inventory.add_sale(date)
    end
  end

  user.save!
end
