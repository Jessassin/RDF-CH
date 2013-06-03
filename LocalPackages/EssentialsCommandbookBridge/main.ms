#=========================================================================#
#
# RDF Server Essentials - CommandBook Bridge
# Authored by: Jessassin + Tyler569
#
# Requires: ch.alias.all
# Risk: low/none
#
#=========================================================================#


bind(player_interact, null, array(block: 63), @event,

	if(nequals(@event['action'], 'right_click_block'),
		die()
	)	
	
	assign(@spot, @event['location'])
	assign(@text, get_sign_text(@spot))
	if(array_contains_ic(reg_match(reg_escape('[Warp]'), @text[0]), '[Warp]'),
		run(concat('/warp ', @text[1]))
		cancel()
	)

)