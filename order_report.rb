# ./order_report.rb
require './order_interface.rb'

module OrderReportModule
  # Function for instance the order interface, get the data from the API
  # and then process the information to generate the response data
  # used for print the report, requesting the page number to the user on the prompt cli
  # (Params): []
  # (Returns): [response_data:Object]
  def self.process_data(testing_mode = false)
    if ARGV[0].nil?
      print "Enter the page number you would like to get / or leave blank to get default page: ".green
      page_number = STDIN.gets.chomp
    elsif testing_mode
      page_number = "1"
    else
      page_number = ARGV[0]
    end

    print "Would you like to use a mock? Leave blank for not [y/n]: ".green
    mock = STDIN.gets.chomp

    if mock == 'y' || mock == 'Y'
      data          = JSON.parse(File.read("./mock.json"))
      orders        = data['orders']
    elsif mock.empty? || mock != 'y' || mock != 'Y'
      connection    = OrderInterface.new("https://shopifake.returnly.repl.co", "orders.json", "page=#{page_number.scan(/\d/).join('').to_i}", page_number)
      data          = connection.get_data
      orders        = data[:res]['orders']
    end

    response      = {
      data: {
        orders_count: orders.count,
        most_popular: get_most_and_least_popular_product(orders),
        least_popular: get_most_and_least_popular_product(orders, false),
        median_order_value: get_median_order_value(orders),
        product_repurchased_interval: get_product_repurchased(orders),
        page_number: page_number
      }, status_code: 200
    }
  end

  # Function to show the report on CLI
  # (Params): [response_data:Object]
  # (Returns): [report:String]
  def self.print_report(response_data)
    puts  "\n\n############### Statistics report page Nº #{response_data[:data][:page_number].empty? ? 1 : response_data[:data][:page_number]} ############### \n\n".green +
          "Nº Orders: ".blue + "#{response_data[:data][:orders_count]} \n".yellow +
          "Most popular product: ".blue + "#{response_data[:data][:most_popular]} \n".yellow +
          "Least popular product: ".blue + "#{response_data[:data][:least_popular]} \n".yellow +
          "Median order value: ".blue + "$ #{response_data[:data][:median_order_value]} \n".yellow +
          "The product repurchased by the same customer in the shortest interval is: ".blue + "#{response_data[:data][:product_repurchased_interval]} \n\n".yellow +
          "####################################################\n\n".green
  end

  # Function to calculate the most and least popular product depends on
  # the most_popular argument grouping the orders lines
  # by purchases count and different customers
  # (Params): [orders:Array, is_popular:Boolean]
  # (Returns): [most_popular:String, least_popular:String]
  def self.get_most_and_least_popular_product(orders, is_popular = true)
    group_products_all_lines = orders.map { |order| order['order_lines'].map { |line| { customer_id: order['customer_id'], product_id: line['product_id'] } } }.flatten.group_by {|line| line[:product_id]}
    group_products_by_units = orders.map { |order, key| order['order_lines'] }.flatten.group_by {|line| line['product_id']}.map do |key, value|
      { id: key ,name: "product_id: #{key}", count_purchases: value.sum { |line| line['units'] }, customer_count: group_products_all_lines[key].map{|customer| customer[:customer_id]}.uniq.count }
    end
    
    if is_popular
      most_popular  = group_products_by_units.max_by { |product| [product[:count_purchases], product[:customer_count]] }
      "#{most_popular[:name]} with #{most_popular[:count_purchases]} purchases by #{most_popular[:customer_count] > 1 ? "#{most_popular[:customer_count]} different customers" : "#{most_popular[:customer_count]} customer"}"
    else
      least_popular = group_products_by_units.min_by { |product| [product[:count_purchases], product[:customer_count]] }
      "#{least_popular[:name]} with #{least_popular[:count_purchases]} purchases by #{least_popular[:customer_count] > 1 ? "#{least_popular[:customer_count]} different customers" : "#{least_popular[:customer_count]} customer"}"
    end
  end

  # Function to calculate the median order value multiplying the units with the price of each of them
  # iterating each customer order
  # (Params): [orders:Array]
  # (Returns): [median_order_value:String]
  def self.get_median_order_value(orders)
    (orders.sum { |order| order['order_lines'].sum { |line| line['unit_price'] * line['units'] } }.to_f / orders.count).to_f.round(2)
  end

  # Function to calculate if some customer purchase same product more than once 
  # and calculate the lowest interval of all those purchases
  # (Params): [orders:Array]
  # (Returns): [customer_repurchase_product_interval_info:String]
  def self.get_product_repurchased(orders)
    products_repurchased = Array.new
    group_products_by_customer = orders.group_by { |order| order['customer_id'] }
    group_products_by_customer_id = orders.map { |order| order['order_lines'].map { |line| { customer_id: order['customer_id'], product_id: line['product_id'], date: order['date'] } }  }.flatten.group_by { |purchase| purchase[:customer_id] }
    group_products_by_product_id = group_products_by_customer_id.each do |key, value|
      value.group_by { |purchase| purchase[:product_id] }.each { |product_id, purchases| purchases.count > 1 && products_repurchased << purchases }
    end
    group_products_by_combination_purchase_date = products_repurchased.map { |value| value.combination(2).to_a.filter { |pair_date| pair_date.filter { |arr| arr } } }
    dates = group_products_by_combination_purchase_date.map do |pair_date|
      pair_date.map do |date_array|
        { comparation: (DateTime.parse(date_array[0][:date]) - DateTime.parse(date_array[1][:date])).to_f.abs, date_arr: date_array }
      end
    end

    if dates.empty?
      "There were not repurchases from any customer of any product"
    else
      product_repurchased = Hash.new
      product_repurchased[:id] = dates.flatten.group_by { |date_arr| date_arr[:comparation] }.min[1][0][:date_arr][0][:product_id]
      product_repurchased[:interval] = dates.flatten.group_by { |date_arr| date_arr[:comparation] }.min[1][0][:date_arr].map { |purchase_date| purchase_date[:date] }
      product_repurchased[:customer] = dates.flatten.group_by { |date_arr| date_arr[:comparation] }.min[1][0][:date_arr][0][:customer_id]
      "customer_id: #{product_repurchased[:customer]}, product_id: #{product_repurchased[:id]} on the interval #{product_repurchased[:interval]}"
    end
  end

  # Function to show the order report with the processed data
  # using handling rescue in case some error
  # (Params): []
  # (Returns): [report:String]
  def self.data_report
    begin
      print_report(process_data())
    rescue StandardError => e
      OrderInterface.handle_error(e.message)
    end
  end
end