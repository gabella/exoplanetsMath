# Python - Workflow

Python files and notebooks to calculate the strain (modes if eccentric) from binary orbit paramters.  The Python files live in exoplanetsMath/python .

* Start your Jupyter notebook.
* ExopDBase - Used to update a csv file of the CalTech exoplanets database.  Not necessary to do that often.
  Set the flag newImport = True to update the database.  Set it to False when you are done.  Creates a csv file
in exoplanetsMath/dbases named something like exopP_20180314_095329.csv .  Afterward the other notebooks will use this filename,
you just copy it in there.
* GWStrainPlotsSNR - does all the calculations using the functions defined in gwtools.py.  Specifically it calcs the instantaneous GW modes for each exop,
uses saved data for the S_N(f) noise curve to calculate the Signal-to-Noise for each exoplanet.  All this data is appended to the main Panda dataframe.
Makes a plot of the scaled S_N(f) curve for some integration time, to get approximate noise in dimensionless units, and plots the instantaneous strain for
all the exoplanets that have enough data for the calculation.  Near the end a table is made of the top SNR exoplanets (very small, but take in toto maybe an
annoyance to LISA measurements).

#  Mathematica and other files to calculate the gravitational wave strain, moved to ./mathematica

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




