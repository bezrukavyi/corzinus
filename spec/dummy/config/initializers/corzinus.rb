Corzinus.setup do |config|
  # Define person class
  config.person_class = 'TypicalUser'

  # Define checkout steps
  config.checkout_steps = [:address, :delivery, :payment, :confirm, :complete]
end
