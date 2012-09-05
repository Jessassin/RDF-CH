#=========================================================================#
#
# RDF Server CommandHelper Commons
# Authored by: Jessassin
# 
# Requires: permission - ch.admin (only for command)
# Risk: low/none
#
#=========================================================================#

proc(_rdf_checkcommonsversion,@requiredversion,
	assign(@commonsversion,abs(1.0))
	if(equals_ic(@requiredversion,'return'),
		return(@commonsversion)
	)
#	if(gte(@commonsversion,@requiredversion),
#		# return(0)

#	)
	if(lt(@commonsversion,@requiredversion),
#		# return(1)
		_rdf_commonsoutofdate(@requiredversion,@commonsversion)
	)
)

proc(_rdf_commonsoutofdate,@requiredversion,@commonsversion,
	msg(color(4),'====================')
	msg(color(c),'commons out of date!')
	msg('Current version: ',color(6),@commonsversion)
	msg('Required version: ',color(2),@requiredversion)
	die(color(4),'====================')
)
proc(_rdf_syntaxerror,@command,@syntax,
	msg('Improper syntax!')
	die(concat('Proper syntax: ',@command,' ',@syntax))
)

proc(_rdf_syntaxmessage,@command,@syntax,
	die(concat('Syntax: ',@command,' ',@syntax))
)

proc(_rdf_helpmessage,
	assign(@command,'This command has no help entry'),
	assign(@syntax,'This command has no syntax entry'),
	assign(@helpmessage,'This command has no help message'),
		msg(concat(color(4),'Help message for command: ',@command))
		msg(concat(color(6),'Syntax: ',color(2),@syntax))
		if(equals_ic(@helpmessage,'null'),
		die('There is no help text for this command'),
		die(@helpmessage))
)