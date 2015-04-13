
gpio0 = 3
gpio2 = 4

pulse_count = 0
cpm = 0   --count-per-minute
cp5m = 0  --count-per-5minutes
cph = 0   --count-per-hour

fix = "GET /update?key=XXXXXXXXXXXXXXXX&" --put here your api key from Thingspeak

gpio.mode(gpio0,gpio.INT,gpio.PULLUP)
gpio.mode(gpio2,gpio.OUTPUT)
print("init done")
-- at interrupt request:
gpio.trig(gpio0,"down", function()
		pulse_count = pulse_count + 1
		end)

function thingspeak(field,value)
--field5 is cpm
--field6 is cp5m
--field7 is cph
print("field: "..field)
    if field == 5 then
        cmd = fix.."field5="..value
    end
    if field == 6 then
        cmd = fix.."field6="..value
    end
    if field == 7 then
        cmd = fix.."field7="..value
    end
--print("cmd: "..cmd) --for test purposes
	conn=net.createConnection(net.TCP, 0)

	conn:on("receive", function(conn, payload)
		print("PL: "..payload)  --for test purposes
		conn:close()
	end)

	conn:on("connection",function(conn, payload)
		conn:send(cmd.."HTTP/1.1\r\n"..
		"Host: api.thingspeak.com\r\n"..
		"Accept: */*\r\n"..
		"User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n"..
		"\r\n")
	end)

	conn:connect(80,'184.106.153.149') --api.thingspeak.com 184.106.153.149
end-- function thingspeak()

function one_minute()
-- read the counter each 60 sec and reset the pulse_count
	cpm = pulse_count 
	cp5m = cp5m + cpm
    print("cpm: "..cpm)--for test purposes
    --send count per minute cpm to TS
    thingspeak(5,cpm)
	pulse_count = 0
end

function five_minute()
    cph = cph + cp5m
    print("last 5 minutes: "..count_5m)--for test purposes
    --send count_5m to TS
    thingspeak(6,cp5m)
    count_5m = 0
end

function one_hour()
    --send cph to TS
    print("last hour: "..cph)--for test purposes
    thingspeak(7,cph)
    cph = 0
end

tmr.alarm(0,60000,1, function()
	one_minute()
	end)
--print("tmr 0")--for test purposes
tmr.alarm(1,3600000,1, function()
    one_hour()
    --print("1h: Data sent to thingspeak")
    end)
--print("tmr 1")--for test purposes
tmr.alarm(2,300000,1, function() --each 300 seconds
    five_minute()
    --print("5m: Data sent to thingspeak")
    end)
--print("tmr 2")--for test purposes

-------------------------------------------------------------------------------
