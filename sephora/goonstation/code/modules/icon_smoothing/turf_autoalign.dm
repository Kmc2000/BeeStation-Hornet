// maps: COG2 causes nornwalls, DESTINY causes gannetwalls, anything else doesn't get saved
//GOONSTATION CODE IN SEPERATE FOLDER FOR LICENSE AGREEMENT//

/* =================================================== */
/* -------------------- SIMULATED -------------------- */
/* =================================================== */

/atom
	var/smoothing_d_state = 0 //Smoothing stuff

/turf/closed/wall/ship
	icon = 'sephora/icons/turf/interior_wall.dmi'
	name = "Durasteel hull"
	desc = "A large hull segment designed to create vessels and structures capable of supporting life in even the most hazardous places."
	legacy_smooth = TRUE //Override /tg/ iconsmooths
	smooth = TRUE
	canSmoothWith = list(/turf/closed/wall/ship,/turf/closed/wall/r_wall/ship,/obj/machinery/door,/obj/structure/window)
	sheet_type = /obj/item/stack/sheet/durasteel
	var/connect_universally = TRUE //Connect to every subtype of the walls?

/turf/closed/wall/ship/Initialize()
	. = ..()
	if(connect_universally)
		canSmoothWith += typecacheof(/turf/closed/wall/ship)
		canSmoothWith += typecacheof(/obj/structure/window)
		canSmoothWith += typecacheof(/obj/machinery/door) //tg smoothing is finnicky

	// ty to somepotato for assistance with making this proc actually work right :I

/atom/proc/legacy_smooth() //overwrite the smoothing to use icon smooth SS
	var/builtdir = 0
	for (var/dir in GLOB.cardinals)
		var/turf/T = get_step(src, dir)
		if (T.type == src.type || (T.type in canSmoothWith))
			builtdir |= dir
		else if (canSmoothWith)
			for (var/i=1, i <= canSmoothWith.len, i++)
				var/atom/A = locate(canSmoothWith[i]) in T
				if (!isnull(A))
					if (istype(A, /atom/movable))
						var/atom/movable/M = A
						if (!M.anchored)
							continue
					builtdir |= dir
					break

	src.icon_state = "[builtdir][src.smoothing_d_state ? "C" : null]"