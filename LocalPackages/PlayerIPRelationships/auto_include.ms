#=========================================================================#
#
# RDF Server IP Relationships
# Authored by: Jessassin
# Contributors: None
#
# Requires: ch.alias.admin
# Risk: Personal info disclosed to above with permission
#
#=========================================================================#

proc(_rdf_get_related_players,@player,
	assign(@user,to_lower(@player))
	assign(@latestip,_rdf_get_latest_ip(@user))
	assign(@known_ips,_rdf_get_known_ips(@user))
	assign(@users_at_last_ip,_rdf_get_known_players(@latestip))
	assign(@temparray,array())
	if(not(is_array(@users_at_all_ips)),
		assign(@users_at_all_ips,array(@users_at_all_ips))
	)
	foreach(@known_ips,@ip,
		assign(@temparray,_rdf_get_known_players(@ip))
			if(not(is_array(@temparray)),
				assign(@temparray,array(@temparray))
			)
		assign(@users_at_all_ips,array_merge(@users_at_all_ips,@temparray))
	)
	array_remove_values(@users_at_all_ips,'null')
	array_remove_values(@users_at_all_ips,'')
	array_remove_values(@users_at_all_ips,@user)
	array_remove_values(@users_at_last_ip,@user)
	console(concat('Known users at current IP: ',@users_at_last_ip))
	console(concat('Known users at all other IPs: ',@users_at_all_ips))
	return(array(@users_at_last_ip,@users_at_all_ips))
)

proc(_rdf_store_latest_player,@ip,@player,
	assign(@user,to_lower(@player))
	assign(@ip,replace(@ip,'.','_'))
	assign(@persist_latest,concat(@ip,'_player_latest'))
	store_value(@persist_latest,@user)
	console(concat('Stored: ',@user,' to: ',@persist_latest))
)

proc(_rdf_store_known_players,@ip,@player,
	assign(@user,to_lower(@player))
	assign(@ip,replace(@ip,'.','_'))
	assign(@persist_known,concat(@ip,'_player_known'))
	assign(@previous,get_value(@persist_known))
	if(not(is_array(@previous)),
		assign(@previous,array(@user))
	)
	if(not(array_contains_ic(@previous,@user)),
		array_push(@previous,@user)
		assign(@next,@previous),
		assign(@next,@previous)
	)
	store_value(@persist_known,@next)
	console(concat('Stored: ',@next,' to: ',@persist_known))
)

proc(_rdf_store_latest_ip,@player,
	assign(@player,to_lower(@player))
	assign(@persist_latest,concat(@player,'_ip_latest'))
	assign(@userip,pinfo(@player,3))
	store_value(@persist_latest,@userip)
	console(concat('Stored: ',@userip,' to: ',@persist_latest))
)

proc(_rdf_store_known_ip,@player,
	assign(@user,to_lower(@player))
	assign(@persist_known,concat(@user,'_ip_known'))
	assign(@userip,pinfo(@user,3))
	assign(@previous,get_value(@persist_known))
	if(not(is_array(@previous)),
		assign(@previous,array(@userip))
	)
	assign(@length,length(@previous))
	if(not(array_contains_ic(@previous,@userip)),
		array_push(@previous,@userip)
		assign(@next,@previous),
		assign(@next,@previous)
	)
	store_value(@persist_known,@next)
)

proc(_rdf_get_latest_player,@ip,
	assign(@ip,replace(@ip,'.','_'))
	assign(@persist_latest,concat(@ip,'_player_latest'))
	assign(@ipuser,get_value(@persist_latest))
	console(concat('Latest IP user: ',@ipuser))
	return(@ipuser)
)

proc(_rdf_get_known_players,@ip,
	assign(@ip,replace(@ip,'.','_'))
	assign(@persist_known,concat(@ip,'_player_known'))
	assign(@ipusers,get_value(@persist_known))
	console(concat('Known IP users: ',@ipusers))
	return(@ipusers)
)

proc(_rdf_get_latest_ip,@player,
	assign(@user,to_lower(@player))
	assign(@persist_latest,concat(@user,'_ip_latest'))
	assign(@userip,get_value(@persist_latest))
	console(concat('User latest IP: ',@userip))
	return(@userip)
)

proc(_rdf_get_known_ips,@player,
	assign(@user,to_lower(@player))
	assign(@persist_known,concat(@user,'_ip_known'))
	assign(@knownips,get_value(@persist_known))
	console(concat('Known user IPs: ',@knownips))
	return(@knownips)
)