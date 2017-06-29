
function getTime()
    if lastUpdate >= 900 then

        conn=net.createConnection(net.TCP, 0)

        conn:on("connection",function(conn, payload)
            conn:send("HEAD / HTTP/1.1\r\n"..
                      "Host: google.com\r\n"..
                      "Accept: */*\r\n"..
                      "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua;)"..
                      "\r\n\r\n")
               end)

        conn:on("receive", function(conn, payload)
        --print(payload)
            time = string.sub(payload,  string.find(payload,"Date: ")+23, string.find(payload,"Date: ")+31)
            hour = string.sub(time, 0, 2) + 20
    		if hour > 23 then hour = hour - 24 end
            minute = string.sub(time, 4,5) + 0
            second = string.sub(time, 7,9) + 0
			mins = 60 * hour + minute
            print("Time: "..hour.."-"..minute.."-"..second)
            conn:close()
            lastUpdate = 0
            end)
        conn:connect(80,'google.com')
    end--if
end--getTime
--------------------------------------------------------------------------------
function thingspeak(f)
    f = fix..f
    --print(f)
	conn = net.createConnection(net.TCP, 0)

	conn:on("receive", function(conn, payload)
		--print("PL: "..payload)
		conn:close()
	end)

	conn:on("connection",function(conn, payload)
		conn:send(f.." HTTP/1.1\r\n"..     
		"Host: api.thingspeak.com\r\n"..
		"Accept: */*\r\n"..
		"User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n"
		.."\r\n")
	end)

	conn:connect(80,'184.106.153.149') --api.thingspeak.com

end

function doit()
    if second == 0 then
        f5 = pulse      --cpm
        f6 = f6 + pulse --cph
        f7 = f7 + pulse --cpd
        pulse = 0
        cmd = 'field5='..f5
        if minute == 0 then --each hour
            cmd = 'field5='..f5..'&field6='..f6
            if hour == 0 then --each day
                cmd = 'field5='..f5..'&field6='..f6..'&field7='..f7
                f5 = 0
                f6 = 0
                f7 = 0
            end --if hour
            f5 = 0
            f6 = 0
        end --if minute
        cmd = cmd..'&field8='..mins
        thingspeak(cmd)
    end --if second
end --doit()


function incrementTime()
    second = second + 1
    lastUpdate = lastUpdate + 1
    if second == 60 then
        second = 0
        minute = minute + 1
        mins = 60 * hour + minute
        if mins == 1440 then mins = 0 end
    end
    if minute == 60 then
        minute = 0
        hour = hour + 1
    end
    if hour == 24 then
        hour = 0
    end
    --action()
    doit()
end

f5 = 0
f6 = 0
f7 = 0

getTime()
--print("now got time: "..hour.."-"..minute.."-"..second)

tmr.alarm(1, 1000, 1, function()
        incrementTime()
        --print(hour.."-"..minute.."-"..second..", "..lastUpdate.." > "..mins)
    end)--function()

tmr.alarm(0, 11900, 1, function()

    ip = wifi.sta.getip()
    if ip=="0.0.0.0" or ip==nil then
        print("connecting to AP...")
    else
        getTime()
    end -- if

end)-- function

--==============================================================================
