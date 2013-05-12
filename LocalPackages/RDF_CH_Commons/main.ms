bind(player_join,null,null,@event,
	assign(@player,player())
	_rdf_daytime(@player)
	if(array_contains(pgroup(), 'Testificate'),
		sudo(sconcat('/pex user', player(), 'group remove Testificate'))
		sudo(sconcat('/pex user', player(), 'group add Default'))
	)
	_rdf_formatname(@player)
)