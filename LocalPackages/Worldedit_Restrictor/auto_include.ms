#=========================================================================#
#
# RDF Server Worldedit Limiter
# Authored by: Jessassin
# 
# Requires: Worldedit, RDF Commons 1.1+, CH.all
# Risk: low/none
#
#=========================================================================#

proc(_distance_error,@distance,@maxdistance,
	msg(concat(color(4),'This command has a limited distance!'))
	msg(concat(color(6),'You entered: ',color(3),@distance,color(6),', but the max distance is: ',color(3),@maxdistance))
)
