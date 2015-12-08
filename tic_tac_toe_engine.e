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
			is_o_first_next := True
			l_window_builder.is_resizable := True
			l_window_builder.must_renderer_support_texture_target := True
			window := l_window_builder.generate_window
			window.renderer.set_drawing_color (create {GAME_COLOR}.make_rgb (255, 255, 255))
			create ressources_factory.make (window.renderer, window.pixel_format)
			has_error := ressources_factory.has_error
			if not has_error then
				reset
				window.renderer.set_logical_size (
									ressources_factory.grid_image.width,
									ressources_factory.grid_image.height + (ressources_factory.grid_image.height // 5)
								)
			else
				create grid.make(ressources_factory, 0, 0, 1, 1)
				create informations_panel.make (ressources_factory, 0, 0, 1, 1)
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
			game_library.launch
			game_library.clear_all_events
		end

	has_error:BOOLEAN
		-- An error occured at creation

feature {NONE} -- Implementation

	grid:GRID
			-- The Tic Tac Toe game grid

	informations_panel:INFORMATIONS_PANEL
			-- {PANEL} used for drawing informations about the game.

	window:GAME_WINDOW_RENDERED
			-- The game window

	ressources_factory: RESSOURCES_FACTORY
			-- Factory that generate the game images

	is_o_turn:BOOLEAN
			-- If set, the player presently playing is O. X if not

	on_redraw(a_timestamp:NATURAL_32)
			-- Redraw the scene
		do
			window.renderer.clear
			grid.draw(window.renderer)
			informations_panel.draw (window.renderer)
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
				if grid.has_o_won or grid.has_x_won or grid.is_full then
					reset
				else
					grid.select_cell (is_o_turn, a_mouse_state.x, a_mouse_state.y)
					if attached grid.last_selected_cell then
						if grid.is_full then
							informations_panel.set_draw
						elseif grid.has_o_won then
							informations_panel.set_winner (True)
						elseif grid.has_x_won then
							informations_panel.set_winner (False)
						else
							is_o_turn := not is_o_turn
							informations_panel.set_player_turn(is_o_turn)
						end
					end
				end
				on_redraw(a_timestamp)
			end
		end

	reset
			-- Restart the game by inversing the first player to mark.
		do
			create grid.make (ressources_factory, 0, 0, ressources_factory.grid_image.width, ressources_factory.grid_image.height)
			create informations_panel.make (
								ressources_factory, 0,
								ressources_factory.grid_image.height + 1,
								ressources_factory.grid_image.width,
								(ressources_factory.grid_image.height // 5)
							)
			is_o_turn := is_o_first_next
			informations_panel.set_player_turn(is_o_turn)
			is_o_first_next := not is_o_first_next
		end

	is_o_first_next:BOOLEAN
			-- If True, O will start the next game; X if False.

end
