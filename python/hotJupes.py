# -*- coding: utf-8 -*-
"""
Created on Tue Apr 12 15:44:56 2016

Search the expolanets database finding the "Hot" Jupiters, especially those
with a host start within 10pc, a mass > 1 M_Jupiter, and close to the star.
That distance is to be determined by the quadrupole radiation from binary
system.

http://exoplanetarchive.ipac.caltech.edu/docs/program_interfaces.html#k2

Query like
wget "http://exoplanetarchive.ipac.caltech.edu/cgi-bin/nstedAPI/nph-nstedAPI?\
table=exoplanets&select=pl_hostname,ra,dec&order=dec&format=ascii" -O "planets.txt"

Default columns of interest, star:  st_dist  -  stellar distance in pc, uncertainties 
column +st_disterr1  -st_disterr2, flag column st_plxblend
Planet: pl_bmassj - planet mass M*sin(i) in Jupiter mass, +pl_bmassjerr1 -pl_bmassjerr2;
pl_orbper - orbital period days, +pl_orbpererr1 -pl_orbpererr2;
pl_orbeccen and errs;
pl_orbincl (degs) and errs;
pl_kepflag (1 = yes), pl_k2flag (1 = yes), pl_bmassprov - planel mass "provenance" either Mass, Msin(i)/sin(i), or Msini;
pl_hostname - host star name from common literature;
pl_letter - planet letter;
pl_pnum - number of planet in system;
pl_name - planet name common in literature;


@author: gabella
"""

import sys, os, math, string
import numpy as np
import matplotlib.pyplot as plt
#import wget
import csv
import urllib3 as u3


# Put together a query and look at a few lines of it.
baseq = 'http://exoplanetarchive.ipac.caltech.edu/cgi-bin/nstedAPI/nph-nstedAPI?'
table = 'table=exoplanets&select=st_dist,pl_bmassj,pl_orbper,pl_hostname,pl_name'
# 1au is 365d and a^3 is prop to T^2
dist = 2.0 # au
per = 365.0*(dist)**1.5  # Kepler's third planetary law
#where = '&where=pl_orbper<%5.1f and st_dist<20 and pl_bmassj>1'%(per)  # units pc, MJ, days
where = '&where=st_dist<20 and pl_bmassj>1 and st_dist is not null'  # units pc, MJ, days
#where = '&where=st_dist is null'
suffix = '&order=st_dist asc&format=csv'
#suffix = '&format=csv'

print baseq+table+where+suffix

ahttp = u3.PoolManager(timeout=10.0)
areq = ahttp.request('GET', baseq+table+where+suffix)

print 'areq status ', areq.status
print 'areq headers ', areq.headers
print 'len areq data ', len(areq.data)

print 'Top lines:'
print areq.data[0:400]

fname = 'out.csv'
ofile = open(fname, 'wb')
ofile.write(areq.data)
ofile.close()

print '===It is finished.=== '






