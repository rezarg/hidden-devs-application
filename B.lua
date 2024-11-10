local dss = game:GetService("DataStoreService")
local https = game:GetService("HttpService")
local p = game:GetService("Players")

local datastore = dss:GetDataStore("v1")

local default = {
	leaderstats = {
		money = 0;
		wins = 0;
	};
}

p.PlayerAdded:Connect(function(player: Player)
	for k, v in pairs(default) do
		local folder = player:FindFirstChild(k)
		if not folder then
			folder = Instance.new("Configuration")
			folder.Name = k
			folder.Parent = player
		end
		
		for data, value in pairs(v) do
			print(data, typeof(value))
			local new = nil
			
			if typeof(value) == "number" then
				new = Instance.new("NumberValue")
			end
			
			if typeof(value) == "string" then
				new = Instance.new("StringValue")
			end
			
			if typeof(value) == "table" then
				new = Instance.new("StringValue")
			end
			
			if not new then
				warn("Failed to load datatype:", typeof(value))
			end
			
			new.Name = data
			
			if typeof(value) == "table" then
				new.Value = https:JSONEncode(value)
			else
				new.Value = value
			end
			
			new.Parent = folder
		end
	end
	
	local loadeddata = nil
	local success, exception = pcall(function()
		loadeddata = datastore:GetAsync(player.UserId)
	end)
	
	if loadeddata == nil or not success then
		return
	end
	
	print("Loaded data:", loadeddata)
	
	for k, v in pairs(loadeddata) do
		local folder = player:FindFirstChild(k)
		
		if not folder then
			warn("Couldn't find Path:", k)
			continue
		end
		
		for data, value in pairs(v) do
			local find = folder:FindFirstChild(data)
			
			if not find then
				warn("Couldn't find DataObject:", folder, data)
				continue
			end
			
			if typeof(value) == "table" then
				find.Value = https:JSONEncode(value)
			else
				find.Value = value
			end
		end
	end
end)

p.PlayerRemoving:Connect(function(player: Player)
	local dataset = table.clone(default)
	
	for k, v in pairs(dataset) do
		local folder = player:FindFirstChild(k)
		
		if not folder then
			warn("Couldn't get Path:", k)
			continue
		end
		
		for data, value in pairs(v) do
			local find = folder:FindFirstChild(data)

			if not find then
				warn("Couldn't find DataObject:", folder, data)
				continue
			end

			if typeof(value) == "table" then
				dataset[k][data] = https:JSONDecode(find.Value)
			else
				dataset[k][data] = find.Value
			end
		end
		
		
	end
	
	print("Got data:", dataset)
	
	local success, exception = pcall(function()
		datastore:SetAsync(player.UserId, dataset)
	end)
	
	if not success then
		warn("Failed to save data: ", exception)
	end
end)
