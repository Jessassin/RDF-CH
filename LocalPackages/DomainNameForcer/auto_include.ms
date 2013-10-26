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

proc(_rdf_specific_domain,@user,
	include('includes/domains.txt')
	assign(@domain,pinfo(@user,12))
	assign(@logindomain,array(@domain))
	assign(@acceptabledomain,0)
	foreach(@domains,@d,
		if(array_contains_ic(@logindomain,@d),
			assign(@acceptabledomain,1)
		)
	)
	if(equals(@acceptabledomain,1),
		msg('correct domain used!'),
		msg('incorrect domain used!')
	)
)

proc(_rdf_specific_domain_runonce,@user,
	include('includes/domains.txt')
	foreach(@exemptuserarray,@exemptuser,
		if(equals_ic(@user,@exemptuser),
			die()
		)
	)
	assign(@domain,pinfo(@user,12))
	assign(@logindomain,array(@domain))
	assign(@acceptabledomain,0)
	foreach(@domains,@d,
		if(array_contains_ic(@logindomain,@d),
			assign(@acceptabledomain,1)
		)
	)
	if(equals(@acceptabledomain,1),
		msg(''),
		kick(@user,concat(@logindomain,' has been moved: using your browser, visit rdf.jessassin.net for more info'))
		console(concat(@user,' failed login, using: ',@logindomain))
	)
)