#=========================================================================#
#
# RDF Server CommandHelper Commons
# Authored by: Jessassin
# 
# Requires: permission - ch.admin (only for command)
# Risk: low/none
#
#=========================================================================#

proc(_checkpermission,@permission,@player,
assign(@perm,concat('ch.alias.',@permission))
	if(not(has_permission(@player,@perm)),
		die('Permission error!')
	)
)

proc(_formattext,@format,
	if(
		nor(
			equals_ic(@format,'bold'),
			equals_ic(@format,'italic'),
			equals_ic(@format,'strike'),
			equals_ic(@format,'underline'),
			equals_ic(@format,'none')
		),
		die(concat('ERROR! in proc(_formatchat) - format not supported -', @format))
		)
	if(equals_ic(@format,'bold'),assign(@realform,§l))
	if(equals_ic(@format,'strike'),assign(@realform,'§m'))
	if(equals_ic(@format,'underline'),assign(@realform,'§n'))
	if(equals_ic(@format,'italic'),assign(@realform,'§o'))
	if(equals_ic(@format,'none'),assign(@realform,'§p'))
	return(concat(@realform))
)

proc(_currentquadrant,@locarray,
	assign(@x,@locarray[0])
	assign(@z,@locarray[2])
	if(and(not(lt(@x,0)),not(lt(@z,0))),assign(@quadrant,1))
	if(and(not(lt(@x,0)),lt(@z,0)),assign(@quadrant,2))
	if(and(lt(@x,0),lt(@z,0)),assign(@quadrant,3))
	if(and(lt(@x,0),not(lt(@z,0))),assign(@quadrant,4))
	assign(@return,@quadrant)
	return(@return)
)

proc(_findfirstloc,@x,@z,
	include('/includes/options.ms')
	assign(@quadrant,_currentquadrant(array(@x,100,@z)))
	if(equals(@quadrant,1),
		assign(@realx,ceil(@x))
		assign(@realz,ceil(@z))
		while(gt(mod(@realx,@plotsize),0),
			assign(@realx,add(@realx,1))
		)
		while(gt(mod(@realz,@plotsize),0),
			assign(@realz,add(@realz,1))
		)
		assign(@realx,subtract(@realx,1))
		assign(@realz,subtract(@realz,1))
	)
	if(equals(@quadrant,2),
		assign(@realx,ceil(@x))
		assign(@realz,floor(@z))
		while(gt(mod(@realx,@plotsize),0),
			assign(@realx,add(@realx,1))
		)
		while(gt(mod(neg(@realz),@plotsize),0),
			assign(@realz,subtract(@realz,1))
		)
		assign(@realx,subtract(@realx,1))
	)
	if(equals(@quadrant,3),
		assign(@realx,floor(@x))
		assign(@realz,floor(@z))
		while(gt(mod(neg(@realx),@plotsize),0),
			assign(@realx,subtract(@realx,1))
		)
		while(gt(mod(neg(@realz),@plotsize),0),
			assign(@realz,subtract(@realz,1))
		)
	)
	if(equals(@quadrant,4),
		assign(@realx,floor(@x))
		assign(@realz,ceil(@z))
		while(gt(mod(neg(@realx),@plotsize),0),
			assign(@realx,subtract(@realx,1))
		)
		while(gt(mod(@realz,@plotsize),0),
			assign(@realz,add(@realz,1))
		)
		assign(@realz,subtract(@realz,1))
	)
	assign(@return,array(@realx,100,@realz))
	return(@return)
)

proc(_findsecondloc,@firstlocarray,@quadrant,
	include('/includes/options.ms')
	assign(@plotsize,@plotsize - 1)
	assign(@firstx,@firstlocarray[0])
	assign(@firsty,@firstlocarray[1])
	assign(@firstz,@firstlocarray[2])
	assign(@secondy,@firsty)
	if(equals(@quadrant,1),
		assign(@secondx,subtract(@firstx,@plotsize))
		assign(@secondz,subtract(@firstz,@plotsize))
	)
	if(equals(@quadrant,2),
		assign(@secondx,subtract(@firstx,@plotsize))
		assign(@secondz,subtract(@firstz,neg(@plotsize)))
	)
	if(equals(@quadrant,3),
		assign(@secondx,subtract(@firstx,neg(@plotsize)))
		assign(@secondz,subtract(@firstz,neg(@plotsize)))
	)
	if(equals(@quadrant,4),
		assign(@secondx,subtract(@firstx,neg(@plotsize)))
		assign(@secondz,subtract(@firstz,@plotsize))
	)
	assign(@return,array(@secondx,@secondy,@secondz))
	return(@return)
)

proc(_rdf_daytime,@player,
	sudo(concat('/playertime -s ',@player,' 14'))
)

proc(_rdf_nighttime,@player,
	sudo(concat('/playertime -s ',@player,' 2'))
)

proc(_cuboid_volume, @arr1, @arr2,
	return(
		multiply(
			abs(add(1, subtract(@arr2[0], @arr1[0]))),
			abs(add(1, subtract(@arr2[1], @arr1[1]))),
			abs(add(1, subtract(@arr2[2], @arr1[2])))
		)
	)
)

proc(_iterate_cuboid, @b1, @b2, @proc_name,
    for(assign(@x, min(@b1[0], @b2[0])), lte(@x, max(@b1[0], @b2[0])), inc(@x),
        for(assign(@y, min(@b1[1], @b2[1])), lte(@y, max(@b1[1], @b2[1])), inc(@y),
            for(assign(@z, min(@b1[2], @b2[2])), lte(@z, max(@b1[2], @b2[2])), inc(@z),
                call_proc(@proc_name, @x, @y, @z)
            )
        )
    )
)

proc(_rdf_checkcommonsversion,@requiredversion,
	assign(@commonsversion,abs(1.1))
	if(equals_ic(@requiredversion,'return'),
		return(@commonsversion)
	)
#	if(gte(@commonsversion,@requiredversion),
#		# return(0)

#	)
	if(lt(@commonsversion,@requiredversion),
#		# return(1)
		_rdf_commonsoutofdate(@requiredversion,@commonsversion)
	)
)

proc(_rdf_commonsoutofdate,@requiredversion,@commonsversion,
	msg(color(4),'====================')
	msg(color(c),'commons out of date!')
	msg('Current version: ',color(6),@commonsversion)
	msg('Required version: ',color(2),@requiredversion)
	die(color(4),'====================')
)
proc(_rdf_syntaxerror,@command,@syntax,
	msg('Improper syntax!')
	die(concat('Proper syntax: ',@command,' ',@syntax))
)

proc(_rdf_syntaxmessage,@command,@syntax,
	die(concat('Syntax: ',@command,' ',@syntax))
)

proc(_rdf_helpmessage,
	assign(@command,'This command has no help entry'),
	assign(@syntax,'This command has no syntax entry'),
	assign(@helpmessage,'This command has no help message'),
		msg(concat(color(4),'Help message for command: ',@command))
		msg(concat(color(6),'Syntax: ',color(2),@syntax))
		if(equals_ic(@helpmessage,'null'),
		die('There is no help text for this command'),
		die(@helpmessage))
)

proc(_rdf_3d_distance, @arr1, @arr2,
    return(
        floor(
            sqrt(
                add(
                    pow(subtract(@arr2[0], @arr1[0]), 2),
                    pow(subtract(@arr2[1], @arr1[1]), 2),
                    pow(subtract(@arr2[2], @arr1[2]), 2)
                )
            )
        )
    )
)

proc(_rdf_2d_distance, @arr1, @arr2, 
	return(
		floor(
			sqrt(
				add(
					pow(subtract(@arr2[0], @arr1[0]), 2),
					pow(subtract(@arr2[2], @arr1[2]), 2),
					1
				)
			)
		)
	)
)

proc(_rdf_max_horizontal_distance, @arr1, @arr2,
	return(
		add(
			floor(
				max(
					abs(subtract(@arr2[0], @arr1[0])),
					abs(subtract(@arr2[2], @arr1[2]))
				)
			),
			1
		)
	)
)

proc(_rdf_vertical_distance, @arr1, @arr2,
	return(
		floor(
			add(
				abs(subtract(@arr1[1], @arr2[1]))
			)
		)
	)
)
