#=========================================================================#
#
# RDF Server Chat Channels
# Authored by: Tyler569
#
# Requires: ch.alias.all
# Risk: low/none
#
#=========================================================================#

# Future TODO: integrate AdminChat with this channel system
#	 Would need ability to be in multiple channels at once and use diff commands


# Persistance key:
#    cc.channel.<channel> - list of players in a certain channel
#    cc.player.<player>   - channel a player is currently in
#    cc.ccspy.<player>    - true if player has ccspy enabled
#    cc.channel_list      - list of all active channels


proc(_cc_join, @player, @channel,

# Procedure called to have player join a channel

	if(not(reg_match(concat('^\\w+$'), @channel)),
		die(concat(color(c), 'Channel names can only contain letters and numbers'))
	)
	
	assign(@channelBefore, get_value(concat('cc.channel.', @channel)))
	
	if(not(get_value(concat('cc.player.',@player))),
		_cc_onlinetest(@channel)
		
		tmsg(@player, concat(color(7), 'Welcome to the channel ', color(9), @channel))
		if(is_array(@channelBefore),
			tmsg(@player, 'Players currently here:')
			tmsg(@player, concat(color(a),array_implode(@channelBefore, ', ')))
			array_push(@channelBefore, @player)
			, #else
			tmsg(@player, 'No one is here right now')
			assign(@channelBefore,array(@player))
		)
		assign(@channelAfter, @channelBefore)
		store_value(concat('cc.channel.', @channel), @channelAfter)
		store_value(concat('cc.player.', @player), @channel)
		_cc_jl_broadcast(@player, @channel, 'joined')
		
		assign(@allchs, get_value('cc.channel_list'))
		if(equals(@allchs, 'null'),
			assign(@allchs, array())
		)
		if(not(array_contains_ic(@allchs, @channel)),
			if(is_array(@allchs),
				array_push(@allchs, @channel)
				, #else
				assign(@allchs, array(@channel))
			)
			assign(@allchsn, @allchs)
			store_value('cc.channel_list', @allchsn)
		)
		
		, #else
		die(concat(color(4),'You need to leave your channel before you join another'))
	)	
)

proc(_cc_leave, @player, @silent,

# Procedure called to have player leave a channel
# Note: if @silent is set to true - player recieves no notification that they left

	assign(@channel, get_value(concat('cc.player.', @player)))
	if(equals(@channel, null),
		if(@silent,
			return()
			, #else
			msg(concat(color(8), 'You are not in a channel'))
			return()
		)
	)
	assign(@channelBefore, get_value(concat('cc.channel.', @channel)))
	if(equals(@channelBefore, 'null'),
		assign(@channelBefore,array(@player))
	)
	array_remove_values(@channelBefore, @player)
	assign(@channelAfter, @channelBefore)
	store_value(concat('cc.channel.', @channel), @channelAfter)
	clear_value(concat('cc.player.',@player))
	if(not(@silent),
		msg(concat(color(7), 'You have left the channel'))
		_cc_jl_broadcast(@player, @channel, 'left')
	)
	_cc_onlinetest(@channel)
)

proc(_cc_onlinetest, @channel,

# Removes any offline players from channel passed as arg

	assign(@players, get_value(concat('cc.channel.', @channel)))
	if(not(@players), 
		clear_value(concat('cc.channel.', @channel))
		assign(@allchs, get_value('cc.channel_list'))
		if(equals(@allchs, 'null'),
			assign(@allchs, array())
		)
		array_remove_values(@allchs, @channel)
		store_value('cc.channel_list', @allchs)
		return()
	)	
	assign(@all_players, all_players())
	foreach(@players, @player,
		if(not(array_contains_ic(@all_players, @player)),
			array_remove_values(@players, @player)
		)
	)

	store_value(concat('cc.channel.', @channel), @players)
)

proc(_cc_channelChat, @player, @chat,

# Procedure called to pass chat on to users in channel
	
	if(lt(length(@chat),1),
		_rdf_syntaxerror(get_cmd(), '<message to channel chat>')
	)
	
	assign(@channel, get_value(concat('cc.player.', @player)))
	
	if(equals(@channel, 'null'),
		msg(concat(color(c), 'You are not in a channel,'))
		die(concat(color(c), '/cc join <channel> to join one'))
	)
	
	assign(@namecolor, get_value(concat(to_lower(player()),'_namecolor')))
	assign(@nameformat, get_value(concat(to_lower(player()),'_nameformat')))
	if(or(equals(@nameformat, 'null'), equals(@namecolor, 'null')),
		assign(@nameformat, color('p'))
		assign(@namecolor, 'b')
	)
	assign(@nf, concat(color(@namecolor), @nameformat))
	
	assign(@plrsto, get_value(concat('cc.channel.', @channel)))
	foreach(all_players(), @plr,
		if(array_contains_ic(@plrsto, @plr),
			tmsg(@plr, concat(color(9),'[',@channel,']',@nf ,@player,' ',color(f),@chat))
			, #else
			if(get_value(concat('cc.ccspy.',@plr)),
				_checkpermission('admin', @plr)
				tmsg(@plr, concat(color(8),'[SPY]',color(9),'[',@channel,']',@nf ,@player,' ',color(f),@chat))
			)
		)
	)
)

proc(_cc_jl_broadcast, @player, @channel, @jl,

# Broadcast to users in a channel when a player joins or leaves

	foreach(get_value(concat('cc.channel.', @channel)), @channelplr,
		tmsg(@channelplr, concat(color(9),'[',@channel,']',color(f),': ',color(a), @player, color(7), ' has ', @jl, ' the channel'))
	)
)

proc(_cc_plr_view, @player,

# Procedure called by /cc view

	assign(@channel, get_value(concat('cc.player.', @player)))
	if(equals(@channel, 'null'),
		die(concat(color(8), 'You are not in a channel'))
	)
	assign(@players, get_value(concat('cc.channel.',@channel)))
	msg(concat(color(7), 'You are in the channel ', color(9), @channel))
	msg(concat(color(7), 'Players currently here:\n', color(a), array_implode(@players, ', ')))
)

proc(_cc_info,

# General package information, called by /cc info

	msg(concat(color(4),'============================================='))
	msg(concat(color(9),'   Welcome to the RDF Server Chat Channel System'))
	msg(concat(color(6),'      To join a channel, type /cc join <name>   '))
	msg(concat(color(6),'        To leave a channel, type /cc leave      '))
	msg(concat(color(6),'        To chat in global use /e <message>     '))
	msg(concat(color(8),'     You are not able to leave the server chat  '))
	msg(concat(color(c),'Channel chat rules are the same as public chat rules'))
	msg(concat(color(4),'============================================='))
)

proc(_cc_icrepl, @player,

# Given a string this finds if any player with that name is in the server ignoring case
# Returns the player if found, otherwise returns the original string

	foreach(all_players(), @plr,
		if(equals_ic(@plr, @player),
			assign(@player, @plr)
		)
	)
	return(@player)
)

##### ADMIN PROCS #####

proc(_cc_admin_showall,

# Procedure called by /ccadmin view to show list of channels

	assign(@chs, get_value('cc.channel_list'))
	if(gt(length(@chs),0),
		msg(concat(color(7), 'Here are all of the open channels:\n', color(9), array_implode(@chs, ', ')))
		, #else
		msg('No channels open at this time')
	)
)
	
proc(_cc_admin_close, @channel,

# Procedure called by /ccadmin close to close channel

	if(not(array_contains_ic(get_value('cc.channel_list'), @channel)),
		die(concat(color(7), 'Channel does not exist'))
	)
	assign(@players, get_value(concat('cc.channel.',@channel)))
	if(is_array(@players),
		foreach(@players, @player,
			_cc_leave(@player, true)
			try(
				tmsg(@player, concat(color(4), 'Your channel was closed by admin'))
			)
		)
		, #else
		_cc_onlinetest(@channel)
	)
	if(not(array_contains_ic(get_value('cc.channel_list'), @channel)),
		msg(concat(color(7), 'Channel closed'))
		, #else
		msg(concat(color(c), 'Operation failed for unknown reason'))
	)
)

proc(_cc_admin_viewplrs, @channel,

# Procedure called by /ccadmin view [channel] to show players in channel

	if(not(array_contains_ic(get_value('cc.channel_list'), @channel)),
		die(concat(color(7), 'Channel does not exist'))
	)
	assign(@players, get_value(concat('cc.channel.',@channel)))
	msg(concat(color(7), 'Players in that channel:\n', color(a), array_implode(@players, ', ')))
)

proc(_cc_admin_find, @player,

# Procedure called by /ccadmin find to find player

	assign(@channels, get_value('cc.channel_list'))
	foreach(@channels, @channel,
		assign(@players, get_value(concat('cc.channel.', @channel)))
		if(array_contains_ic(@players, @player),
			return(@channel)
		)
	)
	return(null)
)

proc(_cc_admin_pull, @player,

# Procedure called by /ccadmin pull to pull player

	assign(@channel, get_value(concat('cc.player.', player())))
	_cc_leave(@player, true)
	tmsg(@player, concat(color(4), 'You were pulled from your channel by admin'))
	_cc_join(@player, @channel)
)