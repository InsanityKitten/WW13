var/list/global/floor_cache = list()

/turf/floor/trench
	name = "trench"
	icon = 'icons/WW2/trench.dmi'
	icon_state = "trench"
	base_icon_state = "trench"
	move_delay = 2
	//var/image/over_OS_darkness = null
	plane = UNDERFLOOR_PLANE
	initial_flooring = /decl/flooring/trench

/turf/floor/trench/New()
	if (!icon_state)
		icon_state = "trench"
	//over_OS_darkness = image('icons/turf/floors.dmi', "black_open")
	//over_OS_darkness.plane = GAME_PLANE
	//over_OS_darkness.layer = 25
	//over_OS_darkness.blend_mode = BLEND_MULTIPLY
	..()
	spawn(4)
		if (src)
			update_icon()
			for (var/direction in list(1,2,4,8,5,6,9,10))
				if (istype(get_step(src,direction),/turf/floor))
					var/turf/floor/FF = get_step(src,direction)
					FF.update_icon() //so siding get updated properly


/decl/flooring/trench
	name = "trench"
	desc = "Hole in the ground."
	icon = 'icons/WW2/trench.dmi'
	icon_base = "trench"
	flags = SMOOTH_ONLY_WITH_ITSELF | TURF_HAS_EDGES

/turf/floor/trench/attackby(obj/item/C as obj, mob/user as mob,mob/living/carbon/human/H as mob)
	if (istype(C, /obj/item/stack/material/wood))
		if (H)
			if (H.getStatCoeff("engineering") < GET_MIN_STAT_COEFF(STAT_VERY_HIGH))
				H << "<span class = 'notice'>You have no idea of how to build this.</span>"
				return
			visible_message("<span class = 'notice'>[H] starts to reinforce a trench.</span>")
			if (!do_after(H, 100, src))
				return
			icon_state = "trench_reinforced"
			move_delay = 0.5

/turf/floor/plating/dirt
	var/trench_stage = 0
	available_dirt = 2
/turf/floor/trench/Enter(atom/movable/O, atom/oldloc)
	if(isliving(O))
		var/mob/living/L = O
		var/message_cooldown
		if(!istype(oldloc, /turf/floor/trench))
			if(L.grabbed_by && L.grabbed_by.len)
				var/mob/living/L2 = L.grabbed_by[1].assailant
				visible_message("<span class = 'notice'>[L2] starts pulling [L] out of trench.</span>")
				if(!do_after(L2, 20, oldloc))
					return FALSE
				if(..())
					visible_message("<span class = 'notice'>[L2] pulls [L] out of trench.</span>")
					L.forceMove(src)
					return TRUE
				return FALSE
			if(world.time > message_cooldown + 30)
				visible_message("<span class = 'notice'>[L] starts to enter a trench.</span>")
				message_cooldown = world.time
			if (!do_after(L, 5, src, needhand = FALSE))
				return FALSE
			if(..())
				visible_message("<span class = 'notice'>[L] enters a trench.</span>")
				L.forceMove(src)
				return 1

	return ..()

/turf/floor/trench/Exit(atom/movable/O, atom/newloc)
	if(isliving(O))
		var/mob/living/L = O
		var/message_cooldown
		if(!istype(newloc, /turf/floor/trench))
			if(L.grabbed_by && L.grabbed_by.len)
				var/mob/living/L2 = L.grabbed_by[1].assailant
				visible_message("<span class = 'notice'>[L2] starts pulling [L] out of trench.</span>")
				if(!do_after(L2, 35, src))
					return FALSE
				if(..())
					visible_message("<span class = 'notice'>[L2] pulls [L] out of trench.</span>")
					L.forceMove(newloc)
					return TRUE
				return FALSE
			var/atom/newlocation = get_step(L,L.dir)
			if (newlocation.density)
				return FALSE
			for (var/atom/A in newlocation)
				if (A.density)
					return FALSE
			if(world.time > message_cooldown + 30)
				visible_message("<span class = 'notice'>[L] starts to exit a trench.</span>")
				message_cooldown = world.time
			if (!do_after(L, 20, src, needhand = FALSE))
				return FALSE
			if(..())
				visible_message("<span class = 'notice'>[L] exits a trench.</span>")
				var/turf/T = newloc
				if(T.Enter(O, src))
					L.forceMove(newloc)
				return TRUE

	return ..()

/turf/open/trench/update_icon()
	..()
	//Trench needs open_space like system or some object upon it so the objects inside get shaded
	//overlays.Cut()
	//var/image/over_OS_darkness = image('icons/turf/floors.dmi', "black_open")
	//over_OS_darkness.plane = GAME_PLANE
	//over_OS_darkness.layer = 25
	//overlays += over_OS_darkness

/turf/floor/plating/dirt/attackby(obj/item/C as obj, mob/user as mob,mob/living/carbon/human/H as mob)
	if (istype(C, /obj/item/weapon/shovel))
		var/obj/item/weapon/shovel/S = C
		visible_message("<span class = 'notice'>[user] starts to dig a trench.</span>")
		if (!do_after(user, (10 - S.dig_speed)*10, src))
			return
		trench_stage++
		switch(trench_stage)
			if(1)
				//icon_state = ""
				visible_message("<span class = 'notice'>[user] digs.</span>")
				var/turf = get_turf(src)
				new /obj/item/weapon/dirt_wall(turf)
				user << ("<span class = 'notice'>You need to dig this tile one more time to make a trench.</span>")
				return
			if(2)
				visible_message("<span class = 'notice'>[user] makes a trench.</span>")
				ChangeTurf(/turf/floor/trench)
		return
	..()
/turf/floor/plating/beach/sand
	var/trench_stage = 0
/turf/floor/plating/beach/sand/attackby(obj/item/C as obj, mob/user as mob)
	if (istype(C, /obj/item/weapon/shovel))
		var/obj/item/weapon/shovel/S = C
		visible_message("<span class = 'notice'>[user] starts to dig a trench.</span>")
		if (!do_after(user, (10 - S.dig_speed)*10, src))
			return
		trench_stage++
		switch(trench_stage)
			if(1)
				//icon_state = ""
				visible_message("<span class = 'notice'>[user] digs.</span>")
				user << ("<span class = 'notice'>You need to dig this tile one more time to make a trench.</span>")
				return
			if(2)
				visible_message("<span class = 'notice'>[user] makes a trench.</span>")
				ChangeTurf(/turf/floor/trench)
		return
	..()

/turf/floor/plating/sand
	var/trench_stage = 0
/turf/floor/plating/sand/attackby(obj/item/C as obj, mob/user as mob)
	if (istype(C, /obj/item/weapon/shovel))
		var/obj/item/weapon/shovel/S = C
		visible_message("<span class = 'notice'>[user] starts to dig a trench.</span>")
		if (!do_after(user, (10 - S.dig_speed)*10, src))
			return
		trench_stage++
		switch(trench_stage)
			if(1)
				//icon_state = ""
				visible_message("<span class = 'notice'>[user] digs.</span>")
				user << ("<span class = 'notice'>You need to dig this tile one more time to make a trench.</span>")
				return
			if(2)
				visible_message("<span class = 'notice'>[user] makes a trench.</span>")
				ChangeTurf(/turf/floor/trench)
		return
	..()

/turf/floor/dirt/attackby(obj/item/C as obj, mob/user as mob)
	if (istype(C, /obj/item/weapon/shovel))
		var/obj/item/weapon/shovel/S = C
		visible_message("<span class = 'notice'>[user] starts to dig a trench.</span>")
		if (!do_after(user, (10 - S.dig_speed)*10, src))
			return
		trench_stage++
		switch(trench_stage)
			if(1)
				//icon_state = ""
				visible_message("<span class = 'notice'>[user] digs.</span>")
				user << ("<span class = 'notice'>You need to dig this tile one more time to make a trench.</span>")
				return
			if(2)
				visible_message("<span class = 'notice'>[user] makes a trench.</span>")
				ChangeTurf(/turf/floor/trench)
		return
	..()

/turf/floor/plating/grass/attackby(obj/item/C as obj, mob/user as mob)
	if (istype(C, /obj/item/weapon/shovel))
		var/obj/item/weapon/shovel/S = C
		visible_message("<span class = 'notice'>[user] starts to remove grass layer.</span>")
		if (!do_after(user, (10 - S.dig_speed)*10, src))
			return
		visible_message("<span class = 'notice'>[user] removes grass layer.</span>")
		ChangeTurf(/turf/floor/plating/dirt)
		return
	..()