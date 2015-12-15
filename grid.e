note
	description: "Abstraction of a game grid"
	author: "Louis Marchand"
	date: "Tue, 08 Dec 2015 22:50:32 +0000"
	revision: ""

deferred class
	GRID

inherit
	PANEL
		rename
			make as make_panel
		end

feature {NONE} -- Initialization

	make(a_ressources_factory:RESSOURCES_FACTORY; a_x, a_y, a_width, a_height:INTEGER)
			-- Initialization of `Current' with `a_x', `a_y', `a_width' and `a_height' as `bound' values
			-- and using `a_ressources_factory' to get image ressources
		do
			make_panel(a_x, a_y, a_width, a_height)
			ressources_factory := a_ressources_factory
			image := a_ressources_factory.grid_image
		end

feature -- Access

	items:LIST[LIST[detachable GRID_ITEM]]
			-- The {MARKS} that the players have put in `Current'
		deferred
		end

	has_o_won:BOOLEAN
			-- The player O has won the game
		deferred
		end

	has_x_won:BOOLEAN
			-- The player X has won the game
		deferred
		end

	is_full:BOOLEAN
			-- Every cell of `Current' has been used
		deferred
		end

	image:GAME_TEXTURE
			-- The image representing `Current'

	draw(a_renderer:GAME_RENDERER)
			-- Draw the representation of `Current' on the `a_renderer'
		do
			a_renderer.draw_sub_texture_with_scale (
									image, 0, 0, image.width, image.height,
									bound.x, bound.y, bound.width, bound.height
								)
		end

feature {NONE} -- Implementation

	ressources_factory:RESSOURCES_FACTORY
			-- The factory that generate image ressources

end
