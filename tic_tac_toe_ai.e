note
	description: "An artifical intelligence that can play standard Tic Tac Toe"
	author: "Louis Marchand"
	date: "Tue, 15 Dec 2015 00:42:19 +0000"
	revision: "1.0"

class
	TIC_TAC_TOE_AI

create
	make

feature {NONE} -- Initialization

	make(a_is_o:BOOLEAN)
		do
			is_o := a_is_o
		end

feature -- Access

	play(a_grid:TIC_TAC_TOE_GRID)
			-- Select the first selectionnable cell in `a_grid'
		require
			Is_Playable: not a_grid.is_full and not a_grid.has_o_won and not a_grid.has_x_won
		local
			l_has_selected:BOOLEAN
			i, j:INTEGER
		do
			from
				i := 1
			until
				l_has_selected or i > a_grid.items.count
			loop
				from
					j := 1
				until
					l_has_selected or j > a_grid.items.at (i).count
				loop
					a_grid.select_cell (is_o, i, j)
					l_has_selected := attached a_grid.last_selected_cell
					j := j + 1
				end
				i := i + 1
			end
		end

	is_o:BOOLEAN
			-- If set, `Current' as the {MARKS} 0; X if unset.

end
