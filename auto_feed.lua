--Needs to be passed a table structured: { eat = false, itemid = 0, lastticks = 0, ticks = 0 }. The table should be a global variable in your module.
--Adds Variables to the table you pass in:
--count -> Item Count (number)
--bresult -> If Buff is found (boolean)
--btime -> Buff time left if found, if not returns 0 (number)
--Those will be stored in that table afterwards
function FeedMe( lt, updateinterval, dbg )
	if(lt.ticks - lt.lastticks >= updateinterval) then	
		local buff = MyPlayerHasBuff(48)
		
		lt["bresult"] = buff.result
		lt["btime"] = buff.time
		
		lt.eat = lt.eat and not buff.result
		if(dbg) then d("Should I eat? " .. tostring(lt.eat)) end	
		local item = Inventory:Get(lt.itemid)
		if(item and item.count >= 1) then
			if(item.isready and lt.eat) then
				item:Use()
				if(dbg) then d("Item Used: "..item.name) end
			end
			if(dbg) then d("Item Found: "..item.name) end
			lt["count"] = item.count
		else
			if(dbg) then d("Item Not Found, or the amount of items is less than 1") end	
			lt["count"] = 0
		end
		lt.lastticks = lt.ticks
	end
end

function MyPlayerHasBuff(id) -- Returns a result and a time of the buff if result is true
	local br = false
	local bt = 0
	if (Player) then
		local pbuffs = Player.buffs
		if (pbuffs) then
			for i,buff in pairs(pbuffs) do
				if (buff) then
					if (buff.id == id) then
						br = true
						bt = buff.duration
						break
					end
				end
			end
		end
	end
	local t = {}
	t["result"] = br
	t["time"] = bt
	return t
end

--Send in the number of time(s), get back the string "0H 0M 0S"
function TimeToString( timeval )
	local hr = tostring(math.floor(timeval / 3600 % 24)).."H "
	local mn = tostring(math.floor(timeval / 60 % 60)).."M "
	local sec = tostring(math.floor(timeval % 60)).."S"
	return hr..mn..sec
end