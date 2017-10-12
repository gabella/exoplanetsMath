# exoplanets - Mathematica and other files to calculate the gravitational wave strain

Some of the Mathematica files used in the calculation of gravitational waves from exoplanets.  Oh and as of today bleeding edge verions 11.2.0.0 .
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

I create the publication plot using XMgrace on the data file(s) pix/tenYearsEccen.dat and pix/hfsRMS20bins.dat .





