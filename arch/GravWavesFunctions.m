(* ::Package:: *)

Clear["Global`*"]


(* ::Title:: *)
(*Some GW strain calculations*)


(* ::Section:: *)
(*Notes*)


(* ::Text:: *)
(*20160704 Moved functions and constants into this Package/Library from GWExopWECC.nb.*)


(* ::Section:: *)
(*References*)


(* ::Text:: *)
(*P. Amaro-Seoane et al. "Triplets of supermassive black holes: astrophysics, gravitational waves and detection," MNRAS 402 2308-2320 (2010);*)
(*P. C. Peters and J. Mathews, "Gravitational Radiation from Point Masses in a Keplerian Orbit," Phys. Rev. 131 (1963) 435-440.*)
(*Michele Maggiore, "Gravitational Waves. Volume 1: Theory and Experiments," Oxford Univ. Press, 2008.*)


(* ::Section:: *)
(*Large Package*)


BeginPackage["GravWaves`"]


(* ::Section:: *)
(*Constant useful for the GW formulae.*)


(* ::Text:: *)
(*Some constants.  Work in SI units.http://arstechnica.com/the-multiverse/2016/05/recapture-the-glory-of-radium-age-sci-fi-from-a-century-ago-with-these-books/*)
(*Okay, join the astro / GR world and look at units of length for mass, etc, that is G=c=1 type of unit conversion.*)


BeginPackage["GravWaves`GWConstants`"]


Clear[massSun,massJ,massE,massJs,pc,au,cee,secsYear,secsDay,bigG,rscon,lunits,masscon,
powercon,energycon]

massSun = 1.99 10^30; (*kg *)
massJ = 1.9 10^27; (* kg *)
massE = 5.97 10^24; (* kg *)
massJe = 317.9; (* earth masses *)
massJs = massJ/massSun; (* relative to the sun's mass *)
pc = 30.86 10^15; (* meters, parsec *)
au = 149.6 10^9; (* meters, astron unit *)
cee = 299792458.0; (* meters/s, speed of light *)
secsYear = 365.24*24.0*3600.0; (* s, number of seconds in a year *)
secsDay = 24.0*3600.0; (* s, number of seconds in a day *)
bigG = 6.67384 10^-11; (* Gravitational constant, m^3/kg/s *)

rscon = 2955.43; (* meters per solar mass, Schwarzschild radius *)
rscon = 2*6.67388 10^-11*massSun/cee^2;  (* solar mass Scharzschild radius *)
lunits =6.67388 10^-11*massSun/cee^2;  (* meters per solar mass, units of G=c=1, no factor of 2 as in Schwarzschild radius *)
masscon = 1477.71; (* m, G Msol/c^2, for 1 solar mass *)
powercon = 3.628 10^52; (* W, c^5/G, W/unit since P is dimensionless in G=c=1 units *)
energycon = 1.210 10^44; (* J/m, c^4/G *)
Print[rscon, " meters per solar mass, Schwarzschild for sun."]
Print[lunits, " meters per solar mass, G=c=1 units."]



EndPackage[] (* GWConstants *)


(* ::Text:: *)
(*the orbital frequency, a is the semi-major axis if elliptical orbits, the radial separation of the masses is 2*R is circular.*)


BeginPackage["GravWaves`GWKeplerOrbit`"]


Needs["GravWaves`GWConstants`"]



sepAU[days_]:=(days/365.24)^(2/3)
(* Test for Null values and return -9999.99 . *)
calchzero[plorbper_, plbmassj_, stmass_, stdist_]:=
plbmassj*massJs*rscon*stmass*rscon/( sepAU[plorbper]*au*stdist*pc )
calc\[Omega]sq[plorbper_, plbmassj_, stmass_]:=
(plbmassj*massJs+stmass)*rscon/2/(sepAU[plorbper]*au)^3  (* really (\[Omega]/c)^2, like k *)


(* ::Text:: *)
(*I think the calculation should go, find the orbital frequency Subscript[f, 0] (Hz), from Subscript[m, 1], Subscript[m, 2], and a, then calculate the Power in front of total (Eqn 4.74) or of harmonic (Eqn. 4,107).*)


freq::usage="freq[m1,m2,a] gives the orbital period in Hz for masses m1 and m2, and semi-major axis a or radius a if circular."


(* ::Input:: *)
(*freq[m1_, m2_, a_]:=2\[Pi] Sqrt[ ((bigG(m1+m2))/(a^3))] (* Hz, orbital period *)*)
(**)


EndPackage[] (* GWKeplerOrbit *)


(* ::Section:: *)
(*Read the CSV file.*)


BeginPackage["GravWaves`GWcsvFile`"]



(*myDir = "/scratch/gabella/Documents/astro/exop/";*)
myDir = "/home/gabella/Documents/astro/exop/";csvFileName = myDir<>"exop_20160701_113512.csv";  (* for reading past saved files *)


(* ::Text:: *)
(*Find the date-time stamp...lots of StringSplit[]'s.*)


dateTimeStamp = Module[{aa,bb,cc},
aa = StringSplit[csvFileName,"/"][[-1]];  (* Filename with stamp is last element. *)
bb = StringSplit[aa,"."][[1]]; (* Drop the .csv extension . *)
cc = StringSplit[bb, "_"]; (* Last two elements are the YYYYMMDD and the HHMMSS strings. *) 
cc[[2]]<>"_"<>cc[[3]]
]


(* ::Text:: *)
(*Has XXXX total cols starting with # that give the columns and other info.  Column headers in Row number 15, then data as strings??*)


(* ::Input:: *)
(*(*alldata = Import[csvFileName, "Data"];*)*)


(* ::Text:: *)
(*If you use my Mathematica file ExoDBase.nb and/or the https search and NOT the online form, you do not have all the #xxxx header information in the file.  So the rowHeaders is always 1, and rowDataStart is always 2.*)


rowHeaders=1; rowDataStart=rowHeaders+1;  (* row with the headers, etc . *)


(* ::Text:: *)
(*Row 1 has the column headers and Row 2 starts the data, usually.  Cols are*)
(*rowid,pl_hostname,pl_letter,pl_orbper,pl_orbsmax,pl_orbeccen,pl_bmassj,st_dist,st_mass,pl_name,pl_massj*)
(*# COLUMN pl_hostname:    Host Name*)
(*# COLUMN pl_letter:      Planet Letter*)
(*# COLUMN pl_orbper:      Orbital Period [days]*)
(*# COLUMN pl_orbsmax:     Orbit Semi-Major Axis [AU]*)
(*# COLUMN pl_orbeccen:    Eccentricity*)
(*# COLUMN pl_bmassj:      Planet Mass or M*sin(i)[Jupiter mass]*)
(*# COLUMN st_dist:        Distance [pc]*)
(*# COLUMN st_mass:        Stellar Mass [Solar mass]*)
(*# COLUMN pl_name:        Planet Name*)
(*# COLUMN pl_massj:       Planet Mass [Jupiter mass]*)
(*# COLUMN st_plx:	Star parallax distance [mas], NB: dist in pc is 1000.0/st_plx (in mas)*)


(* ::Input:: *)
(*(*{alldata[[rowHeaders]],*)
(*Map[ Head, alldata[[rowDataStart]] ],*)
(*alldata[[rowDataStart]]}//TableForm*)*)


(* ::Text:: *)
(*Okay it looks like Mathematica treats it as mixed format and guesses pretty well.*)
(*Make a dictionary, aka Association in Mathematica, with the header strings to the column numbers / array indices.*)


calcCols::usage="calcCols[alldata], where the alldata[rowHeaders] has the column names, returns an association with cols[\"pl_orbper\"] giving the column number, etc."
calcCols[alldata_]:=Module[{cols = <||>},  (* Use an Association as an enum, or Dictionary *)
For[icnt=1, icnt<=Length[ alldata[[rowHeaders]] ], icnt+=1,
AppendTo[cols,alldata[[rowHeaders,icnt]]->icnt]
];
cols
]


(* ::Input:: *)
(*(*Keys[cols]*)*)


(* ::Input:: *)
(*(*{cols["rowid"], cols["pl_orbper"]}*)*)


(* ::Text:: *)
(*Some Filter functions collected here.*)


Clear[filterBlanks]
filterBlanks[aa_]:=Module[{retList},
retList={};
For[i=1,i<=Length[aa], i++,
If[ NumberQ[ aa[[i]] ], AppendTo[retList, aa[[i]] ], Null  ]
];
retList
]


(* ::Text:: *)
(*Some of the fields are blank, so drop those planets from consideration.*)


Clear[filterBlanks2]
filterBlanks2[aa_, filterInd_]:=Module[{retList, blankList},
retList={};
blankList={};
For[i=1,i<=Length[aa], i++,
If[ NumberQ[ aa[[i,filterInd]] ], AppendTo[retList, aa[[i]] ], AppendTo[blankList, aa[[i]] ]]
];
{retList, blankList}
]


(* ::Text:: *)
(*Filter the blanks in all masses, eccentricity, semimajor axis, and distance.*)


bigFilter[alldata_]:=Module[{fdata1,fdata2, fdata3, fdata4, fdata5, fdata6},
Print["Length alldata ",Length[alldata] ]
fdata1 = filterBlanks2[alldata[[rowDataStart;;]], cols["pl_orbeccen"] ][[1]]; Print[ "pl_orbeccen ", Length[fdata1]]
fdata2 = filterBlanks2[fdata1, cols["pl_orbper"] ][[1]]; Print[ "pl_orbper ",Length[fdata2] ]
fdata3 = filterBlanks2[fdata2, cols["pl_orbsmax"] ][[1]]; Print["pl_orbsmax ",Length[fdata3] ]
fdata4 = filterBlanks2[fdata3, cols["pl_bmassj"] ][[1]]; Print["pl_bmassj ",Length[fdata4] ] (* use pl_bmassj not pl_massj *)
fdata5 = filterBlanks2[fdata4, cols["st_dist"] ][[1]]; Print["st_dist ",Length[fdata5] ]
fdata6 = filterBlanks2[fdata5, cols["st_mass"] ][[1]]; Print["st_mass ",Length[fdata6] ]
]



EndPackage[] (* GWcsvFile *)


(* ::Section:: *)
(*Functions from Peters and Mathews, Maggiore, and Amaro-Seoane.*)


BeginPackage["GravWaves`GWRadiationFormulae`"]


Needs["GravWaves`GWConstants`"]
Needs["GravWaves`GWcsvFile`"]


smaf::usage = "smaf[e] gives the power factor for an orbit with eccentricity e, see Maggiore's Eqns (4.74)-(4.75)."
smaf[e_]:=((1+73/24 e^2+37/96 e^4)/((1-e^2)^(7/2))) (* Maggiore's formula Eqn 4.75 page 179 *)


(* ::Text:: *)
(*Formulae for the frequencies of GW from eccentric orbits.*)
(*Peters and Mathew 1963, also using Maggiore page 184, and Amaro-Seoane Eqn. (9) plus.*)


(* ::Input:: *)
(*(* Can Mathematica use underscores yet? Nope, the underscore should be used only to designate the type when dummy function vars. *)*)
(*(*aa_bb=23*)
(*aa_bb+=2 Error *)*)


(* ::Text:: *)
(*Maggiore Eqns. 4.94-95, small Subscript[a, n] and small Subscript[b, n] , n!=0 .  Fourier coefficients for x(t) and y(t), all orbital motion in the x-y plane.*)


jj::usage = "jj[n,x] is shorthand for BesselJ[n,x]."
sma::usage = "sma[n,e,asmaj] is small a, Maggiore's Eqn 4.94, n is the harmonic in orbit angular frequency, asmaj is the semi-major axis."
smb::usage = "smb[n,e,asmaj] is small b, Maggiore's Eqn 4.95, n is the harmonic in orbit angular frequency, asmaj is the semi-major axis."


jj = BesselJ[#1,#2]&;
sma[n_,e_, asmaj_]:=asmaj/n  (jj[n-1,n e]-jj[n+1,n e])(* n-freq mult/index, e-ecc, asmaj-semimajor axis *)
smb[n_,e_, asmaj_]:=((asmaj*Sqrt[1-e^2])/n) (jj[n-1,n e]+jj[n+1,n e]) (* really multiplied by the semiminor axis *)


(* ::Text:: *)
(*Maggiore Eqns. 4.99-101*)


bigA::usage = "bigA[n,e,asmaj], n is harmonic, e is eccentricity, asmaj is semi-major axis.  Maggiore's Eqn (4.99), used to calculate g(n,e)."
bigB::usage = "bigB[n,e,asmaj], n is harmonic, e is eccentricity, asmaj is semi-major axis.  Maggiore's Eqn (4.100), used to calculate g(n,e)."
bigC::usage = "bigC[n,e,asmaj], n is harmonic, e is eccentricity, asmaj is semi-major axis.  Maggiore's Eqn (4.101), used to calculate g(n,e)."
gg::usage = "gg[n,e,asmaj], n is harmonic, e is eccentricity, asmaj is semi-major axis which cancels out.  Maggiore's Eqn (4.108), ratio of power in a harmonic to constants."
powerCoeff::usage = "powerCoeff[m1,m2,asmaj], masses m1 and m2 and radius or semi-major axis asmaj.  Maggiore's Eqn (4.107), the power coefficient in front."


bigA[n_,e_, asmaj_]:=asmaj^2/n (jj[n-2,n e]-jj[n+2,n e]-2 e jj[n-1,n e]+2 e jj[n+1,n e] )
bigB[n_,e_, asmaj_]:=(asmaj^2 (1-e^2))/n  (jj[n+2,n e]-jj[n-2,n e])
bigC[n_,e_, asmaj_]:=(asmaj^2 Sqrt[1-e^2])/n (jj[n+2,n e]+jj[n-2,n e]-e jj[n+1,n e]- e jj[n-1,n e] )
gg[n_,e_]:=n^6/(96 asmaj^4)  (bigA[n,e,asmaj]^2+bigB[n,e,asmaj]^2+3bigC[n,e,asmaj]^2-bigA[n,e,asmaj]*bigB[n,e,asmaj]) /.asmaj->1 (* the asmag cancel out! *)



pwrTot::usage = "pwrTot[m1,m2,asmaj], masses m1 and m2 and radius or semi-major axis asmaj.  Maggiore's Eqn (4.74), the power coefficient in front."
pwrSubN::usage = "pwrSubN[m1,m2,asmaj], masses m1 and m2 and radius or semi-major axis asmaj.  Maggiore's Eqn (4.107), the power coefficient in front."


powerCoeff[m1_,m2_,asmaj_]:=(32 bigG^4  m1^2 m2^2 (m1+m2))/(5 cee^5 asmaj^5) (* W, power radiated into n-th mode, if times g(n,e) or total if times f(n,e) *)
pwrTot[m1_,m2_,asmaj_]:=powerCoeff[m1, m2, asmaj] (* W, Lead coefficient in eqn. 4.74 for total power radiated from orbiting masses in an eccentric orbit. *)
pwrSubN[m1_,m2_,asmaj_]:=powerCoeff[m1,m2,asmaj]  (* Lead coefficient for eqn. 4.107, power in nth harmonic. *)


(* ::Text:: *)
(*The three formulae, Peters & Mathews eqn (20), Amaro-Seone et al. (4)-(6), and Maggiore (4.107-108).  Check that they are the same.  Similar looking and Bessel funtion identities might make them identical...one hopes.*)


(* ::Text:: *)
(*Already have Maggiore's formula above, gg[n_,e_,asmaj_].*)
(*Peters and Mathews, eqn 20.  The coefficient on eqn 19 is the same as in Maggiore.*)


ggPM[n_,e_]:= n^4/32 (  (jj[n-2,n e]-2 e jj[n-1,n e]+2/n  jj[n, n e]+2 e jj[n+1, n e]-jj[n+2, n e])^2+
(1-e^2)(jj[n-2,n e]-2 jj[n, n e]+jj[n+2, n e])^2 +4/(3 n^2) jj[n, n e]^2 )


(* ::Text:: *)
(*Amaro-Seone et al. Eqns (4-6).*)


bigAAS[n_,e_]:=jj[n-2,n e]-2 jj[n, n e]+jj[n+2,n e]
bigBAS[n_,e_]:=jj[n-2,n e]-2 e jj[n-1,n e]+2/n  jj[n,n e]+2 e jj[n+1,n e]-jj[n+2,n e]
ggAS[n_, e_]:=n^4/32  (bigBAS[n,e]^2 + (1-e^2)bigAAS[n,e]^2+4/(3 n^2)  jj[n,n e]^2)


(* ::Text:: *)
(*Estimate max fequency harmonic n given the eccentricity e, using the function g[n,e] back down to 5% or so.*)


fitEcc2N2::usage = "fitEcc2N2[e], e is eccentricity, finds a suitable max n, harmonic, for a given eccentricity.  Looks at g[n,e] only."
fitEcc2N2[e_]:=E^(9.52122 e) (0.589993 - 1.41301 e +0.892102 e^2 )


Clear[findSecondRoot];
findSecondRoot[ee_, lim_]:=Module[{alist,nmax=200,iloop=True, ifirstRoot=False, ii, prev},
alist=Table[{ii,ggPM[ii,ee]-lim>0 },{ii, 1, nmax}];  (* Check for neg, then pos, then neg, there is second root. *)
ii=1;
prev=alist[[ii,2]];
While[iloop,
If[ Xor[prev,alist[[ii,2]]],
If[ifirstRoot==False,ifirstRoot=True, iloop=False ], Null];(* True when goes from neg to pos in above ggPM-lim. *)
prev = alist[[ii,2]];
ii++;
];
(* Now ii is near second root. *)
FindRoot[ggPM[nn,ee]-lim==0,{nn,ii}]
]



(* ::Text:: *)
(*h_n Eqn. (9).*)


Clear[chirpM,redM, totM, fr, hh]
chirpM[m1_,m2_]:=(m1 m2)^(3/5)/(m1+m2)^(1/5) 
redM[m1_,m2_]:=(m1 m2)/(m1+m2) 
totM[m1_,m2_]:=m1+m2
fr[m1_,m2_,a_]:=1/(2 \[Pi]) Sqrt[(bigG(m1+m2))/a^3] (* orbital frequency, Hz *)
hh [n_,e_,m1_,m2_,a_, dL_]:= (bigG^(5/3)/cee^4) 2 Sqrt[(32/5)] ((chirpM[m1,m2]^(5/3))/(n dL))  ((2\[Pi] fr[m1,m2,a])^(2/3))  Sqrt[ggAS[n,e]]  (* AS et al. Eqn (9), Subscript[d, L] is luminosity distance from d=Subscript[d, L]/(1+z), z=0 for us, Subscript[f, r] is orbital freq *)


Clear[aNmax];
aNmax[ecc_]:=If[ecc==0, 2, Floor[fitEcc2N2[ecc]+1]]
Clear[aNmin];
aNmin[ecc_]:=If[ecc==0,1, 1]


(* ::Text:: *)
(*Test the above formulae on this short table.*)


(* ::Text:: *)
(*Create string names without the underscore and with an "a" in front!  Later make them an expression (symbol?) so they can hold the data.*)


(* ::Text:: *)
(*stuff*)


(*colNamesStr=Module[{aa, bb, myname},
aa=alldata[[rowHeaders]];
bb={};
For[ii=1, ii<=Length[aa], ii++,
myname="a"<>StringReplace[aa[[ii]],"_"->""];
AppendTo[bb, myname  ]
];
bb
]*)


EndPackage[] (* GWRadiationFormulae *)


(* ::Section:: *)
(*End of Big Package*)


EndPackage[]
