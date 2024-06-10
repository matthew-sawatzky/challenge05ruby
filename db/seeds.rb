# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'faker'
require 'csv'

# Clear out the products and categories tables
Product.destroy_all
Category.destroy_all

# Read data from the CSV file
csv_file = Rails.root.join('db/products.csv')
csv_data = File.read(csv_file)
products_csv = CSV.parse(csv_data, headers: true)

# Loop through each row in the CSV file
products_csv.each do |row|
  # Find or create the associated category
  category_name = row['category']
  category = Category.find_or_create_by(name: category_name)

  # Create the product associated with the category, using data from the CSV
  category.products.create(
    title: row['name'],
    price: row['price'],
    stock_quantity: row['stock quantity']
  )
end

# Create additional random products
additional_products_count = 676 - products_csv.count
additional_products_count.times do
  category_name = Faker::Commerce.department(max: 1, fixed_amount: true)
  category = Category.find_or_create_by(name: category_name)

  category.products.create(
    title: Faker::Commerce.product_name,
    price: Faker::Commerce.price(range: 0..100.0),
    stock_quantity: Faker::Number.between(from: 1, to: 100)
  )
end

puts "Seeded products and categories."
