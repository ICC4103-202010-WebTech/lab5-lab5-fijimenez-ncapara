namespace :db do
  task :populate_fake_data => :environment do
    # If you are curious, you may check out the file
    # RAILS_ROOT/test/factories.rb to see how fake
    # model data is created using the Faker and
    # FactoryBot gems.
    puts "Populating database"
    # 10 event venues is reasonable...
    create_list(:event_venue, 10)
    # 50 customers with orders should be alright
    create_list(:customer_with_orders, 50)
    # You may try increasing the number of events:
    create_list(:event_with_ticket_types_and_tickets, 3)
  end
  task :model_queries => :environment do
    # Sample query: Get the names of the events available and print them out.
    # Always print out a title for your query
    puts("Query 0: Sample query; show the names of the events available")
    result = Event.select(:name).distinct.map { |x| x.name }
    puts(result)
    puts("EOQ") # End Of Query -- always add this line after a query.
    puts("Query 1: Report the total number of tickets bought by a given customer")
    puts("For example we searched for Customer with id=2")
    result = Customer.where(id:2).joins(:tickets).count
    puts(result)
    puts("EOQ")
    puts("Query 2: Report the total number of different events that a given customer has attended.\nFor example we searched for customer with id=2")
    result = Event.joins(ticket_types:{tickets:{order: :customer}}).where(customers:{id:2}).distinct.count
    puts(result)
    puts("EOQ")
    puts("Query 3: Names of the events attended by a given customer.\nFor example we searched for customer with id=2.")
    result = Event.joins(ticket_types: {tickets: {order: :customer}}).where(customers: { id:2}).distinct.map {|x| x.name}
    puts(result)
    puts("EOQ")
    puts("Query 4: Total number of tickets sold for an event.\nFor example we searched for event with id=2.")
    result = Event.where(id:2).joins(ticket_types: :tickets).count
    puts(result)
    puts("EOQ")
    puts("Query 5: Total sales of an event.\nFor example we searched for event with id=2.")
    result = Event.where(id:2).joins(ticket_types: :tickets).sum("ticket_types.ticket_price")
    puts(result)
    puts("EOQ")
    puts("Query 6: The event that has been most attended by women.")
    result = Event.joins(ticket_types: {tickets: {order: :customer}}).where(customers: {:gender=> "f"}).map{|x| x.name}.max
    puts(result)
    puts("EOQ")
    puts("Query 7: The event that has been most attended by men ages 18 to 30.")
    result = Event.joins(ticket_types: {tickets: {order: :customer}}).where(customers: {:age =>18..30, :gender => "m"}).distinct.map {|x| x.name}.max
    puts(result)
    puts("EOQ")
  end
end
