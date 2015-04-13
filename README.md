# esp8266-radiation
Monitoring the radiation level

It measures the radiation level of ionized particles by counting the particles detected with a Geiger-Muller tube.
The counting is made on three period of time: count-per-minute, count-per-5minutes and count-per-hour.

The values are sent to a Thingspeak channel (https://thingspeak.com/channels/9892).

By now, the count-per-hour is faulty and it is disabled.
