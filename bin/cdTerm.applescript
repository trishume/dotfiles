on run (arguments)
	tell application "iTerm"
		-- activate current terminal
		-- tell the current terminal
		--   set sess to current session
		--
		--   tell sess to write ""
		--   tell sess to write text "cd \"" & dir & "\""
		-- end tell
		set dir to (first item of arguments)
		-- set dir to "~/Box/Dev"
		repeat with myterm in terminals
			tell myterm
				set sess to (current session)
				tell sess
					set the_name to get name
					if the_name does not contain "Python" then
						tell sess
							-- write text ""
							write text ("cd " & dir)
						end tell
						exit repeat
					end if
				end tell
			end tell
		end repeat
	end tell
	--
	-- cdThing(sess, "troll")
end run

on cdThing(sess, directory)
	tell sess
		say (get name)
		write text ""
		write text ("cd \"" & dir & "\"")
	end tell
end cdThing



