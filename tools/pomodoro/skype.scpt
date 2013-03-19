-- This is used for triggering Skype status when someone pomodoro starts/ends
-- Set to Do Not Disturb status (pomodoro start)
tell application "Skype"
    send command "SET USERSTATUS DND" script name "pomodoro"
end tell

-- Set to online status (pomodoro end)
tell application "Skype"
  send command "SET USERSTATUS ONLINE" script name "pomodoro"
end tell