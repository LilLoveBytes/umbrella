require "http"
require "json"
require "dotenv/load"

pirate_key = ENV.fetch("PIRATE_WEATHER_KEY")
google_key = ENV.fetch("GMAPS_KEY")

# ask user for location
puts "What city and state are you located in? (City, ST)"

# get and store users location
user_location = gets.chomp


# get users lat and lon from google maps api
gmap_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + "#{user_location}" + "&key=#{google_key}"

gmap_response = HTTP.get(gmap_url)
parsed_gmap = JSON.parse(gmap_response)
lat = parsed_gmap['results'][0]['geometry']['location']['lat']
lon = parsed_gmap['results'][0]['geometry']['location']['lng']

# get weather at lat and lon from weather api
pweather_url = "https://api.pirateweather.net/forecast/" + "#{pirate_key}" + "/#{lat}, #{lon}"
pweather_response = HTTP.get(pweather_url)
parsed_pweather = JSON.parse(pweather_response)

# display the current temp and weather summary for the next hour
current_temp = parsed_pweather['currently']['temperature']
summary =  parsed_pweather['currently']['summary'].downcase
puts summary

if summary == 'clear' || summary == 'cloudy'
   puts "You can expect #{summary} skies and #{current_temp.to_i} degree weather in #{user_location} today"
elsif summary == 'rain'
   puts "You can expect some #{summary} and #{current_temp.to_i} degree weather in #{user_location} today"
else 
   puts "You can expect #{summary} conditions and #{current_temp.to_i} degree weather in #{user_location} today"
end

# for each of the next 12 hours, if precipitation is greater than 10%, else
hourly = parsed_pweather['hourly']['data']

umbrella = false

12.times do |i|
   probability = hourly[i+1]['precipProbability']*100
   if probability > 3
      puts "#{i+1} hour(s) from now, there is a #{probability.to_i} percent chance of precipitaion."
      umbrella = true
   end
end

# if chance of rain > 10% in next 12 hours, else
if umbrella == true
   puts "You might want to carry an umbrella."
else 
   puts "You probably wont need an umbrella today"
end
