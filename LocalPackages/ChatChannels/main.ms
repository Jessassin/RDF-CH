#=========================================================================#
#
# RDF Server Chat Channels
# Authored by: Tyler569
#
# Requires: ch.alias.all
# Risk: low/none
#
#=========================================================================#



bind(player_join,null,null,@event,

# Ensures players are not in a channel when they join by kicking them when they join

	_cc_leave(player(), true)
)

bind(player_chat, null, null, @event,

# Procedure manages chat sending - logic is as follows:
# 	IN A CHANNEL:
#		Normal chatting absorbed -  sent to channel
#		/e appends signal, chat then passed to global
#	OUT OF CHANNEL:
#		Normal chatting goes to global as ususal
#		/e signal removed and ignored - chat goed to global

	assign(@len, length(@event['message']))
	try(
		if(equals(substr(@event['message'],0,12), 'Z7F2iS940RQc'),
			modify_event('message', substr(@event['message'], 12))
			assign(@slashe, true)
			, #else
			assign(@slashe, false)
		)
		, #except
		assign(@slashe, false)
	)
	if(and(@slashe, equals(@len, 12)),
		cancel()
		_rdf_syntaxerror('/e', '<message>')
	)
	if(
		and(
			nequals(get_value(concat('cc.player.', player())), 'null'),
			not(@slashe)
		),
		assign(@send, @event['message'])
		_cc_channelChat(player(), @send)
		console(sconcat('CChat -', player(), get_value(concat('cc.player.', player())), @send))
		cancel()
	)
)