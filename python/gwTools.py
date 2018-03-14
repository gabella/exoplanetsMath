#!/usr/bin/python3
#
#  Started 20180313 Gabella
#  Utilities especially for converting the Mathematica notebooks into Python3.
#

# 
# macstart = datetime.datetime(1904, 01, 01, 00, 00, 00 )
# unixstart = datetime.datetime(1970, 01, 01, 00, 00, 00)
#
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




def main():
    print('Test dateTimeStamp().')
    print( dateTimeStamp() )
    print()

  
  


if __name__ == '__main__':   # Execute only if run as a script.  For testing.
    main()
    
    
