
wifi.setmode(wifi.STATION)
print('set mode=STATION (mode='..wifi.getmode()..')')

wifi.sta.config("yourSSID","yourPASSWORD")

tmr.alarm(0, 5000, 1, function()
   ip = wifi.sta.getip()
   if ip=="0.0.0.0" or ip==nil then
      print("connecting to AP...")
   else
      tmr.stop(0)
      print("IP = "..wifi.sta.getip())
      dofile("counter.lua")
   end
end)
