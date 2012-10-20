#=========================================================================#
#
# RDF Domain Name Forcer
# Authored by: Jessassin
# 
# Requires: n/a
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
		kick(@user,concat('Connect using jessassin.net instead of ',@logindomain[1]))
		console(concat(@user,' failed login, using: ',@logindomain))
	)
)