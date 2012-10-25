#=========================================================================#
#
# RDF Server Inventory Management System & Admin Chat
# Authored by: Redstonewarrior
# Contributors: Jessassin
#
# Requires: ch.alias.admin
# Risk: low/none
#
#=========================================================================#
proc(_adminchat,@sender,@message,
	foreach(all_players(),@person,
		if(
			array_contains(pgroup(@person),'Admin')	|| 
			array_contains(pgroup(@person),'ServerAdmin'),
				tmsg(@person,concat(color(4),'[#]', color(b), player(), ': ', color(f), @message))
		)
	)
)

proc(_acmessage,
	return(concat(color(4),'[Admin Chat] ',color(6),'Use /ac <msg> or /# <msg> to talk with other admins.'))
)