#COPYRIGHT (C) Jessassin 2013
#This file is part of the Redstone Development Foundation's CommandHelper Script Library (RDF-CH)
# LICENSED GNU Lesser General Public License (GNU LGPL) version  3
# See LICENSE.txt or visit http://www.gnu.org/licenses/ for more information


#=========================================================================#
#
# RDF Server Name System
# Authored by: Jessassin
# 
# Requires: stuff?
# Risk: low/none
#
#=========================================================================#

include('includes/options.ms')

proc(_rdf_namestyle,@user,@format,
	assign(@formats, array(l,m,n,o,r))
	assign(@groups, pgroup(@user))
#	assign(@formatsdisplay, concat(color(2), color(l), 'L', color(f), ':Bold', '\n', color(2), ' §mM', color(f), ':§mStrike', '\n', color(2), ' §nN', color(f), ': §nUnderline' '\n', color(2), ' §oO', color(f), ':§oItalic ', '\n', color(2), '§r§2r', color(f), ':§pNormal'))
	assign(@formatdisplay,
		array(
			concat('L: ',color(2),color(L),'Bold'),
			concat('M: ',color(2),color(M),'Strike'),
			concat('N: ',color(2),color(N),'Underline'),
			concat('O: ',color(2),color(O),'Italic'),
			concat('R: ',color(2),color(p),'Normal')
		)
	)
	if(
		not(
			or(
				array_contains_ic(@groups,donatorhigh), 
				array_contains_ic(@groups,sponsorlow), 
				array_contains_ic(@groups,sponsormid), 
				array_contains_ic(@groups,sponsorhigh)
			)
		), #then
		msg('This command is only avaliable to high level donators')
		msg('As a high level donator, you would have access to the following name formats')
		foreach(@formatdisplay,@format,
			msg(@format)
		)
		die()
	)
	if(array_contains_ic(@formats, @format), 
		assign(@run,color(@format))
	, #else 
		msg('That is not a valid format')
		die('Do "/nameformat style" for a list of valid formats')
	)
	assign(@player,@user)
	assign(@user,to_lower(@user))
	store_value(concat(@user,'_nameformat'),concat(@run))
	msg(concat(get_value(concat(@user,'_nameformat')), 'Name display format changed!'))
	_rdf_formatname(@player)
)

proc(_rdf_prefixsize,@user,@length,
	assign(@player,@user)
	assign(@user,to_lower(@user))
	if(not(or(equals_ic(@length,'short'),equals_ic(@length,'long'))),
		die('Please enter "short" or "long"')
	)
	store_value(concat(@user,'_ranklength'),@length)
	msg(concat('Your prefix will now appear: ',color(2),@length))
	_rdf_formatname(@player)
)

proc(_rdf_suffixsize,@user,@length,
	assign(@player,@user)
	assign(@user,to_lower(@user))
	assign(@tags,_rdf_gettags(@user))
	if(lt(length(@tags),2),
		die('You must have at least 2 tags!')
	)
	if(not(or(equals_ic(@length,'short'),equals_ic(@length,'long'))),
		die('Please enter "short" or "long"')
	)
	store_value(concat(@user,'_taglength'),@length)
	msg(concat('Your suffix will now appear: ',color(2),@length))
	_rdf_formatname(@player)
)

proc(_rdf_namecolor,@user,@color,
	assign(@groups,pgroup(@user))
	assign(@dlowcolors,array(2,b,f,7,8,e,d,9,a,3))
	assign(@dhighcolors,array(1,5,6))
	# if(
		# not(
			# or(
				# array_contains_ic(@dlowcolors,@color),
				# array_contains_ic(@dhighcolors,@color)
			# )),
		# die(concat(@color is not allowed))
	# )
	# if(equals_ic(@color,'k'),
		# die('K is not allowed')
	# )
	foreach(@dlowcolors,@index,
		assign(@formatteddlcolors,concat(@formatteddlcolors,color(@index),@index,color(f),', '))
	)
	foreach(@dhighcolors,@index,
		assign(@formatteddhcolors,concat(@formatteddhcolors,color(@index),@index,color(f),', '))
	)
	if(
		or(
			lt(length(@color),1),
			equals_ic(@color,'?')
		),
		msg('The following colors are allowed:')
		msg(concat('for',color(2),' green ',color(f), 'level donators: ',@formatteddlcolors))
		die(concat('for',color(6),' gold ',color(f), 'level donators: ',@formatteddhcolors))
	)
	if(
		not(
			or(
				array_contains_ic(@groups,'donatorlow'),
				array_contains_ic(@groups,'donatorhigh'),
				array_contains_ic(@groups,'sponsorlow'),
				array_contains_ic(@groups,'sponsormid'),
				array_contains_ic(@groups,'sponsorhigh')
			)
		),
		msg('You need to be a donator to use the name color option')
		msg('as a donator, you would have the following color options:')
		msg(concat('for',color(2),' green ',color(f), 'level donators: ',@formatteddlcolors))
		die(concat('for',color(6),' gold ',color(f), 'level donators: ',@formatteddhcolors))
	)
	if(array_contains_ic(@groups,'donatorlow'),assign(@donatorlevel,'low'),assign(@donatorlevel,'high'))
	if(
		equals_ic(@donatorlevel,'low'),
			if(not(array_contains_ic(@dlowcolors,@color)),
				if(not(array_contains_ic(@dhighcolors,@color)),
					msg(concat('color: ',color(@color),@color,color(f)' is not valid, or is not allowed'))
					msg('The following colors are allowed:')
					msg(concat('for',color(2),' green ',color(f), 'level donators: ',@formatteddlcolors))
					die(concat('for',color(6),' gold ',color(f), 'level donators: ',@formatteddhcolors))
				)
				msg(concat('You need to be a ',color(6),'gold ',color(f),'level donator to use the color: 'color(@color),@color))
				msg('The following colors are allowed:')
				msg(concat('for',color(2),' green ',color(f), 'level donators: ',@formatteddlcolors))
				die(concat('for',color(6),' gold ',color(f), 'level donators: ',@formatteddhcolors))
			)
		)
		assign(@user,to_lower(@user))
		store_value(concat(@user, '_namecolor'), @color)
		_rdf_formatname(@user)
		die(concat('Congratulations! your name color is now',color(@color),' this color!'))
)

proc(_rdf_rankformat,@rankname,
	include('/includes/options.ms')
	assign(@index,0)
	assign(@counter,0)
	while(lt(@counter,length(@ranknamearray)),
		if(equals_ic(@rankname,@ranknamearray[@counter]),
			assign(@index,@counter))
		assign(@counter,add(@counter,1))
	)
	assign(@rankname,@ranknamearray[@index])
	assign(@rankcolor,@rankcolorarray[@index])
	assign(@shortrank,@shortranknamearray[@index])
	assign(@return,array(@rankname,@rankcolor,@shortrank))
	return(@return)
)

proc(_rdf_formattags,@user,@usertagarray,
	include('/includes/options.ms')
	assign(@return,color(f))
	assign(@indexarray,array())
	assign(@tags,_rdf_gettags(@user))
	assign(@taglength,get_value(concat(@user,'_taglength')))
	foreach(@usertagarray,@usertag,
		assign(@counter,0)
		foreach(@tagarray,@tag,
			if(equals_ic(@tag,@usertag),array_push(@indexarray,@counter))
			assign(@counter,add(@counter,1))
		)
	)
	if(
		and(
			equals_ic(@taglength,'short'),
			gt(length(@tags),1)
		),
		foreach(@indexarray,@index,
			assign(@return,concat(@return,color(@tagcolorarray[@index]),@tagnamearray[@index]))
		)
		assign(@return,concat(color(f),'[',@return,color(f),']')),
		foreach(@indexarray,@index,
			assign(@return,concat(@return,color(@tagcolorarray[@index]),'[',@tagnamearray[@index],']'))
		)
	
	)
	assign(@return,concat(@return,color(r)))
	return(@return)
)

proc(_rdf_getrank,@user,
	assign(@userrankarray,pgroup(@user))
	include('/includes/options.ms')
	foreach(@rankarray,@rank,
		if(array_contains_ic(@userrankarray,@rank),assign(@userrank,@rank))
	)
	return(@userrank)
)

proc(_rdf_gettags,@user,
	assign(@userrankarray,pgroup(@user))
	include('/includes/options.ms')
	assign(@usertagarray,array())
	foreach(@tagarray,@tag,
		if(array_contains_ic(@userrankarray,@tag),array_push(@usertagarray,@tag))
	)
	return(@usertagarray)
)

proc(_rdf_formatname,@user,
	assign(@user,to_lower(@user))
	assign(@matchplrs, array())
	foreach(all_players(), @tryplr,
		assign(@ltryplr, to_lower(@tryplr))
		if(nequals(reg_match(@user, @ltryplr), array()),
			array_push(@matchplrs, @tryplr)
		)
	)
	if(equals(length(@matchplrs), 0),
		die(concat(color(c),'That player is not online'))
	, #else
		if(equals(length(@matchplrs), 1),
			assign(@player, @matchplrs[0])
		, #else
			msg('Did you mean:')
			die(array_implode(@matchplrs))
		)
	)

	assign(@rank,_rdf_getrank(@user))
	assign(@tagarray,_rdf_gettags(@user))
	if(not(has_value(concat(@user,'_ranklength'))),store_value(concat(@user,'_ranklength'),'long'))
	assign(@ranklength,get_value(concat(@user,'_ranklength')))
	assign(@formattedrank,_rdf_formatrank(@rank,@ranklength))
	assign(@formattedtags,_rdf_formattags(@user,@tagarray))
	assign(@prefix,_rdf_prefix(@user,@formattedrank))
	assign(@suffix,_rdf_suffix(@formattedtags))
	set_display_name(@user,concat(@prefix,@player,@suffix))
	msg(concat('Name fixed, prefix: ', @prefix, color(r), ', suffix: ', @suffix))
)

proc(_rdf_prefix,@user,@formattedrank,
	if(not(has_value(concat(@user,'_namecolor'))),store_value(concat(@user,'_namecolor'),'b'))
	if(not(has_value(concat(@user,'_nameformat'))),store_value(concat(@user,'_nameformat'),color(r)))
	assign(@nf,concat(get_value(concat(@user,'_nameformat'))))
	if(equals_ic(@nf,color(r)),assign(@nameformat,''),assign(@nameformat,@nf))
	assign(@namecolor, concat(color(get_value(concat(@user,'_namecolor')))))
	assign(@prefix,concat(@formattedrank,@namecolor,@nameformat))
	return(@prefix)
)

proc(_rdf_suffix,@formattedtags,
	if(equals_ic(@formattedtags,'null'),
		assign(@suffix,color(f)),
		assign(@suffix,@formattedtags)
	)
	return(@suffix)
)

proc(_rdf_formatrank,@rank,@length,
	assign(@rankarray,_rdf_rankformat(@rank))
	if(equals_ic(@length,'long'),
		assign(@return,concat(color(@rankarray[1]),'[',@rankarray[0],']'))
	)
	if(equals_ic(@length,'short'),
		assign(@return,concat(color(@rankarray[1]),'[',@rankarray[2],']'))
	)
	return(@return)
)