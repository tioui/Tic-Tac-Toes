note
	description: "The game grid"
	author: "Louis Marchand"
	date: "Mon, 07 Dec 2015 15:46:55 +0000"
	revision: "1.0"

class
	GRID

create
	make

feature -- Initialization

	make(a_images_factory:IMAGES_FACTORY; a_x, a_y, a_width, a_height:INTEGER)
			-- Initialization of `Current' with `a_x', `a_y', `a_width' and `a_height' as `bound' values
		local
			l_marks_list:ARRAYED_LIST[detachable MARKS]
		do
			images_factory := a_images_factory
			image := a_images_factory.panel
			bound := [a_x, a_y, a_width, a_height]
			create default_o_mark.make (a_images_factory, True)
			create default_x_mark.make (a_images_factory, False)
			create {ARRAYED_LIST[LIST[detachable MARKS]]} marks.make (3)
			across 1 |..| 3 as la_list_index loop
				create l_marks_list.make_filled (3)
				marks.extend (l_marks_list)
			end
			has_last_selected := False
			has_o_won := False
			has_x_won := False
			winning_index := 0
		end

feature -- Access

	bound:TUPLE[x, y, width, height:INTEGER]
			-- Where to draw `Current'

	marks:LIST[LIST[detachable MARKS]]
			-- The {MARKS} that the players have put in `Current'


	draw(a_renderer:GAME_RENDERER)
			-- Draw the representation of `Current' on the `a_renderer'
		local
			l_marks_width, l_marks_height, i, j:INTEGER
		do
			a_renderer.draw_sub_texture_with_scale (
									image, 0, 0, image.width, image.height,
									bound.x, bound.y, bound.width, bound.height
								)
			l_marks_width := bound.width // 3
			l_marks_height := bound.height // 3
			i := 0
			across
				marks as la_marks_list
			loop
				j := 0
				across la_marks_list.item as la_marks loop
					if attached la_marks.item as la_mark then
						la_mark.draw (a_renderer, l_marks_width * j, l_marks_height * i, l_marks_width, l_marks_height)
					end
					j := j + 1
				end
				i := i + 1
			end
			draw_wining_image(a_renderer)
		end

	draw_wining_image(a_renderer:GAME_RENDERER)
			-- Draw the `win_image' on `Current' if needed
		do
			if winning_index /= 0 then
				if win_image = Void then
					create_winning_image (a_renderer)
				end
				if attached win_image as la_win_image then
					if winning_index >= 1 and winning_index <= 3 then
						a_renderer.draw_sub_texture_with_scale (
										la_win_image, 0, 0, la_win_image.width, la_win_image.height,
										(bound.width // 6), (winning_index - 1) * (bound.height // 3) + (bound.height // 9), 4 * (bound.width // 6), (bound.height // 8)
									)
					elseif winning_index >= 4 and winning_index <= 6 then
						a_renderer.draw_sub_texture_with_scale (
										la_win_image, 0, 0, la_win_image.width, la_win_image.height,
										(winning_index - 4) * (bound.width // 3) + (bound.width // 9), (bound.height // 6), (bound.width // 8), 4 * (bound.height // 6)
									)
					elseif winning_index >= 7 then
						a_renderer.draw_sub_texture_with_scale (
										la_win_image, 0, 0, la_win_image.width, la_win_image.height,
										(bound.width // 9), (bound.height // 9), 7 * (bound.width // 9), 7 * (bound.height // 9)
									)
					end
				end

			end
		end

	image:GAME_TEXTURE
			-- The image representing `Current'

	win_image:detachable GAME_TEXTURE
			-- Image that is place on the winning marks (row/column/diagonal)

	select_cell(a_o_turn:BOOLEAN; a_x, a_y:INTEGER)
			-- Select the cell at position (`a_x',`a_y').
			-- If `a_o_turn' is set, it is the O player
			-- that have launch the select, X if not.
		local
			l_x_index, l_y_index:INTEGER
		do
			has_last_selected := False
			if winning_index = 0 and a_x > bound.x and a_x < bound.x + bound.width and a_y > bound.y and a_y < bound.y + bound.height then
				l_x_index := ((a_x - bound.x) // (bound.width // 3)) + 1
				l_y_index := ((a_y - bound.y) // (bound.height // 3)) + 1
				if
					marks.valid_index (l_y_index)
				and then
					marks.at (l_y_index).valid_index (l_x_index)
				and then
					marks.at (l_y_index).at (l_x_index) = Void
				then
					has_last_selected := True
					if a_o_turn then
						marks.at (l_y_index).at (l_x_index) := default_o_mark
					else
						marks.at (l_y_index).at (l_x_index) := default_x_mark
					end
					valid_winner
				end
			end
		end

	has_last_selected:BOOLEAN
			-- Indicate if a valid cell has been selected by the last call to `select_cell'


	has_o_won:BOOLEAN
			-- The player O has won the game

	has_x_won:BOOLEAN
			-- The player X has won the game

feature {NONE} -- Implementation

	valid_winner
			-- Valid if there is a winning combinaision. If so, set `has_o_won' or `has_x_won'
		do
			across 1 |..| 3 as la_index loop
				if marks.at (la_index.item).at (1) = marks.at (la_index.item).at (2) and marks.at (la_index.item).at (1) = marks.at (la_index.item).at (3) then
					if attached marks.at (la_index.item).at (1) as la_marks then
						winning_index := la_index.item
						has_o_won := la_marks.is_o
						has_x_won := la_marks.is_x
					end
				end
				if marks.at (1).at (la_index.item) = marks.at (2).at (la_index.item) and marks.at (1).at (la_index.item) = marks.at (3).at (la_index.item) then
					if attached marks.at (1).at (la_index.item) as la_marks then
						winning_index := la_index.item + 3
						has_o_won := la_marks.is_o
						has_x_won := la_marks.is_x
					end
				end
			end
			if marks.at (1).at (1) = marks.at (2).at (2) and marks.at (1).at (1) = marks.at (3).at (3) then
				if attached marks.at (1).at (1) then
					winning_index := 7
				end
			end
			if marks.at (2).at (2) = marks.at (1).at (3) and marks.at (2).at (2) = marks.at (3).at (1) then
				if attached marks.at (2).at (2) then
					winning_index := 8
				end
			end
		end

	create_winning_image(a_renderer:GAME_RENDERER)
			-- Create the `win_image' depending of the type of winning (see: `winning_index').
		local
			l_old_target: GAME_RENDER_TARGET
			l_old_color:GAME_COLOR
		do
			l_old_target := a_renderer.target
			l_old_color := a_renderer.drawing_color
			if winning_index >= 1 and winning_index <= 3 then
				create_winning_image_target(a_renderer, images_factory.win.pixel_format, images_factory.win.height, images_factory.win.width)
				a_renderer.draw_sub_texture_with_scale_rotation_and_mirror (
									images_factory.win, 0, 0, images_factory.win.width, images_factory.win.height, 0,
									images_factory.win.width, images_factory.win.width, images_factory.win.height, 0, 0,
									-90, False, False
								)
			elseif winning_index >= 4 and winning_index <= 6 then
				win_image := images_factory.win
			elseif winning_index = 7 then
				create_winning_image_target(
								a_renderer, images_factory.win.pixel_format,
								images_factory.win.height + (images_factory.win.width // 2),
								images_factory.win.height + (images_factory.win.width // 2)
							)
				a_renderer.draw_sub_texture_with_scale_rotation_and_mirror (
									images_factory.win, 0, 0, images_factory.win.width, images_factory.win.height, 0,
									images_factory.win.width // 2, images_factory.win.width,
									{DOUBLE_MATH}.sqrt ((images_factory.win.height * images_factory.win.height) * 2).floor, 0, 0,
									-45, False, False
								)
			elseif winning_index = 8 then
				create_winning_image_target(
								a_renderer, images_factory.win.pixel_format,
								images_factory.win.height + (images_factory.win.width // 2),
								images_factory.win.height + (images_factory.win.width // 2)
							)
				a_renderer.draw_sub_texture_with_scale_rotation_and_mirror (
									images_factory.win, 0, 0, images_factory.win.width, images_factory.win.height, images_factory.win.width // 2,
									images_factory.win.height + images_factory.win.width // 2, images_factory.win.width,
									{DOUBLE_MATH}.sqrt ((images_factory.win.height * images_factory.win.height) * 2).floor, 0, 0,
									-135, False, False
								)
			end
			a_renderer.set_drawing_color (l_old_color)
			a_renderer.set_target (l_old_target)
		end

	create_winning_image_target(a_renderer:GAME_RENDERER; a_format:GAME_PIXEL_FORMAT_READABLE; a_width, a_height:INTEGER)
			-- Create the `win_image' texture with dimension (`a_width'x`a_height') as a rendering target for `a_renderer'
			-- using `a_format' as pixel format.
			-- Note: Change the rendering `target' of `a_renderer'
		local
			l_target:GAME_TEXTURE
		do
			create l_target.make_target (a_renderer, a_format, a_width, a_height)
			l_target.enable_alpha_blending
			a_renderer.set_target (l_target)
			a_renderer.set_drawing_color (create {GAME_COLOR}.make (0, 0, 0, 0))
			a_renderer.draw_filled_rectangle (0, 0, l_target.width, l_target.height)
			win_image := l_target
		end

	default_o_mark:MARKS
			-- The O mark used in `Current'

	default_x_mark:MARKS
			-- The X mark used in `Current'

	winning_index:INTEGER
			-- The index of the winning type
			-- 0 means no victory
			-- 1 to 3 means line victory
			-- 4 to 6 means column victory
			-- 7 and 8 means diagonal

	images_factory:IMAGES_FACTORY
			-- The factory that generate image ressources


invariant
	Winning_Means_index: (has_o_won or has_o_won) implies ((winning_index >= 1) and (winning_index <= 8))
	Index_Means_Winning: (winning_index /= 0) implies (has_o_won or has_o_won)
end
