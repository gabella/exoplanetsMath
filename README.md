# Python - Workflow

Python files that duplicate the Mathematica functions are in the python folder.

* Start you Jupyter notebook however you do.
* To update the exoplanet database from the CalTech database (not necessary to do very oftern), run the notebook
ExopDBase.  Be sure to set the flag newImport to True, and back to False when you are done.  Will create a csv file
in exoplanetsMath/dbases named something like exopP_20180314_095329.csv, where it is a template filename of
exopP_XXX.csv where XXX is the datetime stamp YYYYMMDD_hhmmss.  Afterward the other notebooks will use this filename,
you just need to put it in there.
o Run the notebook GWStrainPlotsSNR to do the plot of the instantaneous GW modes for each exop vs the sqrt(time)
decreased S_n(f) curve; notebook also does the summation for the Signal-to-Noise for each exoplanet and the grabs the
few (10) brightests values.  Notebook is NOT increasing the h(m) strains in any way...maybe allowed but I do not see
it.

# exoplanets - Mathematica and other files to calculate the gravitational wave strain

Some of the Mathematica files used in the calculation of gravitational waves from exoplanets.  Oh and as of today bleeding edge version 11.2.0.0 .
Started GitHub repo on 20171010, by gabella.

Reorganized a very deranged and flat project.  The part I am sharing is the
Mathematica notebooks and maybe some python, to grab the Exoplanets database
at CalTech and to calculate the gravitational wave strength from those
planets.

My top directory (not in this repos) is ~/Documents/astro/exop/  and contains

* docs/   The PDFs for relevant papers, especially on eccentricity distributions of
        the exoplanets.
* exoplanetsMath/     The folder of Mathematica notebooks, *.dat and *.csv files, etc.
* notes/     Presentations summarizing the work, or other personal notes, not published
work.

In exoplanetsMath/  , this GitHub repository, there are the folders

* arch/
  Archives, usually old not useful documents that I am too afraid to delete, or
  I am unsure of their utility.
* dbases/
  The "databases" for this project, mostly the exoplanets csv files.
* pix/
  The generated images and pictures.  Also likely xmgrace files and *.dat
  that they use for formatting for a publication.
* python/
  I like python and ipython notebooks, so if I have any useful ones they are here.

The main notebook GWExopECC2.nb works for me but is still very long and not transparent.  
It creates several graphics in the pix directory.  It reads the exop CSV file from dbases
 unless you update that file by running the other notebook ExoDBase.nb .

I create the publication plot variety of ways including using XMgrace
on the data file(s) pix/tenYearsEccen.dat and pix/hfsRMS20bins.dat .





