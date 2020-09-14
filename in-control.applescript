use AppleScript version "2.4"
use scripting additions
use framework "Foundation"
use framework "AppKit"

property itemStatus : missing value

on run
	init() of me
end run

on init()
	set menuList to {"↕︎	Hide Ui", "⏏	Eject Disks", "ℹ	Show/Hide Files", "Switch Dark Mode","",  "Screenshot (Full Screen)", "Screenshot (Window)", "Screenshot (Selection)","", "Open Force Quit Window" ,"","⎋	Quit"}
	set itemStatus to current application's NSStatusBar's systemStatusBar()'s statusItemWithLength:(current application's NSVariableStatusItemLength)
	itemStatus's setTitle:"🚦"
	itemStatus's setHighlightMode:true
	itemStatus's setMenu:(createMenu(menuList) of me)
end init

on createMenu(menuList)
	set theMenu to current application's NSMenu's alloc()'s init()
	set aCount to 1
	repeat with i in menuList
		set j to contents of i
		if j is not equal to "" then
			set menuItem to (current application's NSMenuItem's alloc()'s initWithTitle:j action:"actionHandler:" keyEquivalent:"")
		else
			set menuItem to (current application's NSMenuItem's separatorItem())
		end if
		(menuItem's setTarget:me)
		(menuItem's setTag:aCount)
		(theMenu's addItem:menuItem)
		
		if j is not equal to "" then
			set aCount to aCount + 1
		end if
	end repeat
	return theMenu
end createMenu

on tBars()
	tell application "System Preferences"
		reveal pane "com.apple.preference.general"
	end tell
	delay 0.1
	tell application "System Events" to tell process "System Preferences"
		click checkbox "Automatically hide and show the menu bar" of window "General"
	end tell
	delay 0.1
	tell application "System Events"
		tell dock preferences to set autohide to not autohide
	end tell
	tell application "System Preferences"
		quit
	end tell
end tBars

on actionHandler:sender
	set menuTitle to title of sender as string
	
	if menuTitle is equal to "⎋	Quit" then
		current application's NSStatusBar's systemStatusBar()'s removeStatusItem:itemStatus
		if (name of current application) is not "Script Editor" then
			tell current application to quit
		end if
		
	else if menuTitle is equal to "↕︎	Hide UI" then
		tBars()
		delay 1
		
	else if menuTitle is equal to "⏏	Eject Disks" then
		set collection_1 to {}
		set diskList to {"All Disks"}
		set mountedDiskName to "Bootcamp"
		set diskIsMounted to false
		
		tell application "Finder"
			try
				set diskList to diskList & (name of every disk whose ejectable is true)
			on error
				
			end try
		end tell
		
		if (count of diskList) is greater than 1 then
			tell application "Finder"
				eject every disk
			end tell
		end if
		
		tell application "System Events" to set diskNames to name of every disk
		if mountedDiskName is in diskNames then
			set diskIsMounted to true
		end if
		
		if diskIsMounted then
			do shell script "diskutil unmount /dev/disk0s4"
		end if
		
		
	else if menuTitle is equal to "ℹ	Show/Hide Files" then
		set visibility to (do shell script "defaults read com.apple.finder AppleShowAllFiles")
		if visibility is "1" then
			do shell script "defaults write com.apple.finder AppleShowAllFiles 0"
			set resetFinder to display dialog "Restarting Finder in 3 seconds" buttons {"Cancel"} default button "Cancel" with icon stop giving up after 3
			tell application "Finder" to quit
			delay 1
			tell application "Finder" to activate
		else if visibility is "0" then
			do shell script "defaults write com.apple.finder AppleShowAllFiles 1"
			set resetFinder to display dialog "Restarting Finder in 3 seconds" buttons {"Cancel"} default button "Cancel" with icon stop giving up after 3
			tell application "Finder" to quit
			delay 1
			tell application "Finder" to activate
		end if
		
	else if menuTitle is equal to "Switch Dark Mode" then
		tell application "System Events"
			tell appearance preferences
				set dark mode to not dark mode
			end tell
		end tell
		delay 1
		
	else if menuTitle is equal to "Screenshot (Full Screen)" then
        try
            do shell script ("screencapture -P")
        end try
		delay 1
	
	else if menuTitle is equal to "Screenshot (Window)" then
        try
            do shell script ("screencapture -P -w")
        end try
		delay 1

	else if menuTitle is equal to "Screenshot (Selection)" then
        try
            do shell script ("screencapture -P -i")
        end try
		delay 1

	else if menuTitle is equal to "Open Force Quit Window" then
		tell application "System Events" to key code 53 using {command down, option down}

	end if
end actionHandler:
