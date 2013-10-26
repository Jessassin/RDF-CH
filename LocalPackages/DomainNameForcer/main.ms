#COPYRIGHT (C) Jessassin 2013
#This file is part of the Redstone Development Foundation's CommandHelper Script Library (RDF-CH)
# LICENSED GNU Lesser General Public License (GNU LGPL) version  3
# See LICENSE.txt or visit http://www.gnu.org/licenses/ for more information


#=========================================================================#
#
# RDF Domain Name Forcer
# Authored by: Jessassin
# 
# Requires: none
# Permissions: ch.alias.admin
# Risk: low/none
#
#=========================================================================#

bind(player_join,null,null,@event,
	_rdf_specific_domain_runonce(player())
)