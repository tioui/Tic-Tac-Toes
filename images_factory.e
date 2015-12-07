note
	description: "Factory that generate every images of the game"
	author: "Louis Marchand"
	date: "Sun, 06 Dec 2015 22:12:04 +0000"
	revision: "1.0"

class
	IMAGES_FACTORY

create
	make

feature {NONE} -- Constants

	File_directory:READABLE_STRING_GENERAL
			-- The directory (or sub-directory) containing the image files
		once
			Result := "images"
		end

	File_extension:READABLE_STRING_GENERAL
			-- The complete extension of the image files
		once
			Result := "png"
		end

feature {NONE} -- Initialization

	make(a_renderer:GAME_RENDERER; a_format:GAME_PIXEL_FORMAT_READABLE)
			-- Initialization of `Current' using `a_renderer' and `a_format'
			-- to create default {GAME_TEXTURE}
		do
			has_error := False
			if attached load_image(a_renderer, "x") as la_image then
				x := la_image
			else
				create x.make_not_lockable (a_renderer, a_format, 1, 1)
				has_error := True
			end
			if not has_error and then attached load_image(a_renderer, "o") as la_image then
				o := la_image
			else
				create o.make_not_lockable (a_renderer, a_format, 1, 1)
				has_error := True
			end
			if not has_error and then attached load_image(a_renderer, "panel") as la_image then
				panel := la_image
			else
				create panel.make_not_lockable (a_renderer, a_format, 1, 1)
				has_error := True
			end
			if not has_error and then attached load_image(a_renderer, "win") as la_image then
				win := la_image
			else
				create win.make_not_lockable (a_renderer, a_format, 1, 1)
				has_error := True
			end
		end

feature -- Access

	x:GAME_TEXTURE
			-- The image texture that represent the X mark

	o:GAME_TEXTURE
			-- The image texture that represent the O mark

	panel:GAME_TEXTURE
			-- The image texture that represent the game grid

	win:GAME_TEXTURE
			-- The image texture that is put on the panel when a player has won

	has_error:BOOLEAN
			-- An error occured at creation

feature {NONE} -- Implementation

	load_image(a_renderer:GAME_RENDERER; a_name:READABLE_STRING_GENERAL):detachable GAME_TEXTURE
			-- Create a {GAME_TEXTURE} from an image file identified by `a_name'
		local
			l_image:IMG_IMAGE_FILE
			l_path:PATH
		do
			Result := Void
			create l_path.make_from_string (File_directory)
			l_path := l_path.extended (a_name)
			l_path := l_path.appended_with_extension (file_extension)
			create l_image.make (l_path.name)
			if l_image.is_openable then
				l_image.open
				if l_image.is_open then
					create Result.make_from_image (a_renderer, l_image)
					if Result.has_error then
						Result := Void
					end
				end
			end
		ensure
			Image_Exist: attached Result
		end

end
