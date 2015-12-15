note
	description: "A {GAME_ENGINE} to manage an Ultimate Tic Tac Toe game."
	author: "Louis Marchand"
	date: "Tue, 15 Dec 2015 01:16:44 +0000"
	revision: "1.0"

class
	ULTIMATE_ENGINE

inherit
	GAME_ENGINE

create
	make,
	make_with_ai


feature {NONE} -- Initializaton

	make_with_ai(a_window:GAME_WINDOW_RENDERED; a_ressources_factory:RESSOURCES_FACTORY)
			-- Initialization of `Current' using `a_window' as `window' and `a_ressources_factory'
			-- as `ressources_factory'. The player is against an `ai'
		do
			make(a_window, a_ressources_factory)
			create ai.make (False)
		end
feature {NONE} -- Implementation

	grid:ULTIMATE_GRID
			-- <Precursor>

	on_mouse_released(a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_BUTTON_RELEASED_STATE; a_nb_clicks: NATURAL_8)
			-- <Precursor>
		do
			if a_mouse_state.is_left_button_released then
				if grid.has_o_won or grid.has_x_won or grid.is_draw then
					reset
					if attached ai as la_ai and then is_o_turn = la_ai.is_o then
						on_redraw(a_timestamp)
						la_ai.play(grid)
						end_turn
					end
				else
					grid.select_cell_at (is_o_turn, a_mouse_state.x, a_mouse_state.y)
					if attached grid.last_selected_cell then
						end_turn
						if not grid.is_draw and not grid.has_o_won and not grid.has_x_won then
							if attached ai as la_ai and then is_o_turn = la_ai.is_o then
								on_redraw(a_timestamp)
								la_ai.play(grid)
								end_turn
							end
						end
					end
				end
				on_redraw(a_timestamp)
			end
		end

	end_turn
			-- <Precursor>
		do
			if grid.is_draw then
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

	reset
			-- <Precursor>
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

	ai:detachable ULTIMATE_AI
			-- <Precursor>

end
