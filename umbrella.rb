require "http"
require "json"
require "dotenv/load"

pirate_key = ENV.fetch("PIRATE_WEATHER_KEY")
google_key = ENV.fetch("GMAPS_KEY")

# ask user for location
puts "What city and state are you located in? (City, ST)"

# get and store users location
user_location = gets.chomp
# puts "Checking weather at #{user_location}"

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
summary =  parsed_pweather['currently']['summary']
puts "In #{user_location} it is currently #{current_temp} and #{summary}"
