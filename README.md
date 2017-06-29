# esp8266-radiation
Monitoring the radiation level with an IoT device.

The "thing" is based on nodeMCU platform for ESP8266 wifi module.
If you are here on purpose you know what's about.
If you are here by hazard, and still curious, you can pay a visit here http://www.esp8266.com/ 
or here https://github.com/search?utf8=%E2%9C%93&q=esp8266 or google about it.

It measures the radiation level of ionized particles by counting the particles detected with a Geiger-Muller tube. There is a picture of the device on the Thingspeak channel page, see below.

The counting is made on three period of time: count-per-minute, count-per-hour and count-per-day.

The values are sent to a Thingspeak channel (https://thingspeak.com/channels/9892).
