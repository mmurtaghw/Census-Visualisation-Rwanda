# Census-Visualisation-Rwanda
Visualising 2012 census data associated with Covid-19 in Rwanda

### 1. Preparing Data

This project thus far uses two sources of data, which can be downloaded here:

1. Rwanda 2012 census microdata - https://microdata.statistics.gov.rw/index.php/catalog/65/related_materials
2. Rwanda sector level shapefile - https://datacatalog.worldbank.org/dataset/rwanda-admin-boundaries-and-villages/resource/2774ebf5-5b3e-43c1-912f-e2cee945d841

Note that you will need access to NADA in order to download the census microdata.

Unzip any compressed files and place them in the /data file of the project directory.

Rwanda has four subdivisions for administrative/statistical purposes. These are Provinces, Districts, Sectors and Cells. The data here 
is available at the sector level. There are 416 sectors.

Each province, district and sector has a code, which, once combined, uniquely identifies sectors. These identifiers are used to identify
each sector in the shapefile data. The same identifiers are present in the census data but are expressed as individual codes for each
province, district and sector. These variables in the census data therefore have to be combined in order to be merged with the shapefile.

To prepare this data for visualisation:

1. Open the RProj file
2. Run Census_Sector_Formatting.R
3. A new file, labelled FormattedCensusMicrodata.dta, will appear in the data folder

The data is now ready.

### 2. Running the Visualisation

Run "Vulnerability_Mapping.R". Run the setup section first and then choose whichever visualisation is necessary and run that
section of code.
