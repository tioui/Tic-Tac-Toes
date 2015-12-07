note
	description : "A Tic Tac Toe game"
	date        : "Mon, 07 Dec 2015 15:46:55 +0000"
	revision    : "1.0"

class
	APPLICATION

inherit
	GAME_LIBRARY_SHARED

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			l_engine:detachable TIC_TAC_TOE_ENGINE
		do
			game_library.enable_video
			create l_engine
			if not l_engine.has_error then
				l_engine.run
			else
				print("An error occured%N")
			end

			l_engine := Void
			game_library.clear_all_events
			game_library.quit_library
		end

end
