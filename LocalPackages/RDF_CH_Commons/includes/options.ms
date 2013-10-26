#COPYRIGHT (C) Jessassin 2013
#This file is part of the Redstone Development Foundation's CommandHelper Script Library (RDF-CH)
# LICENSED GNU Lesser General Public License (GNU LGPL) version  3
# See LICENSE.txt or visit http://www.gnu.org/licenses/ for more information


assign(@worldeditlimit,256)
assign(@plotsize,48)
assign(@tagarray,array(mod,admin,founder,serveradmin,donatorlow,donatorhigh,writer,helper,sponsorlow,sponsormid,sponsorhigh))
assign(@tagcolorarray,array(c,4,4,4,2,6,5,7,2,6,1,2,6,1))
assign(@tagnamearray,array(M,A,F,SA,D,D,W,H,S,S,S))
assign(@numtags,length(@tagarray))
assign(@rankarray,array(default,guest,testificate,student,builder,engineer,scientist,guru))
assign(@rankcolorarray,array(f,f,9,f,a,2,c,5))
assign(@ranknamearray,array(Visitor,Guest,Testificate,'',Builder,Engineer,Scientist,Guru))
assign(@shortranknamearray,array('V','Guest','Test','','Bldr','Eng','Sci','Guru'))
assign(@numranks,length(@rankarray))