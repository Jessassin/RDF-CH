#COPYRIGHT (C) Jessassin 2013
#This file is part of the Redstone Development Foundation's CommandHelper Script Library (RDF-CH)
# LICENSED GNU Lesser General Public License (GNU LGPL) version  3
# See LICENSE.txt or visit http://www.gnu.org/licenses/ for more information


#=========================================================================#
#
# RDF Server Worldedit Limiter
# Authored by: Jessassin
# 
# Requires: Worldedit, RDF Commons 1.1+, CH.all
# Risk: low/none
#
#=========================================================================#

proc(_rdf_distance_error,@distance,@maxdistance,
	msg(concat(color(4),'This command has a limited distance!'))
	msg(concat(color(6),'You entered: ',color(3),@distance,color(6),', but the max distance is: ',color(3),@maxdistance))
)
