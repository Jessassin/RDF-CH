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
	# assign(@values, array('63', '63:1', '63:2', '63:3', '63:4', '63:5', '63:6', '63:7', '63:8', '63:9', '63:10', '63:11', '63:12', '63:13', '63:14', '63:15', '68', '68:1', '68:2', '68:3', '68:5'))
	
	assign(@spot, @event['location'])
	assign(@text, get_sign_text(@spot))
	if(equals_ic(@text[0], '[Warp]'),
		run(concat('/warp ', @text[1]))
		cancel()
	)

)