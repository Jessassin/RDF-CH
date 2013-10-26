#COPYRIGHT (C) Jessassin 2013
#This file is part of the Redstone Development Foundation's CommandHelper Script Library (RDF-CH)
# LICENSED GNU Lesser General Public License (GNU LGPL) version  3
# See LICENSE.txt or visit http://www.gnu.org/licenses/ for more information


#=========================================================================#
#
# RDF Server Admin Chat
# Authored by: Tyler569
#
# Requires: RDF_CH_Commons
# Permissions: ch.alias.admin, ch.alias.all
# Risk: low/none
#
#=========================================================================#

proc(_adminchat, @message,
	if(lt(length(@message),1),
		_rdf_syntaxerror(get_cmd(),'<message to admin chat>')
	)
	foreach(all_players(), @player,
		if(has_permission(@player, 'ch.alias.admin'),
			tmsg(@player,
				concat(color(4), '[#]', color(b), player(), color(f), ' ', @message)
			)
		)
	)
)
