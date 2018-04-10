#!/usr/bin/python3
#
#  Started 20180313 Gabella
#  Utilities especially for converting the Mathematica notebooks into Python3.
#

# 
# macstart = datetime.datetime(1904, 01, 01, 00, 00, 00 )
# unixstart = datetime.datetime(1970, 01, 01, 00, 00, 00)
#
import numpy as np


def dateTimeStamp():
    """Output the time NOW in string format 20180313_140932, i.e. YYYYMMDD_HHMMSS.
    Useful for naming files."""
    import datetime
    aa = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')
    return(aa)
    
# Like the filterBlanks2 in Mathematica.  Drop those lines that do not have valid data in the column, missing mass, etc.
def filterBlanks2(alist, filterInd):
    """Assumes that alist is the list containing the lines from the Exop Dbase.
    Panda dataframe is the input, and
    returns a tuple of dataframes (??)"""
    retList = []
    blankList = []
    for ii in range(len(alist)):
        if alist[ii][filterInd]!='':
            retList.append( alist[ii] )
        else:
            blankList.append( alist[ii] )
    return( (retList, blankList) )

# If you need a function of ONE variable and want many PARAMETERS, make a class and give is a __call__() method, and
# some ways to set the parameters.  See Python-ish examples.  Needed to use stock integrators which cannot use functions
# of many variables.

# Okay the calculation of all the Bessel function stuff, there are three versions I know of in the literature and the
# simplified one in our paper.  All to calculate the g(n omega0, eccen) giving the POWER of the GW for that mode compared
# to the power in a circular orbit of the same masses and semi-major axis.
def ggSimp(nn, ee):
    """Give the simplified version of g(n omega0, eccen) that is in the paper.
    Input the mode number n, where the GW freq is n*omega0, and omega0 is the orbital angular frequency, and the eccentricity.
    Returns g(n,e), the relative GW POWER compared to that from a circular orbit.
    """
    from scipy.special import jn
    
    nn_error = False    # Is this test really worth it?
    if hasattr(nn,'any'):
        if nn.any() < 1:
            nn_error = True
    else:
        if nn < 1:
            nn_error = True
            
    if nn_error:
        print('%s: error mode number less than 1'%'ggSimp()')
        return(-999.0)

    if ee == 0:
        return(1.0)
    else:
        esq = ee*ee
        mesq = 1-esq
        jja = jn(nn-1, nn*ee)
        jjb = jn(nn, nn*ee)
        one = 3*esq*mesq*(1+ mesq*nn*nn)*jja*jja
        two = 3*ee*mesq*( -2+nn*( -2*(2+nn)+esq*(3+2*nn) ) )*jja*jjb
        three = ( -3*ee**6*nn*nn+6*(1+nn)*(1+nn)-3*esq*(1+nn)*(2+5*nn) + \
                 esq*esq*( 1+3*nn*(3+4*nn) ) )*jjb*jjb
        return( nn*nn/(6*ee**4)*(one + two + three) )
    
def ggPM(nn, ee):
    """From Peters and Mathews, 1963 paper on GW from binaries.
    Input the mode number n, where the GW freq is n*omega0, and omega0 is the orbital angular frequency, and the eccentricity.
    Returns g(n,e), the relative GW POWER compared to that from a circular orbit.
    """
    from scipy.special import jn
        
    nn_error = False  # Is this test really worth it?
    if hasattr(nn,'any'):
        if nn.any() < 1:
            nn_error = True
    else:
        if nn < 1:
            nn_error = True
            
    if nn_error:
        print('%s: error mode number less than 1'%'ggPM')
        return(-999.0)
    print(ee)
    if ee == 0:
        return(1.0)
    else:
        esq = ee*ee
        mesq = 1-esq
        jja = jn(nn-2, nn*ee)
        jjb = jn(nn-1, nn*ee)
        jjc = jn(nn, nn*ee)
        jjd = jn(nn+1, nn*ee)
        jje = jn(nn+2, nn*ee)
        one = jja-2*ee*jjb+2/nn*jjc+2*ee*jjd-jje
        one = one*one
        two = jja-2*jjc+jje
        two = mesq*two*two
        three = 4/(3*nn*nn)*jjc*jjc
        return( nn**4/(32)*(one + two + three) )
    
def ggAS(nn, ee):
    """From Amaro-Seoane et al, 2010, SMBHs triplits.  Re-write of Peters and Mathews.  Boring.
    Input the mode number n, where the GW freq is n*omega0, and omega0 is the orbital angular frequency, and the eccentricity.
    Returns g(n,e), the relative GW POWER compared to that from a circular orbit.
    """
    return(  ggPM(nn,ee) )

# For completeness, put in Maggiore's and Peters and Mathews total power radiated
# coefficient in front of the circular power.
def smaf(ee):
    """Given the eccentricity ee, calculates the power in all the GW harmonic
    modes of the GW wave.  Returns the small f(e) factor that multiplies the
    total power radiated if the system was circular.  Maggiore Eqn. 4.75, 
    Peters and Mathews Eqn. (17).
    """
    if ee == 0:
        return(1.0)
    else:
        esq = ee*ee
        mesq = 1-esq
        return(  (1+73/24.*esq+37/96.*esq*esq)/np.power(mesq,7/2)  )

def orbitalFreq(m1, m2, a):
    """Given two masses, m1 and m2, and the semimajor axis a,
    return the orbital frequency in Hz from Kepler relations.
    """
    from scipy.constants import G, pi
    return(  1/(2*pi)*np.sqrt( G*(m1+m2)/a**3 )  )

def redM(m1, m2):
    """The reduced mass shows up in Kepler formulae, m1*m2/(m1+m2)
    """
    return( m1*m2/(m1+m2) )

def totM(m1, m2):
    """The total mass shows up in Kepler formulae, m1+m2
    """
    return( m1+m2 )

def chirpM(m1, m2):
    """The chirp mass, sometimes used in the GW amplitude.
    """
    import numpy as np
    return(  np.power( np.power(m1*m2,3)/(m1+m2), 1/5 )  )
    # Also mchirp = mu^3/5 * mtot^2/5

def hh(nn, ee, m1, m2, a, dL):
    """From Amaro-Seoane et al. 2010, the GW amplitude for GW mode nn in units of
    the orbital frequency, eccentricity ee, binary masses m1 and m2, 
    semi-major axis a, and distance to source dL.  Use SI units.
    Returns the GW amplitude for that frequency mode.
    Amaro-Seoane et al. Eqn. (9), refs Finn and Thorne 2000.
    """
    from scipy.constants import speed_of_light, gravitational_constant, c, G, pi
    freq = orbitalFreq(m1, m2, a)  # In Hz.
    bb = 2*np.sqrt(32/5.)*chirpM(m1, m2)/nn/dL*np.power(2*pi*freq, 2/3)*np.sqrt( ggSimp(nn, ee) )
    bb = np.power(G,5/3)/c**4 * bb  # Put on units to make it dimensionless.
    return( bb )

def fitEcc2N2(ecc):
    """Find from Mathematica fitted data, the maximum useful GW mode number, there the number n where the relative
    amplitude g(n,e) returns to the absolute value 0.05.
    Input the eccentricity and
    Returns nMax.
    """
    aa = 9.521217921844688
    bb = 0.5899926687166828
    cc = -1.4130060483325517
    dd = 0.8921018741263468
    return( np.exp(aa*ecc)*( bb + cc*ecc + dd*ecc*ecc )  )
#  9.521217921844688  0.5899926687166828   -1.4130060483325517  0.8921018741263468 copied from Mathematica .

def aNmax(ecc):
    """Wrap the fitEcc2N2 function, to handle ecc=0, etc.
    If e > 0 always have at least three modes.
    """
    if ecc==0:
        return(2)
    else:
        return(  np.max( [3, np.floor(fitEcc2N2(ecc)+1) ]  )  )
    
def aNmin(ecc):
    """Check the ecc == 0 and return either 2 or 1.
    """
    if ecc == 0:
        return(2)
    else:
        return(1)


def lisa_psd():  # Not Used, kwargs is a dictionary, handle below, call with lisa_psd(kind='linear'), etc.
    """Computes LISA sensitivity curve according to `Cornish and Robson 2018 <https://arxiv.org/pdf/1803.01944.pdf>`_ Their Eqn. (1) and (10) for P_oms (optical metrology noise) and (11) P_acc (test mass acceleration noise). Does NOT include S_c the confusion noise from white dwarf binaries.
    Returns an interpolating function for S_n() which has units "per Hz," so use result(my number) to call the function.  The frequency must be between 1e-9 and 10 Hz.
    """
    import scipy.interpolate as spint
    
    freq = np.logspace(-9,1,10000)
    # note: freq [Hz], L_arm [m], S_n [Hz^-0.5]
    L_arm = 2.5e9  # meters
    f_star = 19.09*1e-3  # Hz

    P_oms = (1.5e-11)**2*(1. + (2.0e-3/freq)**4)  # m^2/Hz, OMS = optical metrology noise
    P_acc = (3.0e-15)**2*(1. + (0.4e-3/freq)**2)*(1. + (freq/(8.0e-3))**4) # m^2/Hz, single test mass acceleration noise

    P_n = (P_oms + 2.*(1. + np.cos(freq/f_star)**2)*P_acc/(2.*np.pi*freq)**4)/L_arm**2
    R = 3./20./(1. + 6./10.*(freq/f_star)**2)  # unitless, Eqn. (9), the transfer function
    S_n = P_n/R

    return spint.interp1d(freq, S_n )  # This is good enough interp, see GWStrainPlotsSNR for linear interp in the 
                                       # log-log-space, which is very linear.

    
def main():
    print('Test dateTimeStamp().')
    print( dateTimeStamp() )
    print()

  
  


if __name__ == '__main__':   # Execute only if run as a script.  For testing.
    main()
    
    
