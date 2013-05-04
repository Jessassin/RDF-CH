bind(player_join,null,null,@event,
	assign(@player,player())
	_rdf_daytime(@player)
	_rdf_formatname(@player)
)