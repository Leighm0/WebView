---------------
-- Globals
---------------
do
	EC = {}
	OPC = {}
	PRESETS = {
		["None"] = {
			url = "",
			icon = "default"
		},
		["Google"] = {
			url = "https://www.google.com",
			icon = "google"
		},
		["Google Calendar"] = {
			url = "https://www.google.com/calendar",
			icon = "calendar"
		},
		["Google News"] = {
			url = "https://news.google.com",
			icon = "news"
		},
		["Weather.com"] = {
			url = "https://weather.com",
			icon = "weather"
		}
	}
end

----------------------------------------------------------------------------------------------
--Function Name : setPresetIcon
--Parameters    : strPreset(string)
--Description   : Function called to set the Icon for the UI button based on Preset Selection.
----------------------------------------------------------------------------------------------
function setPresetIcon(strPreset)
	if (strPreset ~= "None") then
		local strIcon = PRESETS[strPreset]["icon"]
		C4:SendToProxy(5001, "ICON_CHANGED", {icon = strIcon})
	else
		local strIcon = PRESETS[strPreset]["icon"]
		C4:SendToProxy(5001, "ICON_CHANGED", {icon = strIcon})
	end
end

---------------------------------------------------------------------------------------------
--Function Name : setPresetURL
--Parameters    : strPreset(string)
--Description   : Function called to set the URL for the UI button based on Preset Selection.
---------------------------------------------------------------------------------------------
function setPresetURL(strPreset)
	if (strPreset ~= "None") then
		local newUrl = PRESETS[strPreset]["url"]
		C4:SendToProxy(5001, "URL_CHANGED", {url = newUrl})
		C4:UpdateProperty("URL", newUrl)
	else
		local newUrl = PRESETS[strPreset]["url"]
		C4:SendToProxy(5001, "URL_CHANGED", {url = newUrl})
		C4:UpdateProperty("URL", newUrl)
	end
end

-------------------------------------------------------------------------------------------
--Function Name : setPresetURL
--Parameters    : strPreset(string)
--Description   : Function called to set the Name for the Driver based on Preset Selection.
-------------------------------------------------------------------------------------------
function setPresetName(strPreset)
	if (strPreset ~= "None") then
		local newName = strPreset
		local proxyId = C4:GetProxyDevices()
		C4:RenameDevice(proxyId, newName)
	else
		local proxyId = C4:GetProxyDevices()
		C4:RenameDevice(proxyId, C4:GetDriverConfigInfo("name"))
	end
end

-----------------------------------------------------------------------------------------------------
--Function Name : ExecuteCommand
--Parameters    : strCommand(string), tParams(table)
--Description   : Function called by Director when a command is received for this DriverWorks driver.
-----------------------------------------------------------------------------------------------------
function ExecuteCommand(strCommand, tParams)
	tParams = tParams or {}
	Dbg("ExecuteCommand: " .. strCommand .. " (" ..  formatParams(tParams) .. ")")
	if (strCommand == 'LUA_ACTION') then
		if (tParams.ACTION) then
			strCommand = tParams.ACTION
			tParams.ACTION = nil
		end
	end
	local strCommand = string.upper(strCommand)
	strCommand = string.gsub(strCommand, "%s+", "_")
	local success, ret
	if (EC and EC[strCommand] and type(EC[strCommand]) == "function") then
		success, ret = pcall(EC[strCommand], tParams)
	end
	if (success == true) then
		return (ret)
	elseif (success == false) then
		print ("ExecuteCommand Lua error: ", strCommand, ret)
	end
end

----------------------------------------------------------------------------
--Function Name : EC.SET_URL
--Parameters    : tParams(table)
--Description   : Function called when "Set URL" ExecuteCommand is received.
----------------------------------------------------------------------------
function EC.SET_URL(tParams)
	Dbg("[EC] Set URL (" .. formatParams(tParams) .. ")")
	if (tParams.URL ~= nil) then
		C4:SendToProxy(5001, "URL_CHANGED", {url = tParams.URL})
		C4:UpdateProperty("URL", tParams.URL)
	end
end

-------------------------------------------------------------------------------
--Function Name : EC.SET_PRESET
--Parameters    : tParams(table)
--Description   : Function called when "Set Preset" ExecuteCommand is received.
-------------------------------------------------------------------------------
function EC.SET_PRESET(tParams)
	Dbg("[EC] Set PRESET (" .. formatParams(tParams) .. ")")
	if (tParams.PRESET ~= nil) then
		local strPreset = tParams.PRESET
		setPresetIcon(Properties[strPreset])
		setPresetURL(Properties[strPreset])
		setPresetName(Properties[strPreset])
	end
end
 
----------------------------------------------------------------------------
--Function Name : OnPropertyChanged(strProperty)
--Parameters    : strProperty(string)
--Description   : Function called by Director when a property changes value.
----------------------------------------------------------------------------
function OnPropertyChanged (strProperty)
	Dbg("OnPropertyChanged: " .. strProperty .. " (" .. Properties[strProperty] .. ")")
	local propertyValue = Properties[strProperty]
	if (propertyValue == nil) then propertyValue = '' end
	local strProperty = string.upper(strProperty)
	strProperty = string.gsub(strProperty, "%s+", "_")
	local success, ret
	if (OPC and OPC[strProperty] and type(OPC[strProperty]) == "function") then
		success, ret = pcall(OPC[strProperty], propertyValue)
	end
	if (success == true) then
		return (ret)
	elseif (success == false) then
		print ("OnPropertyChanged Lua error: ", strProperty, ret)
	end
end

-------------------------------------------------------------------------
--Function Name : OPC.DEBUG_MODE(strProperty)
--Parameters    : strProperty(string)
--Description   : Function called when Debug Mode property changes value.
-------------------------------------------------------------------------
function OPC.DEBUG_MODE(strProperty)
	gDbgPrint = C4:KillTimer(gDbgPrint or 0)
	if (strProperty == "Off") then return end
	gDbgPrint = C4:AddTimer(8, "HOURS")
	print ("Enabled Debug Timer for 8 hours")
end

------------------------------------------------------------------
--Function Name : OPC.URL(strProperty)
--Parameters    : strProperty(string)
--Description   : Function called when URL property changes value.
------------------------------------------------------------------
function OPC.URL(strProperty)
	C4:SendToProxy(5001, "URL_CHANGED", {url = strProperty})
end

----------------------------------------------------------------------
--Function Name : OPC.PRESETS(strProperty)
--Parameters    : strProperty(string)
--Description   : Function called when Presets property changes value.
----------------------------------------------------------------------
function OPC.PRESETS(strProperty)
	setPresetIcon(strProperty)
	setPresetURL(strProperty)
	setPresetName(strProperty)
end

---------------------------------------------------------------------------------------------
--Function Name : Dbg
--Parameters    : strDebugText(string)
--Description   : Function called when debug information is to be printed/logged (if enabled)
---------------------------------------------------------------------------------------------
function Dbg(strDebugText)
	if (gDbgPrint) then print(strDebugText)	end
end

---------------------------------------------------------
--Function Name : formatParams
--Parameters    : tParams(table)
--Description   : Function called to format table params.
---------------------------------------------------------
function formatParams(tParams)
	tParams = tParams or {}
	local out = {}
	for k,v in pairs(tParams) do
		if (type(v) == "string") then
			table.insert(out, k .. " = \"" .. v .. "\"")
		else
			table.insert(out, k .. " = " .. tostring(v))
		end
	end
	return "{" .. table.concat(out, ", ") .. "}"
end

-----------------------------------------------------------------------------------------------------------------------------
--Function Name : OnDriverDestroyed
--Description   : Function called when a driver is deleted from a project, updated within a project or Director is shut down.
-----------------------------------------------------------------------------------------------------------------------------
function OnDriverDestroyed()
	gDbgPrint = C4:KillTimer(gDbgPrint or 0)
end

----------------------------------------------------------------------------
--Function Name : OnDriverInit
--Description   : Function invoked when a driver is loaded or being updated.
----------------------------------------------------------------------------
function OnDriverInit()
	C4:AllowExecute(true)
end

------------------------------------------------------------------------------------------------
--Function Name : OnDriverLateInit
--Description   : Function that serves as a callback into a project after the project is loaded.
------------------------------------------------------------------------------------------------
function OnDriverLateInit()
	DRIVER_NAME = C4:GetDriverConfigInfo("name")
	DRIVER_VERSION = C4:GetDriverConfigInfo("version")
	C4:UpdateProperty("Driver Name", DRIVER_NAME)
	C4:UpdateProperty("Driver Version", DRIVER_VERSION)
	C4:SetTimer(3000, function(timer) 
		C4:SendToProxy(5001, "URL_CHANGED", {url = Properties["URL"]})
		setPresetIcon(Properties["Presets"])
		setPresetName(Properties["Presets"])
	end)
end

print("Driver Loaded..." .. os.date())
