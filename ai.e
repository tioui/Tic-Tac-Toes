note
	description: "A very poor artifical intelligence (ToDo)."
	author: "Louis Marchand"
	date: "Tue, 07 Apr 2020 18:35:18 +0000"
	revision: "0.1"

deferred class
	AI


feature {NONE} -- Initialization

	make(a_is_o:BOOLEAN)
			-- Initialisation of `Current' using `a_is_o' as `is_o'.
		do
			is_o := a_is_o
		end

feature -- Access

	play(a_grid:GRID)
			-- Select the first selectionnable cell in `a_grid'
		require
			Is_Playable: not a_grid.is_full and not a_grid.has_o_won and not a_grid.has_x_won
		deferred
		end

	is_o:BOOLEAN
			-- If set, `Current' as the {MARKS} 0; X if unset.
end
