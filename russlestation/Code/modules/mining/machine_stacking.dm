/**********************Mineral stacking unit console**************************/

/obj/machinery/mineral/stacking_unit_console
	name = "stacking machine console"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "console"
	density = 1
	anchored = 1
	var/obj/machinery/mineral/stacking_machine/machine = null
	var/machinedir = SOUTHEAST

/obj/machinery/mineral/stacking_unit_console/New()
	..()
	spawn(7)
		src.machine = locate(/obj/machinery/mineral/stacking_machine, get_step(src, machinedir))
		if (machine)
			machine.CONSOLE = src
		else
			del(src)

/obj/machinery/mineral/stacking_unit_console/process()
	updateDialog()

/obj/machinery/mineral/stacking_unit_console/attack_hand(mob/user)
	add_fingerprint(user)
	interact(user)

/obj/machinery/mineral/stacking_unit_console/interact(mob/user)
	user.set_machine(src)

	var/dat

	dat += text("<b>Stacking unit console</b><br><br>")

	if(machine.ore_iron)
		dat += text("Iron: [machine.ore_iron] <A href='?src=\ref[src];release=iron'>Release</A><br>")
	if(machine.ore_plasteel)
		dat += text("Plasteel: [machine.ore_plasteel] <A href='?src=\ref[src];release=plasteel'>Release</A><br>")
	if(machine.ore_glass)
		dat += text("Glass: [machine.ore_glass] <A href='?src=\ref[src];release=glass'>Release</A><br>")
	if(machine.ore_rglass)
		dat += text("Reinforced Glass: [machine.ore_rglass] <A href='?src=\ref[src];release=rglass'>Release</A><br>")
	if(machine.ore_phoron)
		dat += text("Phoron: [machine.ore_phoron] <A href='?src=\ref[src];release=phoron'>Release</A><br>")
	if(machine.ore_phoronglass)
		dat += text("Phoron Glass: [machine.ore_phoronglass] <A href='?src=\ref[src];release=phoronglass'>Release</A><br>")
	if(machine.ore_phoronrglass)
		dat += text("Reinforced Phoron Glass: [machine.ore_phoronrglass] <A href='?src=\ref[src];release=phoronrglass'>Release</A><br>")
	if(machine.ore_gold)
		dat += text("Gold: [machine.ore_gold] <A href='?src=\ref[src];release=gold'>Release</A><br>")
	if(machine.ore_silver)
		dat += text("Silver: [machine.ore_silver] <A href='?src=\ref[src];release=silver'>Release</A><br>")
	if(machine.ore_uranium)
		dat += text("Uranium: [machine.ore_uranium] <A href='?src=\ref[src];release=uranium'>Release</A><br>")
	if(machine.ore_diamond)
		dat += text("Diamond: [machine.ore_diamond] <A href='?src=\ref[src];release=diamond'>Release</A><br>")
	if(machine.ore_wood)
		dat += text("Wood: [machine.ore_wood] <A href='?src=\ref[src];release=wood'>Release</A><br>")
	if(machine.ore_cardboard)
		dat += text("Cardboard: [machine.ore_cardboard] <A href='?src=\ref[src];release=cardboard'>Release</A><br>")
	if(machine.ore_cloth)
		dat += text("Cloth: [machine.ore_cloth] <A href='?src=\ref[src];release=cloth'>Release</A><br>")
	if(machine.ore_leather)
		dat += text("Leather: [machine.ore_leather] <A href='?src=\ref[src];release=leather'>Release</A><br>")
	if(machine.ore_fur)
		dat += text("Fur: [machine.ore_fur] <A href='?src=\ref[src];release=fur'>Release</A><br>")
	if(machine.ore_clown)
		dat += text("Bananium: [machine.ore_clown] <A href='?src=\ref[src];release=clown'>Release</A><br>")
	if(machine.ore_adamantine)
		dat += text ("Adamantine: [machine.ore_adamantine] <A href='?src=\ref[src];release=adamantine'>Release</A><br>")
	if(machine.ore_mythril)
		dat += text ("Mythril: [machine.ore_mythril] <A href='?src=\ref[src];release=adamantine'>Release</A><br>")

	dat += text("<br>Stacking: [machine.stack_amt]<br><br>")

	user << browse("[dat]", "window=console_stacking_machine")
	onclose(user, "console_stacking_machine")

/obj/machinery/mineral/stacking_unit_console/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	src.add_fingerprint(usr)
	if(href_list["release"])
		switch(href_list["release"])
			if ("phoron")
				if (machine.ore_phoron > 0)
					var/obj/item/stack/sheet/mineral/phoron/G = new /obj/item/stack/sheet/mineral/phoron
					G.amount = machine.ore_phoron
					G.loc = machine.output.loc
					machine.ore_phoron = 0
			if ("phoronglass")
				if (machine.ore_phoronglass > 0)
					var/obj/item/stack/sheet/glass/phoronglass/G = new /obj/item/stack/sheet/glass/phoronglass
					G.amount = machine.ore_phoronglass
					G.loc = machine.output.loc
					machine.ore_phoronglass = 0
			if ("phoronrglass")
				if (machine.ore_phoronrglass > 0)
					var/obj/item/stack/sheet/glass/phoronrglass/G = new /obj/item/stack/sheet/glass/phoronrglass
					G.amount = machine.ore_phoronrglass
					G.loc = machine.output.loc
					machine.ore_phoronrglass = 0
			if ("uranium")
				if (machine.ore_uranium > 0)
					var/obj/item/stack/sheet/mineral/uranium/G = new /obj/item/stack/sheet/mineral/uranium
					G.amount = machine.ore_uranium
					G.loc = machine.output.loc
					machine.ore_uranium = 0
			if ("glass")
				if (machine.ore_glass > 0)
					var/obj/item/stack/sheet/glass/G = new /obj/item/stack/sheet/glass
					G.amount = machine.ore_glass
					G.loc = machine.output.loc
					machine.ore_glass = 0
			if ("rglass")
				if (machine.ore_rglass > 0)
					var/obj/item/stack/sheet/rglass/G = new /obj/item/stack/sheet/rglass
					G.amount = machine.ore_rglass
					G.loc = machine.output.loc
					machine.ore_rglass = 0
			if ("gold")
				if (machine.ore_gold > 0)
					var/obj/item/stack/sheet/mineral/gold/G = new /obj/item/stack/sheet/mineral/gold
					G.amount = machine.ore_gold
					G.loc = machine.output.loc
					machine.ore_gold = 0
			if ("silver")
				if (machine.ore_silver > 0)
					var/obj/item/stack/sheet/mineral/silver/G = new /obj/item/stack/sheet/mineral/silver
					G.amount = machine.ore_silver
					G.loc = machine.output.loc
					machine.ore_silver = 0
			if ("diamond")
				if (machine.ore_diamond > 0)
					var/obj/item/stack/sheet/mineral/diamond/G = new /obj/item/stack/sheet/mineral/diamond
					G.amount = machine.ore_diamond
					G.loc = machine.output.loc
					machine.ore_diamond = 0
			if ("iron")
				if (machine.ore_iron > 0)
					var/obj/item/stack/sheet/metal/G = new /obj/item/stack/sheet/metal
					G.amount = machine.ore_iron
					G.loc = machine.output.loc
					machine.ore_iron = 0
			if ("plasteel")
				if (machine.ore_plasteel > 0)
					var/obj/item/stack/sheet/plasteel/G = new /obj/item/stack/sheet/plasteel
					G.amount = machine.ore_plasteel
					G.loc = machine.output.loc
					machine.ore_plasteel = 0
			if ("wood")
				if (machine.ore_wood > 0)
					var/obj/item/stack/sheet/wood/G = new /obj/item/stack/sheet/wood
					G.amount = machine.ore_wood
					G.loc = machine.output.loc
					machine.ore_wood = 0
			if ("cardboard")
				if (machine.ore_cardboard > 0)
					var/obj/item/stack/sheet/cardboard/G = new /obj/item/stack/sheet/cardboard
					G.amount = machine.ore_cardboard
					G.loc = machine.output.loc
					machine.ore_cardboard = 0
			if ("cloth")
				if (machine.ore_cloth > 0)
					var/obj/item/stack/sheet/cloth/G = new /obj/item/stack/sheet/cloth
					G.amount = machine.ore_cloth
					G.loc = machine.output.loc
					machine.ore_cloth = 0
			if ("leather")
				if (machine.ore_leather > 0)
					var/obj/item/stack/sheet/leather/G = new /obj/item/stack/sheet/leather
					G.amount = machine.ore_diamond
					G.loc = machine.output.loc
					machine.ore_leather = 0
			if ("fur")
				if (machine.ore_fur > 0)
					var/obj/item/stack/sheet/fur/SA/G = new /obj/item/stack/sheet/fur/SA
					G.amount = machine.ore_fur
					G.loc = machine.output.loc
					machine.ore_fur = 0
			if ("clown")
				if (machine.ore_clown > 0)
					var/obj/item/stack/sheet/mineral/clown/G = new /obj/item/stack/sheet/mineral/clown
					G.amount = machine.ore_clown
					G.loc = machine.output.loc
					machine.ore_clown = 0
			if ("adamantine")
				if (machine.ore_adamantine > 0)
					var/obj/item/stack/sheet/mineral/adamantine/G = new /obj/item/stack/sheet/mineral/adamantine
					G.amount = machine.ore_adamantine
					G.loc = machine.output.loc
					machine.ore_adamantine = 0
			if ("mythril")
				if (machine.ore_mythril > 0)
					var/obj/item/stack/sheet/mineral/mythril/G = new /obj/item/stack/sheet/mineral/mythril
					G.amount = machine.ore_mythril
					G.loc = machine.output.loc
					machine.ore_mythril = 0
	src.updateUsrDialog()
	return


/**********************Mineral stacking unit**************************/


/obj/machinery/mineral/stacking_machine
	name = "stacking machine"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "stacker"
	density = 1
	anchored = 1.0
	var/obj/machinery/mineral/stacking_unit_console/CONSOLE
	var/stk_types = list()
	var/stk_amt   = list()
	var/obj/machinery/mineral/input = null
	var/obj/machinery/mineral/output = null
	var/ore_gold = 0;
	var/ore_silver = 0;
	var/ore_diamond = 0;
	var/ore_phoron = 0;
	var/ore_phoronglass = 0;
	var/ore_phoronrglass = 0;
	var/ore_iron = 0;
	var/ore_uranium = 0;
	var/ore_clown = 0;
	var/ore_glass = 0;
	var/ore_rglass = 0;
	var/ore_plasteel = 0;
	var/ore_wood = 0
	var/ore_cardboard = 0
	var/ore_cloth = 0;
	var/ore_leather = 0;
	var/ore_adamantine = 0;
	var/ore_mythril = 0;
	var/ore_fur = 0;
	var/stack_amt = 50; //ammount to stack before releassing

/obj/machinery/mineral/stacking_machine/New()
	..()
	spawn( 5 )
		for (var/dir in cardinal)
			src.input = locate(/obj/machinery/mineral/input, get_step(src, dir))
			if(src.input) break
		for (var/dir in cardinal)
			src.output = locate(/obj/machinery/mineral/output, get_step(src, dir))
			if(src.output) break
		processing_objects.Add(src)
		return
	return

/obj/machinery/mineral/stacking_machine/process()
	if (src.output && src.input)
		var/obj/item/stack/O
		if(locate(/mob,input.loc))
			var/mob/M = locate(/mob,input.loc)
			M.loc = output.loc
		while (locate(/obj/item, input.loc))
			O = locate(/obj/item/stack, input.loc)
			if(isnull(O))
				var/obj/item/I = locate(/obj/item, input.loc)
				if (istype(I,/obj/item/weapon/ore/slag))
					I.loc = null
				else
					I.loc = output.loc
				continue
			if (istype(O,/obj/item/stack/sheet/metal))
				ore_iron+= O.amount
				O.loc = null
				//del(O)
				continue
			if (istype(O,/obj/item/stack/sheet/fur))
				ore_fur += O.amount
				O.loc = null
				//del(O)
				continue
			if (istype(O,/obj/item/stack/sheet/mineral/diamond))
				ore_diamond+= O.amount
				O.loc = null
				//del(O)
				continue
			if (istype(O,/obj/item/stack/sheet/mineral/phoron))
				ore_phoron+= O.amount
				O.loc = null
				//del(O)
				continue
			if (istype(O,/obj/item/stack/sheet/mineral/gold))
				ore_gold+= O.amount
				O.loc = null
				//del(O)
				continue
			if (istype(O,/obj/item/stack/sheet/mineral/silver))
				ore_silver+= O.amount
				O.loc = null
				//del(O)
				continue
			if (istype(O,/obj/item/stack/sheet/mineral/clown))
				ore_clown+= O.amount
				O.loc = null
				//del(O)
				continue
			if (istype(O,/obj/item/stack/sheet/mineral/uranium))
				ore_uranium+= O.amount
				O.loc = null
				//del(O)
				continue
			if (istype(O,/obj/item/stack/sheet/glass/phoronglass))
				ore_phoronglass+= O.amount
				O.loc = null
				//del(O)
				continue
			if (istype(O,/obj/item/stack/sheet/glass/phoronrglass))
				ore_phoronrglass+= O.amount
				O.loc = null
				//del(O)
				continue
			if (istype(O,/obj/item/stack/sheet/glass))
				ore_glass+= O.amount
				O.loc = null
				//del(O)
				continue
			if (istype(O,/obj/item/stack/sheet/rglass))
				ore_rglass+= O.amount
				O.loc = null
				//del(O)
				continue
			if (istype(O,/obj/item/stack/sheet/plasteel))
				ore_plasteel+= O.amount
				O.loc = null
				//del(O)
				continue
			if (istype(O,/obj/item/stack/sheet/mineral/adamantine))
				ore_adamantine+= O.amount
				O.loc = null
				//del(O)
				continue
			if (istype(O,/obj/item/stack/sheet/mineral/mythril))
				ore_mythril+= O.amount
				O.loc = null
				//del(O)
				continue
			if (istype(O,/obj/item/stack/sheet/cardboard))
				ore_cardboard+= O.amount
				O.loc = null
				//del(O)
				continue
			if (istype(O,/obj/item/stack/sheet/wood))
				ore_wood+= O.amount
				O.loc = null
				//del(O)
				continue
			if (istype(O,/obj/item/stack/sheet/cloth))
				ore_cloth+= O.amount
				O.loc = null
				//del(O)
				continue
			if (istype(O,/obj/item/stack/sheet/leather))
				ore_leather+= O.amount
				O.loc = null
				//del(O)
				continue
			O.loc = src.output.loc

	if (ore_gold >= stack_amt)
		var/obj/item/stack/sheet/mineral/gold/G = new /obj/item/stack/sheet/mineral/gold
		G.amount = stack_amt
		G.loc = output.loc
		ore_gold -= stack_amt
		return
	if (ore_fur >= stack_amt)
		var/obj/item/stack/sheet/fur/SA/G = new /obj/item/stack/sheet/fur/SA
		G.amount = stack_amt
		G.loc = output.loc
		ore_fur -= stack_amt
		return
	if (ore_silver >= stack_amt)
		var/obj/item/stack/sheet/mineral/silver/G = new /obj/item/stack/sheet/mineral/silver
		G.amount = stack_amt
		G.loc = output.loc
		ore_silver -= stack_amt
		return
	if (ore_diamond >= stack_amt)
		var/obj/item/stack/sheet/mineral/diamond/G = new /obj/item/stack/sheet/mineral/diamond
		G.amount = stack_amt
		G.loc = output.loc
		ore_diamond -= stack_amt
		return
	if (ore_phoron >= stack_amt)
		var/obj/item/stack/sheet/mineral/phoron/G = new /obj/item/stack/sheet/mineral/phoron
		G.amount = stack_amt
		G.loc = output.loc
		ore_phoron -= stack_amt
		return
	if (ore_iron >= stack_amt)
		var/obj/item/stack/sheet/metal/G = new /obj/item/stack/sheet/metal
		G.amount = stack_amt
		G.loc = output.loc
		ore_iron -= stack_amt
		return
	if (ore_clown >= stack_amt)
		var/obj/item/stack/sheet/mineral/clown/G = new /obj/item/stack/sheet/mineral/clown
		G.amount = stack_amt
		G.loc = output.loc
		ore_clown -= stack_amt
		return
	if (ore_uranium >= stack_amt)
		var/obj/item/stack/sheet/mineral/uranium/G = new /obj/item/stack/sheet/mineral/uranium
		G.amount = stack_amt
		G.loc = output.loc
		ore_uranium -= stack_amt
		return
	if (ore_glass >= stack_amt)
		var/obj/item/stack/sheet/glass/G = new /obj/item/stack/sheet/glass
		G.amount = stack_amt
		G.loc = output.loc
		ore_glass -= stack_amt
		return
	if (ore_rglass >= stack_amt)
		var/obj/item/stack/sheet/rglass/G = new /obj/item/stack/sheet/rglass
		G.amount = stack_amt
		G.loc = output.loc
		ore_rglass -= stack_amt
		return
	if (ore_phoronglass >= stack_amt)
		var/obj/item/stack/sheet/glass/phoronglass/G = new /obj/item/stack/sheet/glass/phoronglass
		G.amount = stack_amt
		G.loc = output.loc
		ore_phoronglass -= stack_amt
		return
	if (ore_phoronrglass >= stack_amt)
		var/obj/item/stack/sheet/glass/phoronrglass/G = new /obj/item/stack/sheet/glass/phoronrglass
		G.amount = stack_amt
		G.loc = output.loc
		ore_phoronrglass -= stack_amt
		return
	if (ore_plasteel >= stack_amt)
		var/obj/item/stack/sheet/plasteel/G = new /obj/item/stack/sheet/plasteel
		G.amount = stack_amt
		G.loc = output.loc
		ore_plasteel -= stack_amt
		return
	if (ore_wood >= stack_amt)
		var/obj/item/stack/sheet/wood/G = new /obj/item/stack/sheet/wood
		G.amount = stack_amt
		G.loc = output.loc
		ore_wood -= stack_amt
		return
	if (ore_cardboard >= stack_amt)
		var/obj/item/stack/sheet/cardboard/G = new /obj/item/stack/sheet/cardboard
		G.amount = stack_amt
		G.loc = output.loc
		ore_cardboard -= stack_amt
		return
	if (ore_cloth >= stack_amt)
		var/obj/item/stack/sheet/cloth/G = new /obj/item/stack/sheet/cloth
		G.amount = stack_amt
		G.loc = output.loc
		ore_cloth -= stack_amt
		return
	if (ore_leather >= stack_amt)
		var/obj/item/stack/sheet/leather/G = new /obj/item/stack/sheet/leather
		G.amount = stack_amt
		G.loc = output.loc
		ore_leather -= stack_amt
		return
	if (ore_adamantine >= stack_amt)
		var/obj/item/stack/sheet/mineral/adamantine/G = new /obj/item/stack/sheet/mineral/adamantine
		G.amount = stack_amt
		G.loc = output.loc
		ore_adamantine -= stack_amt
		return
	if (ore_mythril >= stack_amt)
		var/obj/item/stack/sheet/mineral/mythril/G = new /obj/item/stack/sheet/mineral/mythril
		G.amount = stack_amt
		G.loc = output.loc
		ore_mythril -= stack_amt
		return
	return