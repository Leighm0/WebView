-------------
-- Globals --
-------------
do
	EC = {}
	OPC = {}
	PRESETS = {
		["None"] = {
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
	g_debugMode = 0
	g_DbgPrint = nil
	g_AutoRename = false
	g_lastName = "WebView"
end

----------------------------------------------------------------------------
--Function Name : OnDriverInit
--Description   : Function invoked when a driver is loaded or being updated.
----------------------------------------------------------------------------
function OnDriverInit()
	C4:UpdateProperty("Driver Name", C4:GetDriverConfigInfo("name"))
	C4:UpdateProperty("Driver Version", C4:GetDriverConfigInfo("version"))
	C4:AllowExecute(true)
end

------------------------------------------------------------------------------------------------
--Function Name : OnDriverLateInit
--Description   : Function that serves as a callback into a project after the project is loaded.
------------------------------------------------------------------------------------------------
function OnDriverLateInit()
	for k,v in pairs(Properties) do OnPropertyChanged(k) end
	PersistData = PersistData or {}
	if (PersistData.URL ~= nil) then C4:UpdateProperty("URL", PersistData.URL) end
	C4:SetTimer(3000, function(timer) 
		C4:SendToProxy(5001, "URL_CHANGED", {url = Properties["URL"]})
		setPresetIcon(Properties["Presets"])
		if (g_AutoRename) then setPresetName(Properties["Presets"]) end
	end)
end

-----------------------------------------------------------------------------------------------------------------------------
--Function Name : OnDriverDestroyed
--Description   : Function called when a driver is deleted from a project, updated within a project or Director is shut down.
-----------------------------------------------------------------------------------------------------------------------------
function OnDriverDestroyed()
	if (g_DbgPrint ~= nil) then g_DbgPrint:Cancel() end
end

----------------------------------------------------------------------------
--Function Name : OnPropertyChanged
--Parameters    : strProperty(str)
--Description   : Function called by Director when a property changes value.
----------------------------------------------------------------------------
function OnPropertyChanged(strProperty)
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
--Function Name : OPC.DEBUG_MODE
--Parameters    : strProperty(str)
--Description   : Function called when Debug Mode property changes value.
-------------------------------------------------------------------------
function OPC.DEBUG_MODE(strProperty)
	if (strProperty == "Off") then
		if (g_DbgPrint ~= nil) then g_DbgPrint:Cancel() end
		g_debugMode = 0
		print ("Debug Mode: Off")
	else
		g_debugMode = 1
		print ("Debug Mode: On for 8 hours")
		g_DbgPrint = C4:SetTimer(28800000, function(timer)
			C4:UpdateProperty("Debug Mode", "Off")
			timer:Cancel()
		end, false)
	end
end

------------------------------------------------------------------
--Function Name : OPC.URL
--Parameters    : strProperty(str)
--Description   : Function called when URL property changes value.
------------------------------------------------------------------
function OPC.URL(strProperty)
	C4:SendToProxy(5001, "URL_CHANGED", {url = strProperty})
	PersistData.URL = strProperty
end

----------------------------------------------------------------------
--Function Name : OPC.PRESETS
--Parameters    : strProperty(str)
--Description   : Function called when Presets property changes value.
----------------------------------------------------------------------
function OPC.PRESETS(strProperty)
	setPresetIcon(strProperty)
	setPresetURL(strProperty)
	if (g_AutoRename) then setPresetName(Properties["Presets"]) end
end

---------------------------------------------------------------------------------
--Function Name : OPC.AUTO_RENAME_DRIVER
--Parameters    : strProperty(str)
--Description   : Function called when Auto Rename Driver property changes value.
---------------------------------------------------------------------------------
function OPC.AUTO_RENAME_DRIVER(strProperty)
	if (strProperty == "On") then
		g_AutoRename = true
		setPresetName(Properties["Presets"])
	else
		g_AutoRename = false
	end
end

-----------------------------------------------------------------------------------------------------
--Function Name : ExecuteCommand
--Parameters    : strCommand(str), tParams(table)
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
		if (g_AutoRename) then setPresetName(Properties["Presets"]) end
	end
end

----------------------------------------------------------------------------------------------
--Function Name : setPresetIcon
--Parameters    : strPreset(str)
--Description   : Function called to set the Icon for the UI button based on Preset Selection.
----------------------------------------------------------------------------------------------
function setPresetIcon(strPreset)
	if (strPreset ~= nil) then
		local strIcon = PRESETS[strPreset]["icon"]
		C4:SendToProxy(5001, "ICON_CHANGED", {icon = strIcon})
	end
end

---------------------------------------------------------------------------------------------
--Function Name : setPresetURL
--Parameters    : strPreset(str)
--Description   : Function called to set the URL for the UI button based on Preset Selection.
---------------------------------------------------------------------------------------------
function setPresetURL(strPreset)
	if (strPreset ~= "None") then
		local newUrl = PRESETS[strPreset]["url"]
		C4:SendToProxy(5001, "URL_CHANGED", {url = newUrl})
		C4:UpdateProperty("URL", newUrl)
	end
end

-------------------------------------------------------------------------------------------
--Function Name : setPresetURL
--Parameters    : strPreset(str)
--Description   : Function called to set the Name for the Driver based on Preset Selection.
-------------------------------------------------------------------------------------------
function setPresetName(strPreset)
	if (g_AutoRename == false) then return end
	local lastName = g_lastName or "WebView"
	local newName = strPreset
	local proxyId = C4:GetProxyDevices()
	if (strPreset ~= "None") then
		if (newName ~= lastName) then
			Dbg("Current Driver Name: " .. lastName .. " | Renaming to: " ..newName)
			C4:RenameDevice(proxyId, newName)
			g_lastName = newName
		else
			Dbg("Not renaming device, already same name: "  .. newName)
		end
	else
		if (newName ~= lastName) then
			Dbg("Current Driver Name: " .. lastName .. " | Renaming to: WebView")
			C4:RenameDevice(proxyId,  "WebView")
			g_lastName = "WebView"
		else
			Dbg("Not renaming device, already same name: WebView")
		end
	end
end

---------------------------------------------------------------------------------------------
--Function Name : Dbg
--Parameters    : strDebugText(str)
--Description   : Function called when debug information is to be printed/logged (if enabled)
---------------------------------------------------------------------------------------------
function Dbg(strDebugText)
    if (g_debugMode == 1) then print(strDebugText) end
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
