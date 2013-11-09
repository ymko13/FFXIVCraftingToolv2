--Needs to be passed a table structured: { repair = false, condition = 0, lastticks = 0, ticks = 0 }. The table should be a global variable in your module.
-- adds repairsTotal which returns total repairs made
--Those will be stored in that table afterwards
function RepairMe( lt, updateinterval, dbg )
	if(lt.ticks - lt.lastticks >= updateinterval) then	
		if(lt.repair) then
			local inventory = Inventory("type=1000")
			if(inventory) then
				for i, item in pairs(inventory) do
					if(item) then
						if(item.condition <= lt.condition) then
							if(dbg) then d("<<PRE>>"..item.name .. " " .. item.condition) end
							item:Repair()
							if(dbg) then d("<<POST>>"..item.name .. " " .. item.condition) end
							lt["repairsTotal"] = (lt["repairsTotal"] or 0) + 1
						end
					end
				end
			end
			lt.lastticks = lt.ticks
		end
	end
end