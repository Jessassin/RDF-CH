#=========================================================================#
#
# RDF Server Admin Chat
# Authored by: Tyler569
#
# Requires: ch.alias.admin, ch.alias.all
# Risk: low/none
#
#=========================================================================#

proc(_adminchat, @message,
	if(lt(length(@message),1),
		_rdf_syntaxerror(get_cmd(),'<message to admin chat>')
	)
	foreach(all_players(), @player,
		if(has_permission(@player, 'ch.alias.admin'),
			tmsg(@player,
				concat(color(4), '[#]', color(b), player(), color(f), ' ', @message)
			)
		)
	)
)