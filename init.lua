
wifi.setmode(wifi.STATION)
print('set mode=STATION (mode='..wifi.getmode()..')')

dofile("config.lua")
wifi.sta.config(ssid,pswd)

tmr.alarm(0, 5000, 1, function()
   ip = wifi.sta.getip()
   if ip=="0.0.0.0" or ip==nil then
      print("connecting to AP...")
   else
      tmr.stop(0)
      print("IP = "..wifi.sta.getip())
      print("File to exec: "..file_to_exec)
      dofile(file_to_exec)
   end   --if
end)  --function
