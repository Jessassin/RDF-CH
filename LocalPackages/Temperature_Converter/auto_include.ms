#COPYRIGHT (C) Jessassin 2013
#This file is part of the Redstone Development Foundation's CommandHelper Script Library (RDF-CH)
# LICENSED GNU Lesser General Public License (GNU LGPL) version  3
# See LICENSE.txt or visit http://www.gnu.org/licenses/ for more information


#=========================================================================#
#
# RDF Server Temperature Converter
# Authored by: Jessassin
# Contributors: iDeNoh
# 
# Requires - permission ch.all
# Requires - RDF_CH_Commons 1.0+
# Risk: low/none
#
#=========================================================================#

proc(_rdf_to_celsius, @temp,
	assign(@temp, multiply(9/5,@temp))
	assign(@temp, add(@temp,32))
	return(@temp)
)

proc(_rdf_to_farenheit, @temp, 
	assign(@temp, subtract(@temp,32))
	assign(@temp, multiply(@temp,5/9))
	return(@temp)
)
