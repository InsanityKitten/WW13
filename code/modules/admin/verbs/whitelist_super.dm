// todo: merge this with the code in whitelist.dm

/client/proc/add_to_super_whitelist()
	set name = "Add To Super Whitelist"
	set category = "Server"

	if (!check_rights(R_ADMIN))
		src << "<span class = 'danger'>You don't have the permissions.</span>"
		return

	var/_ckey = input("What ckey?") as text
	_ckey = sanitizeSQL(_ckey, max_length = 50)

	if (!_ckey)
		return

	var/datum/whitelist/W = global_whitelists["super"]
	if (!W)
		src << "<span class = 'danger'>Something went wrong. This whitelist doesn't exist.</span>"
		return

	W.add(_ckey)
	save_whitelist("super")

	src << "<span class = 'notice'>Successfully added '[_ckey]' to the 'super' whitelist."
	var/M = "[key_name(src)] added '[_ckey]' to the 'super' whitelist."
	log_admin(M)
	message_admins(M)

/client/proc/remove_from_super_whitelist()
	set name = "Remove From Super Whitelist"
	set category = "Server"

	if (!check_rights(R_ADMIN))
		src << "<span class = 'danger'>You don't have the permissions.</span>"
		return

	var/_ckey = input("What ckey?") as text
	_ckey = sanitizeSQL(_ckey, max_length = 50)

	if (!_ckey)
		return

	var/datum/whitelist/W = global_whitelists["super"]
	if (!W)
		src << "<span class = 'danger'>Something went wrong. This whitelist doesn't exist.</span>"
		return

	if (W.remove(_ckey))
		save_whitelist("super")
		src << "<span class = 'notice'>Successfully removed '[_ckey]' from the 'super' whitelist."
		var/M = "[key_name(src)] REMOVED '[_ckey]' from the 'super' whitelist."
		log_admin(M)
		message_admins(M)
	else
		src << "<span class = 'warning'>FAILED to remove '[_ckey]' from the 'super' whitelist. They weren't in it."

/client/proc/view_super_whitelist()
	set name = "See Super Whitelist"
	set category = "Server"

	if (!check_rights(R_ADMIN))
		src << "<span class = 'danger'>You don't have the permissions.</span>"
		return

	var/datum/whitelist/W = global_whitelists["super"]
	src << W.data