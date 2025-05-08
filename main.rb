require_relative 'delivery'

puts "Введите вес груза (кг):"
weight = gets.to_i

puts "Введите длину груза (см):"
length = gets.to_i

puts "Введите ширину груза (см):"
width = gets.to_i

puts "Введите высоту груза (см):"
height = gets.to_i

puts "Введите город отправления:"
from = gets.chomp

puts "Введите город назначения:"
to = gets.chomp

begin
  distance = fetch_distance(from, to)
  puts "Расстояние между #{from} и #{to}: #{distance} км"
rescue => e
  puts e.message
  exit
end

delivery = Delivery.new(weight, length, width, height, distance)
result = delivery.calculate_price

puts result