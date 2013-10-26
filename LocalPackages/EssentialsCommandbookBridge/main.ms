#COPYRIGHT (C) Jessassin 2013
#This file is part of the Redstone Development Foundation's CommandHelper Script Library (RDF-CH)
# LICENSED GNU Lesser General Public License (GNU LGPL) version  3
# See LICENSE.txt or visit http://www.gnu.org/licenses/ for more information


#=========================================================================#
#
# RDF Server Essentials - CommandBook Bridge
# Authored by: Jessassin + Tyler569
#
# Requires: none
# Permissions: none
# Risk: low/none
#
#=========================================================================#


bind(player_interact, null, array(block: 63), @event,
	if(nequals(@event['action'], 'right_click_block'),
		die()
	)
	assign(@location, @event['location'])
	assign(@signtext, get_sign_text(@location))
	if(array_contains_ic(reg_match(reg_escape('[Warp]'), @signtext[0]), '[Warp]'),
		run(concat('/warp ', @signtext[1]))
		cancel()
	)
)

bind(player_command, null, null, @event,
	assign(@msgs, array('/msg', '/message', '/whisper', '/pm', '/tell', '/reply', '/r', '/t', '/w'))
	if(not(array_contains_ic(@msgs, @event['prefix'])),
		die()
	)
	assign(@message, concat(color(8), '[SPY]', color(2), '[PM]', color(b), @event['player'], color(f), ' ', @event['command']))
	foreach(all_players(), @admintest,
		if(has_value(concat('socialspy.', @admintest)),
			if(and(equals(get_value(concat('socialspy.', @admintest)), 'true'), nequals(@admintest, @event['player'])),
				tmsg(@admintest, @message)
			)
		)
	)
)