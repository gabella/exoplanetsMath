# -*- coding: utf-8 -*-
"""
Spyder Editor

Some "hand" calculations for the exoplanet PSRJ1719-1438 b, the Diamond star.

This is a temporary script file.
"""

import os, sys
import numpy as np

# Keep it simple.
# from the expolanet data base the parameters of interest are...
#
#  Grabbed this CSV copy on 20170307_112514, using the database names.
# Units are days, au, dim less, M_jupiter, pc, M_sol  .
(pl_orbper, pl_orbsmax, pl_orbeccen, pl_bmassj, st_dist, st_mass ) = \
    ( 0.0907, 0.0044, 0.06, 1.2, 1200., 1.4 )
    
# Use the order-of-mag formula  h0 = rs1*rs2 / ( r*R )  where rs1 is the
# Schwarzschild radius for the mass m1, 2G m1/c^2, or 2955.43 M/M_sol,
# r is the distance between the masses and the observer,
# R is the separation of the two masses .

facAU = 149.6e9 # meters in an AU
facRs = 2955.43  # meters per solar masses
facMj = 0.0009543 # 1/1047.  # solar masses for one Jupiter mass, 0.0009543
facDist = 3.086e16 # meters per parsec

# Approximation, for circular orbits.
# Calc everything in meters.
rs1 = facRs*st_mass  # star mass in meters
rs2 = facRs*facMj*pl_bmassj  # planet mass in meters
rdist = st_dist*facDist
Rsep = pl_orbsmax*facAU

h0 = rs1*rs2/( rdist*Rsep )
print('h0 is ', h0)
print(' rs1  rs2  rdist  Rsep ', (rs1, rs2, rdist, Rsep) )

# One peak per revolution enhancement, goes like N while noise goes like sqrt(N).

intTime = 10.0*365.*24.*3600.  # 10 years intergration time
gwTime = 0.50*pl_orbper*24.0*3600.  # <<Fixed using the GW period
nPulses = intTime/gwTime
print(' 10 year dataset, GW crests enhanced by ', np.sqrt(nPulses), 'for N ', nPulses)
print('     and h0_eff = ', np.sqrt(nPulses)*h0)

# Enhance by eccentricity, a little, see Peters & Matthews , and
# Amaro-Seoane et al.
# Keep is simple for OOM, assume power is like h0**2, so the enhancement is
# sqrt( P(e)/P(0) ) that is the ratio of the power for an eccentric orbit
# compared to that for a circular one.

# Our paper Eqn. (8) power in all harmonics but most of it is in n=3 (n=2, 4)
# are on the plot and are smaller.
    
def fPwr(e):
    aa = 1 + 73./24.*e**2 + 37/96.*e**4
    bb = (1-e**2)**(7/2)
    return( (aa/bb) )

ee = pl_orbeccen
print(' And the eccentrity enhancement in n=3 mostly is ', np.sqrt( fPwr(ee) ) )
print('   and h0_eff_eff = ', np.sqrt( fPwr(ee) )*np.sqrt(nPulses)*h0)
print('   Okay there is looks pretty small.  Why?  fPwr(e) is ', fPwr(ee) )

    
    



