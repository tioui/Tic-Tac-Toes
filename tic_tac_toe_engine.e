note
	description: "A game engine to manage a Tic_Tac_Toe game"
	author: "Louis Marchand"
	date: "Sun, 06 Dec 2015 22:12:04 +0000"
	revision: "1.0"

class
	TIC_TAC_TOE_ENGINE

inherit
	GAME_ENGINE

create
	make,
	make_with_ai

feature {NONE} -- Implementation

	grid:TIC_TAC_TOE_GRID
			-- <Precursor>

	on_mouse_released(a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_BUTTON_RELEASED_STATE; a_nb_clicks: NATURAL_8)
			-- <Precursor>
		do
			if a_mouse_state.is_left_button_released then
				if grid.has_o_won or grid.has_x_won or grid.is_full then
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
						if not grid.is_full and not grid.has_o_won and not grid.has_x_won then
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

end
