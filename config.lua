--wifi config
ssid = "yourSSID"
pswd = "yourPASSWORD"

gpio0 = 3
gpio2 = 4
lastUpdate = 901
pulse = 0

-- the fields 5..7 for passing the data to Thingspeak, 8 is for 'mins'
f5 = 0  --cpm - counts per minute
f6 = 0  --cph - counts per hour
f7 = 0  --cpd - counts per day
f8 = 0  --mins - the count of minutes in the day from midnight [0] to next midnight [1440]

--other config
fix             = "GET /update?key=XXXXXXXXXXXXXXXX&"   --The long XX..X is the API write key of your thingspeak channel

thingspeak_IP   = "184.106.153.149" --api.thingspeak.com 
 
file_to_exec    = "googletime.lua"


gpio.mode(gpio0,gpio.INT,gpio.PULLUP)
gpio.mode(gpio2,gpio.OUTPUT)

gpio.trig(gpio0,"down", function()
    	pulse = pulse + 1
		end)

print("config done")
