bind(player_join,null,null,@event,
	assign(@player,player())
	_rdf_daytime(@player)
	_rdf_formatname(@player)
)
bind(player_chat,null,null,@event,
	modify_event('format','%1$s: %2$s')
)