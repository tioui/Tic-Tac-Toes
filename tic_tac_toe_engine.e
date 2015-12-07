note
	description: "A game engine to manage a Tic_Tac_Toe game"
	author: "Louis Marchand"
	date: "Sun, 06 Dec 2015 22:12:04 +0000"
	revision: "1.0"

class
	TIC_TAC_TOE_ENGINE

inherit
	GAME_LIBRARY_SHARED
		redefine
			default_create
		end

feature {NONE} -- Initializaton

	default_create
			-- Initialization of `Current'
		local
			l_window_builder:GAME_WINDOW_RENDERED_BUILDER
		do
			l_window_builder.is_resizable := True
			l_window_builder.must_renderer_support_texture_target := True
			window := l_window_builder.generate_window
			window.renderer.set_drawing_color (create {GAME_COLOR}.make_rgb (255, 255, 255))
			create images_factory.make (window.renderer, window.pixel_format)
			has_error := images_factory.has_error
			if not has_error then
				create grid.make(images_factory, 0, 0, images_factory.panel.width, images_factory.panel.height)
				window.renderer.set_logical_size (images_factory.panel.width, images_factory.panel.height)
			else
				create grid.make(images_factory, 0, 0, 1, 1)
			end

		end

feature -- Access

	run
			-- Execute the game
		require
			No_Error: not has_error
		do
			game_library.quit_signal_actions.extend (agent on_quit_signal)
			window.expose_actions.extend (agent on_redraw)
			window.mouse_button_released_actions.extend (agent on_mouse_released)
			on_redraw(game_library.time_since_create)
			is_o_turn := True
			game_library.launch
			game_library.clear_all_events
		end

	has_error:BOOLEAN
		-- An error occured at creation

feature {NONE} -- Implementation

	grid:GRID
			-- The Tic Tac Toe game grid

	window:GAME_WINDOW_RENDERED
			-- The game window

	images_factory: IMAGES_FACTORY
			-- Factory that generate the game images

	is_o_turn:BOOLEAN
			-- If set, the player presently playing is O. X if not

	on_redraw(a_timestamp:NATURAL_32)
			-- Redraw the scene
		do
			window.renderer.clear
			grid.draw(window.renderer)
			window.update
		end

	on_quit_signal(a_timestamp:NATURAL_32)
			-- When the user close the window
		do
			game_library.stop
		end

	on_mouse_released(a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_BUTTON_RELEASED_STATE; a_nb_clicks: NATURAL_8)
			-- When a player click on the window.
		do
			if a_mouse_state.is_left_button_released then
				grid.select_cell (is_o_turn, a_mouse_state.x, a_mouse_state.y)
				if grid.has_last_selected then
					is_o_turn := not is_o_turn
				end
				on_redraw(a_timestamp)
			end
		end

end
