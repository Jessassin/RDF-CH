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