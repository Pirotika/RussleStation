/obj/structure/janitorialcart
        name = "janitorial cart"
        desc = "The ultimate in janitorial carts! Has space for water, mops, signs, trash bags, and more!"
        icon = 'icons/obj/janitor.dmi'
        icon_state = "cart"
        anchored = 0
        density = 1
        flags = OPENCONTAINER
        //copypaste sorry
        var/amount_per_transfer_from_this = 5 //shit I dunno, adding this so syringes stop runtime erroring. --NeoFite
        var/obj/item/weapon/storage/bag/trash/mybag        = null
        var/obj/item/weapon/mop/mymop = null
        var/obj/item/weapon/reagent_containers/spray/myspray = null
        var/obj/item/device/lightreplacer/myreplacer = null
        var/signs = 0        //maximum capacity hardcoded below


/obj/structure/janitorialcart/New()
        create_reagents(100)


/obj/structure/janitorialcart/examine()
        set src in usr
        usr << "[src] \icon[src] contains [reagents.total_volume] unit\s of liquid!"
        ..()
        //everything else is visible, so doesn't need to be mentioned


/obj/structure/janitorialcart/attackby(obj/item/I, mob/user)
        if(istype(I, /obj/item/weapon/storage/bag/trash) && !mybag)
                user.drop_item()
                mybag = I
                I.loc = src
                update_icon()
                updateUsrDialog()
                user << "<span class='notice'>You put [I] into [src].</span>"

        else if(istype(I, /obj/item/weapon/mop))
                if(I.reagents.total_volume < I.reagents.maximum_volume)        //if it's not completely soaked we assume they want to wet it, otherwise store it
                        if(reagents.total_volume < 1)
                                user << "[src] is out of water!</span>"
                        else
                                reagents.trans_to(I, 5)        //
                                user << "<span class='notice'>You wet [I] in [src].</span>"
                                playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
                                return
                if(!mymop)
                        user.drop_item()
                        mymop = I
                        I.loc = src
                        update_icon()
                        updateUsrDialog()
                        user << "<span class='notice'>You put [I] into [src].</span>"

        else if(istype(I, /obj/item/weapon/reagent_containers/spray) && !myspray)
                user.drop_item()
                myspray = I
                I.loc = src
                update_icon()
                updateUsrDialog()
                user << "<span class='notice'>You put [I] into [src].</span>"

        else if(istype(I, /obj/item/device/lightreplacer) && !myreplacer)
                user.drop_item()
                myreplacer = I
                I.loc = src
                update_icon()
                updateUsrDialog()
                user << "<span class='notice'>You put [I] into [src].</span>"

        else if(istype(I, /obj/item/weapon/caution))
                if(signs < 4)
                        user.drop_item()
                        I.loc = src
                        signs++
                        update_icon()
                        updateUsrDialog()
                        user << "<span class='notice'>You put [I] into [src].</span>"
                else
                        user << "<span class='notice'>[src] can't hold any more signs.</span>"

        else if(mybag)
                mybag.attackby(I, user)


/obj/structure/janitorialcart/attack_hand(mob/user)
        user.set_machine(src)
        var/dat
        if(mybag)
                dat += "<a href='?src=\ref[src];garbage=1'>[mybag.name]</a><br>"
        if(mymop)
                dat += "<a href='?src=\ref[src];mop=1'>[mymop.name]</a><br>"
        if(myspray)
                dat += "<a href='?src=\ref[src];spray=1'>[myspray.name]</a><br>"
        if(myreplacer)
                dat += "<a href='?src=\ref[src];replacer=1'>[myreplacer.name]</a><br>"
        if(signs)
                dat += "<a href='?src=\ref[src];sign=1'>[signs] sign\s</a><br>"
        var/datum/browser/popup = new(user, "janicart", name, 240, 160)
        popup.set_content(dat)
        popup.open()


/obj/structure/janitorialcart/Topic(href, href_list)
        if(!in_range(src, usr))
                return
        if(!isliving(usr))
                return
        var/mob/living/user = usr
        if(href_list["garbage"])
                if(mybag)
                        user.put_in_hands(mybag)
                        user << "<span class='notice'>You take [mybag] from [src].</span>"
                        mybag = null
        if(href_list["mop"])
                if(mymop)
                        user.put_in_hands(mymop)
                        user << "<span class='notice'>You take [mymop] from [src].</span>"
                        mymop = null
        if(href_list["spray"])
                if(myspray)
                        user.put_in_hands(myspray)
                        user << "<span class='notice'>You take [myspray] from [src].</span>"
                        myspray = null
        if(href_list["replacer"])
                if(myreplacer)
                        user.put_in_hands(myreplacer)
                        user << "<span class='notice'>You take [myreplacer] from [src].</span>"
                        myreplacer = null
        if(href_list["sign"])
                if(signs)
                        var/obj/item/weapon/caution/Sign = locate() in src
                        if(Sign)
                                user.put_in_hands(Sign)
                                user << "<span class='notice'>You take \a [Sign] from [src].</span>"
                                signs--
                        else
                                warning("[src] signs ([signs]) didn't match contents")
                                signs = 0

        update_icon()
        updateUsrDialog()

/obj/structure/stool/bed/chair/cart/
	icon = 'icons/obj/vehicles.dmi'
	anchored = 1
	density = 1
	var/empstun = 0
	var/health = 100
	var/destroyed = 0
	var/inertia_dir = 0
	var/allowMove = 1
	var/delay = 1
	var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread

/obj/structure/janitorialcart/update_icon()
        overlays = null
        if(mybag)
                overlays += "cart_garbage"
        if(mymop)
                overlays += "cart_mop"
        if(myspray)
                overlays += "cart_spray"
        if(myreplacer)
                overlays += "cart_replacer"
        if(signs)
                overlays += "cart_sign[signs]"




/obj/structure/stool/bed/chair/cart/Move()
	..()
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			buckled_mob.loc = loc

/obj/structure/stool/bed/chair/cart/process()
	if(empstun > 0)
		empstun--
	if(empstun < 0)
		empstun = 0

/obj/structure/stool/bed/chair/cart/New()
	processing_objects |= src
	handle_rotation()

/obj/structure/stool/bed/chair/cart/examine()
	set src in usr
	switch(health)
		if(75 to 99)
			usr << "\blue It appears slightly dented."
		if(40 to 74)
			usr << "\red It appears heavily dented."
		if(1 to 39)
			usr << "\red It appears severely dented."
		if((INFINITY * -1) to 0)
			usr << "It appears completely unsalvageable"

/obj/structure/stool/bed/chair/cart/attackby(obj/item/W, mob/user)
	if (istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if (WT.remove_fuel(0))
			if(destroyed)
				user << "\red The [src.name] is destroyed beyond repair."
			add_fingerprint(user)
			user.visible_message("\blue [user] has fixed some of the dents on [src].", "\blue You fix some of the dents on \the [src]")
			health += 20
			HealthCheck()
		else
			user << "Need more welding fuel!"
			return
	if(istype(W, /obj/item/key))
		user << "Hold [W] in one of your hands while you drive this [name]."

/obj/structure/stool/bed/chair/cart/proc/Process_Spacemove(var/check_drift = 0, mob/user)
	//First check to see if we can do things

	/*
	if(istype(src,/mob/living/carbon))
		if(src.l_hand && src.r_hand)
			return 0
	*/

	var/dense_object = 0
	if(!user)
		for(var/turf/turf in oview(1,src))
			if(istype(turf,/turf/space))
				continue
			/*
			if((istype(turf,/turf/simulated/floor))
				if(user)
					if(user.lastarea.has_gravity == 0)
						continue*/



		/*
		if(istype(turf,/turf/simulated/floor) && (src.flags & NOGRAV))
			continue
		*/


			dense_object++
			break

		if(!dense_object && (locate(/obj/structure/lattice) in oview(1, src)))
			dense_object++

		//Lastly attempt to locate any dense objects we could push off of
		//TODO: If we implement objects drifing in space this needs to really push them
		//Due to a few issues only anchored and dense objects will now work.
		if(!dense_object)
			for(var/obj/O in oview(1, src))
				if((O) && (O.density) && (O.anchored))
					dense_object++
					break
	else
		for(var/turf/turf in oview(1,user))
			if(istype(turf,/turf/space))
				continue
			/*
			if((istype(turf,/turf/simulated/floor))
				if(user)
					if(user.lastarea.has_gravity == 0)
						continue*/



		/*
		if(istype(turf,/turf/simulated/floor) && (src.flags & NOGRAV))
			continue
		*/


			dense_object++
			break

		if(!dense_object && (locate(/obj/structure/lattice) in oview(1, user)))
			dense_object++

		//Lastly attempt to locate any dense objects we could push off of
		//TODO: If we implement objects drifing in space this needs to really push them
		//Due to a few issues only anchored and dense objects will now work.
		if(!dense_object)
			for(var/obj/O in oview(1, user))
				if((O) && (O.density) && (O.anchored))
					dense_object++
					break
	//Nothing to push off of so end here
	if(!dense_object)
		return 0


/* The cart has very grippy tires and or magnets to keep it from slipping when on a good surface
	//Check to see if we slipped
	if(prob(Process_Spaceslipping(5)))
		src << "\blue <B>You slipped!</B>"
		src.inertia_dir = src.last_move
		step(src, src.inertia_dir)
		return 0
	//If not then we can reset inertia and move
	*/
	inertia_dir = 0
	return 1

/obj/structure/stool/bed/chair/cart/buckle_mob(mob/M, mob/user)
	if(M != user || !ismob(M) || get_dist(src, user) > 1 || user.restrained() || user.lying || user.stat || M.buckled || istype(user, /mob/living/silicon) || destroyed)
		return

	unbuckle()

	M.visible_message(\
		"<span class='notice'>[M] climbs onto the [name]!</span>",\
		"<span class='notice'>You climb onto the [name]!</span>")
	M.buckled = src
	M.loc = loc
	M.dir = dir
	M.update_canmove()
	buckled_mob = M
	update_mob()
	add_fingerprint(user)
	return

/obj/structure/stool/bed/chair/cart/unbuckle()
	if(buckled_mob)
		buckled_mob.pixel_x = 0
		buckled_mob.pixel_y = 0
	..()

/obj/structure/stool/bed/chair/cart/handle_rotation()
	if(dir == SOUTH)
		layer = FLY_LAYER
	else
		layer = OBJ_LAYER

	if(buckled_mob)
		if(buckled_mob.loc != loc)
			buckled_mob.buckled = null //Temporary, so Move() succeeds.
			buckled_mob.buckled = src //Restoring

	update_mob()

/obj/structure/stool/bed/chair/cart/proc/update_mob()
	if(buckled_mob)
		buckled_mob.dir = dir
		switch(dir)
			if(SOUTH)
				buckled_mob.pixel_x = 0
				buckled_mob.pixel_y = 7
			if(WEST)
				buckled_mob.pixel_x = 13
				buckled_mob.pixel_y = 7
			if(NORTH)
				buckled_mob.pixel_x = 0
				buckled_mob.pixel_y = 4
			if(EAST)
				buckled_mob.pixel_x = -13
				buckled_mob.pixel_y = 7

/obj/structure/stool/bed/chair/cart/emp_act(severity)
	switch(severity)
		if(1)
			src.empstun = (rand(5,10))
		if(2)
			src.empstun = (rand(1,5))
	src.visible_message("\red The [src.name]'s motor short circuits!")
	spark_system.attach(src)
	spark_system.set_up(5, 0, src)
	spark_system.start()

/obj/structure/stool/bed/chair/cart/bullet_act(var/obj/item/projectile/Proj)
	var/hitrider = 0
	if(istype(Proj, /obj/item/projectile/ion))
		Proj.on_hit(src, 2)
		return
	if(buckled_mob)
		if(prob(75))
			hitrider = 1
			var/act = buckled_mob.bullet_act(Proj)
			if(act >= 0)
				visible_message("<span class='warning'>[buckled_mob.name] is hit by [Proj]!")
				if(istype(Proj, /obj/item/projectile/energy))
					unbuckle()
			return
		if(istype(Proj, /obj/item/projectile/energy/electrode))
			if(prob(25))
				unbuckle()
				visible_message("<span class='warning'>The [src.name] absorbs the [Proj]")
				if(!istype(buckled_mob, /mob/living/carbon/human))
					return buckled_mob.bullet_act(Proj)
				else
					var/mob/living/carbon/human/H = buckled_mob
					return H.electrocute_act(0, src, 1, 0)
	if(!hitrider)
		visible_message("<span class='warning'>[Proj] hits the [name]!</span>")
		if(!Proj.nodamage && Proj.damage_type == BRUTE || Proj.damage_type == BURN)
			health -= Proj.damage
		HealthCheck()

/obj/structure/stool/bed/chair/cart/proc/HealthCheck()
	if(health > 100) health = 100
	if(health <= 0 && !destroyed)
		destroyed = 1
		density = 0
		if(buckled_mob)
			unbuckle()
		visible_message("<span class='warning'>The [name] explodes!</span>")
		explosion(src.loc,-1,0,2,7,10)
		icon_state = "pussywagon_destroyed"

/obj/structure/stool/bed/chair/cart/ex_act(severity)
	switch (severity)
		if(1.0)
			health -= 100
		if(2.0)
			health -= 75
		if(3.0)
			health -= 45
	HealthCheck()



/obj/structure/stool/bed/chair/cart/janicart
	name = "janicart"
	icon = 'icons/obj/vehicles.dmi'
	desc = "Its the alpha and omega of sanitation."
	icon_state = "pussywagon"
	anchored = 1
	density = 1
	flags = OPENCONTAINER
	//copypaste sorry
	var/amount_per_transfer_from_this = 4
	var/obj/item/weapon/storage/bag/trash/mybag	= null
	var/obj/item/weapon/mop/mymop = null
	var/affected_area = 3
	var/callme = "pimpin' ride"

/obj/structure/stool/bed/chair/cart/janicart/New()
	handle_rotation()
	create_reagents(100)




/obj/structure/stool/bed/chair/cart/janicart/verb/empty()
	set name = "Empty All"
	set category = "Object"
	set src in oview(1)

	if(src.reagents.total_volume >= 1)
		usr << "<span class='notice'>You empty all of the [src]'s liquid.</span>"
		var/obj/effect/decal/D = new/obj/effect/decal(get_turf(src))
		D.create_reagents(src.reagents.total_volume)
		src.reagents.trans_to(D, src.reagents.total_volume)
		D.reagents.reaction(get_turf(D))
		src.reagents.clear_reagents()
		del (D)
	else
		usr << "<span class='notice'>Nothing To Empty.</span>"

/obj/structure/stool/bed/chair/cart/janicart/verb/empty2()
	set name = "Empty Some(4units)"
	set category = "Object"
	set src in oview(1)


	usr << "<span class='notice'>You empty some of the [src]'s liquid.</span>"
	var/obj/effect/decal/D = new/obj/effect/decal(get_turf(src))
	D.create_reagents(amount_per_transfer_from_this)
	src.reagents.trans_to(D, amount_per_transfer_from_this)
	D.reagents.reaction(get_turf(D))
	del (D)

/obj/structure/stool/bed/chair/cart/janicart/examine()
        set src in usr
        usr << "\icon[src] This [callme] contains [reagents.total_volume] unit\s of water!"
        if(mybag)
                usr << "\A [mybag] is hanging on the [callme]."

/obj/structure/stool/bed/chair/cart/janicart/attackby(obj/item/I, mob/user)
        if(istype(I, /obj/item/weapon/mop))
                if(reagents.total_volume > 1)
                        reagents.trans_to(I, 2)
                        user << "<span class='notice'>You wet [I] in the [callme].</span>"
                        playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
                else
                        user << "<span class='notice'>This [callme] is out of water!</span>"
        else if(istype(I, /obj/item/key))
                user << "Hold [I] in one of your hands while you drive this [callme]."
        else if(istype(I, /obj/item/weapon/storage/bag/trash))
                user << "<span class='notice'>You hook the trashbag onto the [callme].</span>"
                user.drop_item()
                I.loc = src
                mybag = I


/obj/structure/stool/bed/chair/cart/janicart/attack_hand(mob/user)

	if(mybag)
		mybag.loc = get_turf(user)
		user.put_in_hands(mybag)
		mybag = null
	else
		..()

/obj/structure/stool/bed/chair/cart/janicart/proc/clean(turf/simulated/A as turf)
	var/obj/effect/decal/D = new/obj/effect/decal(get_turf(src))
	D.create_reagents(amount_per_transfer_from_this)
	src.reagents.trans_to(D, amount_per_transfer_from_this)
	D.reagents.reaction(A,1,10)
	A.clean_blood()
	for(var/obj/effect/O in A)
		if( istype(O,/obj/effect/rune) || istype(O,/obj/effect/decal/cleanable) || istype(O,/obj/effect/overlay) )
			del(O)
			del(D)



/obj/structure/stool/bed/chair/cart/janicart/relaymove(mob/user, direction)
	if(user.stat || user.stunned || user.weakened || user.paralysis  || destroyed)
		unbuckle()
		return
	if(empstun > 0)
		if(user)
			user << "\red \the [src] is unresponsive."
		return
	if((istype(src.loc, /turf/space)))
		if(!src.Process_Spacemove(0))	return
	if(istype(user.l_hand, /obj/item/key) || istype(user.r_hand, /obj/item/key))
		if(!allowMove)
			return
		allowMove = 0
		step(src, direction)
		update_mob()
		handle_rotation()
		sleep(delay)
		allowMove = 1
			/*
		if(istype(src.loc, /turf/space) && (!src.Process_Spacemove(0, user)))
			var/turf/space/S = src.loc
			S.Entered(src)*/
	else
		user << "<span class='notice'>You'll need the keys in one of your hands to drive this pimpin' ride.</span>"

/obj/structure/stool/bed/chair/cart/janicart/Move()
	..()
	var/turf/tile = loc
	if(reagents.total_volume >=4)
		if(isturf(tile))
			tile.clean_blood()
			for(var/A in tile)
				if(istype(A, /obj/effect))
					if(istype(A, /obj/effect/rune) || istype(A, /obj/effect/decal/cleanable) || istype(A, /obj/effect/overlay))
						clean(get_turf(A))
				else if(istype(A, /mob/living/carbon/human))
					var/mob/living/carbon/human/cleaned_human = A
					if(cleaned_human.lying)
						if(cleaned_human.head)
							cleaned_human.head.clean_blood()
							cleaned_human.update_inv_head(0)
						if(cleaned_human.wear_suit)
							cleaned_human.wear_suit.clean_blood()
							cleaned_human.update_inv_wear_suit(0)
						else if(cleaned_human.w_uniform)
							cleaned_human.w_uniform.clean_blood()
							cleaned_human.update_inv_w_uniform(0)
						if(cleaned_human.shoes)
							cleaned_human.shoes.clean_blood()
							cleaned_human.update_inv_shoes(0)
						cleaned_human.clean_blood(1)
						cleaned_human << "\red [src] cleans your face!"


	return


////////////////////////////////////////////////////////////////////////////////////////////////

/obj/structure/stool/bed/chair/cart/ambulance
	name = "ambulance"
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "docwagon"
	anchored = 1
	density = 1
/var/brightness = 4
/var/strobe = 0

/obj/structure/stool/bed/chair/cart/ambulance/relaymove(mob/user, direction)
	if(user.stat || user.stunned || user.weakened || user.paralysis  || destroyed)
		unbuckle()
		return
	if(empstun > 0)
		if(user)
			user << "\red \the [src] is unresponsive."
		return
	if((istype(src.loc, /turf/space)))
		if(!src.Process_Spacemove(0))	return
	if(istype(user.l_hand, /obj/item/key) || istype(user.r_hand, /obj/item/key))
		if(!allowMove)
			return
		allowMove = 0
		step(src, direction)
		update_mob()
		handle_rotation()
		// NEW PULLING CODE
		if (istype(user.pulling, /obj/structure/stool/bed/roller))
			var/obj/structure/stool/bed/roller/M = user.pulling
			if(user.dir == NORTH)
				var/turf/step = get_turf(get_step(user, SOUTH))
				if(step)
					if(!istype(step, /turf/simulated/wall))
						if(step.contents)
							var/obj/machinery/door/T = locate() in step
							if(!T)
								user.pulling.loc = step
								if(M.buckled_mob)
									M.buckled_mob.loc = M.loc
							if(T && T.density != 1)
								user.pulling.loc = step
								if(M.buckled_mob)
									M.buckled_mob.loc = M.loc
			if(user.dir == SOUTH)
				var/turf/step = get_turf(get_step(user, NORTH))
				if(step)
					if(!istype(step, /turf/simulated/wall))
						if(step.contents)
							var/obj/machinery/door/T = locate() in step
							if(!T)
								user.pulling.loc = step
								if(M.buckled_mob)
									M.buckled_mob.loc = M.loc
							if(T && T.density != 1)
								user.pulling.loc = step
								if(M.buckled_mob)
									M.buckled_mob.loc = M.loc
			if(user.dir == EAST)
				var/turf/step = get_turf(get_step(user, WEST))
				if(step)
					if(!istype(step, /turf/simulated/wall))
						if(step.contents)
							var/obj/machinery/door/T = locate() in step
							if(!T)
								user.pulling.loc = step
								if(M.buckled_mob)
									M.buckled_mob.loc = M.loc
							if(T && T.density != 1)
								user.pulling.loc = step
								if(M.buckled_mob)
									M.buckled_mob.loc = M.loc
			if(user.dir == WEST)
				var/turf/step = get_turf(get_step(user, EAST))
				if(step)
					if(!istype(step, /turf/simulated/wall))
						if(step.contents)
							var/obj/machinery/door/T = locate() in step
							if(!T)
								user.pulling.loc = step
								if(M.buckled_mob)
									M.buckled_mob.loc = M.loc
							if(T && T.density != 1)
								user.pulling.loc = step
								if(M.buckled_mob)
									M.buckled_mob.loc = M.loc

		// END NEW PULLING CODE
		sleep(delay)
		allowMove = 1
		/*
		if(istype(src.loc, /turf/space) && (!src.Process_Spacemove(0, user)))
			var/turf/space/S = src.loc
			S.Entered(src)*/
	else
		user << "<span class='notice'>You'll need the keys in one of your hands to drive this ambulance.</span>"






/obj/item/key
	name = "key"
	desc = "A keyring with a small steel key, and a pink fob reading \"Pussy Wagon\"."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "keys"
	w_class = 1


/obj/item/key/ambulance
	name = "ambulance key"
	desc = "A keyring with a small steel key, and tag with a red cross on it."
	icon_state = "keydoc"