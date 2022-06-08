
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pkEML

<!-- badges: start -->
<!-- badges: end -->

A R package to convert Ecological Metadata Language (EML) documents to
tables, and, optionally, normalizes them into tables suited for import
into a relational database system, such as the LTER-core-metabase
schema. Data managers can use pkEML to aid migration of their metadata
archives, while researchers working on meta-analyses can use pkEML to
quickly gather metadata details from a large set of datasets. While
pkEML was developed with the LTER network in mind, any EML users may
find its functionalities useful.

How to say “pkEML”: spell out each letter. pk is meant to stand for
primary key, but one can also intepret as peak-EML or pack-EML.

## Installation

``` r
# Requires the remotes package
install.packages("remotes")
#> Installing package into 'C:/Software/Anaconda/Temp/RtmpYhuIxJ/temp_libpath44b471ba17f7'
#> (as 'lib' is unspecified)
remotes::install_github("atn38/pkEML")
#> Downloading GitHub repo atn38/pkEML@HEAD
#> Installing package into 'C:/Software/Anaconda/Temp/RtmpYhuIxJ/temp_libpath44b471ba17f7'
#> (as 'lib' is unspecified)
#> Warning in i.p(...): installation of package 'C:/Software/Anaconda/Temp/
#> RtmpqooxiO/file307453de7635/pkEML_0.1.0.tar.gz' had non-zero exit status
```

## How to use pkEML

``` r
library(pkEML)
```

### Step 1: Assemble a “corpus” of EML documents

A corpus of EML documents can correspond to a research program’s
metadata archives, or any set of assembled metadata documents. A corpus
is the unit of input data that pkEML operates on. So, if we are talking
about getting geographic coverage metadata, or any other metadata
element, the default is grabbing these things from *a whole corpus in
one go*. You can of course use pkEML to grab metadata from a single EML
document, but there are perhaps other methods to do so, such as the
package metajam from NCEAS, or the function `purrr::pluck()`.

pkEML has a function to quickly and conveniently download all EML
documents from an Environment Data Initiative (EDI) repository’s
“scope”:

``` r
pkEML::download_corpus(scope = "knb-lter-ble", path = getwd())
#> Querying EDI for latest data identifiers...
#> Starting download:
#> Writing file knb-lter-ble.1.7.xml to path.
#> Writing file knb-lter-ble.2.4.xml to path.
#> Writing file knb-lter-ble.3.1.xml to path.
#> Writing file knb-lter-ble.4.1.xml to path.
#> Writing file knb-lter-ble.5.4.xml to path.
#> Writing file knb-lter-ble.6.1.xml to path.
#> Writing file knb-lter-ble.7.4.xml to path.
#> Writing file knb-lter-ble.8.7.xml to path.
#> Writing file knb-lter-ble.9.1.xml to path.
#> Writing file knb-lter-ble.10.1.xml to path.
#> Writing file knb-lter-ble.11.1.xml to path.
#> Writing file knb-lter-ble.12.1.xml to path.
#> Writing file knb-lter-ble.13.1.xml to path.
#> Writing file knb-lter-ble.14.3.xml to path.
#> Writing file knb-lter-ble.15.1.xml to path.
#> Writing file knb-lter-ble.16.1.xml to path.
#> Writing file knb-lter-ble.17.1.xml to path.
#> Writing file knb-lter-ble.18.2.xml to path.
#> Writing file knb-lter-ble.19.1.xml to path.
#> Writing file knb-lter-ble.22.1.xml to path.
#> Writing file knb-lter-ble.23.1.xml to path.
#> Done.
```

This downloads into the specified directory all EML documents from the
most recent revisions of datasets under the “knb-lter-ble” scope in EDI,
which is the Beaufort Lagoon Ecosystems LTER program.

If working with a more heterogeneous set, use your favorite method to
download the EML documents into a directory.

### Step 2: Import the EML corpus into R

``` r
emls <- import_corpus(path = getwd())
#> Starting import...
#> Getting packageIds to use as names...
#> Checking for duplicate Ids...
#> Done.
```

`import_corpus` outputs a nested list of EML documents represented under
the `emld` format. Each list item is a EML document and named after the
full packageId in the metadata body (not the .xml file name in the
directory).

### Step 3: Convert EML corpus to tables

``` r
dfs <- EML2df(corpus = emls)
#> Getting datasets...
#>     Returning 21 rows.
#> Getting data entities...
#>     Returning 75 rows.
#> Getting entity attributes...
#>     Returning 1060 rows.
#> Getting attribute enumeration and missing codes...
#>     Returning 287 rows.
#> Getting keywordSet ...
#>     Returning 469 rows.
#> Getting changeHistory ...
#>     Returning 21 rows.
#> Getting geographicCoverage ...
#>     Returning 58 rows.
#> Getting temporalCoverage ...
#>     Returning 19 rows.
#> Getting taxonomicCoverage ...
#>     Returning 0 rows.
#> Getting project ...
#>     Returning 21 rows.
#> Getting annotation ...
#>     Returning 182 rows.
#> Getting methodStep ...
#>     Returning 22 rows.
```

`dfs` is a nested list of data.frames. Each data.frame will contain
assembled information from all your datasets, each on key metadata
groups such as dataset-level information, entity-level, attribute-level,
attribute codes (enumeration and missing),
geographical/temporal/taxonomic coverage, and so on. These data.frames
are de-normalized, meaning all occurrences in EML are recorded and there
may be loads of repeated information. For example, key personnel from
your research program will be listed as contributors on many datasets,
core sampling locations will be listed many times, and so on.

``` r
head(dfs)
#> $datasets
#>             packageId        scope datasetid revision_number
#>  1:  knb-lter-ble.1.7 knb-lter-ble         1               7
#>  2: knb-lter-ble.10.1 knb-lter-ble        10               1
#>  3: knb-lter-ble.11.1 knb-lter-ble        11               1
#>  4: knb-lter-ble.12.1 knb-lter-ble        12               1
#>  5: knb-lter-ble.13.1 knb-lter-ble        13               1
#>  6: knb-lter-ble.14.3 knb-lter-ble        14               3
#>  7: knb-lter-ble.15.1 knb-lter-ble        15               1
#>  8: knb-lter-ble.16.1 knb-lter-ble        16               1
#>  9: knb-lter-ble.17.1 knb-lter-ble        17               1
#> 10: knb-lter-ble.18.2 knb-lter-ble        18               2
#> 11: knb-lter-ble.19.1 knb-lter-ble        19               1
#> 12:  knb-lter-ble.2.4 knb-lter-ble         2               4
#> 13: knb-lter-ble.22.1 knb-lter-ble        22               1
#> 14: knb-lter-ble.23.1 knb-lter-ble        23               1
#> 15:  knb-lter-ble.3.1 knb-lter-ble         3               1
#> 16:  knb-lter-ble.4.1 knb-lter-ble         4               1
#> 17:  knb-lter-ble.5.4 knb-lter-ble         5               4
#> 18:  knb-lter-ble.6.1 knb-lter-ble         6               1
#> 19:  knb-lter-ble.7.4 knb-lter-ble         7               4
#> 20:  knb-lter-ble.8.7 knb-lter-ble         8               7
#> 21:  knb-lter-ble.9.1 knb-lter-ble         9               1
#>             packageId        scope datasetid revision_number
#>                                                                                                                                                                                                              title
#>  1:                                                                                                      Carbon flux from aquatic ecosystems of the Arctic Coastal Plain along the Beaufort Sea, Alaska, 2010-2018
#>  2:      Catalog of GenBank sequence read archive (SRA) entries of 16S and 18S rRNA genes from bacterial and protistan planktonic communities along the Eastern Beaufort Sea coast, North Slope, Alaska, 2011-2013
#>  3:                 Carbon and nitrogen content and stable isotope compositions from particulate organic matter samples from lagoon, river, and open ocean sites along the Alaska Beaufort Sea coast, 2018-ongoing
#>  4:                                                                                                            Sediment pigment concentrations from lagoon sites along the Alaska Beaufort Sea coast, 2018-ongoing
#>  5:                                                                                  Water column chlorophyll concentrations from lagoon, river, and ocean sites along the Alaska Beaufort Sea coast, 2018-ongoing
#>  6:                                                              Water column and sediment porewater nutrient concentrations from lagoon, river, and ocean sites along the Alaska Beaufort Sea coast, 2018-ongoing
#>  7:                                                                       Colored dissolved organic matter (CDOM) absorbance from lagoon, ocean, and river sites along the Alaska Beaufort Sea coast, 2019-ongoing
#>  8:                                                                                                                          Flow direction grid at 1 kilometer resolution for North Slope drainage basins, Alaska
#>  9:                                                                                                             Geochemical characterization and material properties of coastal permafrost near Drew Point, Alaska
#> 10:                                                    Carbon and nitrogen content and stable isotope composition from sediment organic matter from lagoon sites along the Alaska Beaufort Sea coast, 2018-ongoing
#> 11: Catalog of GenBank sequence read archive (SRA) entries of metagenomic DNA sequence analyses of bacterial and archaeal water column communities along the Eastern Beaufort Sea coast, North Slope, Alaska, 2012
#> 12:                                                   Dissolved organic carbon (DOC) and total dissolved nitrogen (TDN) from river, lagoon, and open ocean sites along the Alaska Beaufort Sea coast, 2018-ongoing
#> 13:                                                                                                                         Near-shore bathymetry for Elson Lagoon and Chukchi Sea, Barrow Region, northern Alaska
#> 14:                                                                               Model estimates of runoff, dissolved organic carbon, soil temperature and moisture for Elson Lagoon watershed, Alaska, 1981-2020
#> 15:                                                 Physiochemical water column parameters and hydrographic time series from river, lagoon, and open ocean sites along the Alaska Beaufort Sea coast, 2018-ongoing
#> 16:                                                                    Stable oxygen isotope ratios of water (H2O-d18O) from river, lagoon, and open ocean sites along the Alaska Beaufort Sea coast, 2019-ongoing
#> 17:                                                                                                                   Model simulated hydrological estimates for the North Slope drainage basin, Alaska, 1980-2010
#> 18:                                                                                      Photosynthetically active radiation (PAR) time series from lagoon sites along the Alaska Beaufort Sea coast, 2018-ongoing
#> 19:                                                                Circulation dynamics: currents, waves, temperature measurements from moorings in lagoon sites along the Alaska Beaufort Sea coast, 2018-ongoing
#> 20:                                                                                               Seasonal Ice Mass-balance Buoy (SIMB) measurements from sites along the Beaufort Sea Coast, Alaska, 2018-ongoing
#> 21:                                                                                                             Time series of water column pH from lagoon sites along the Alaska Beaufort Sea coast, 2018-ongoing
#>                                                                                                                                                                                                              title
#>     shortname
#>  1:        NA
#>  2:        NA
#>  3:        NA
#>  4:        NA
#>  5:        NA
#>  6:        NA
#>  7:        NA
#>  8:        NA
#>  9:        NA
#> 10:        NA
#> 11:        NA
#> 12:        NA
#> 13:        NA
#> 14:        NA
#> 15:        NA
#> 16:        NA
#> 17:        NA
#> 18:        NA
#> 19:        NA
#> 20:        NA
#> 21:        NA
#>     shortname
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           abstract
#>  1:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              Multiple aquatic ecosystems (pond, lake, river, lagoon, ocean) on the Arctic Coastal Plain (ACP) near Utqiagvik, AK were visited to determine their relative contribution to landscape-level atmospheric CO2 flux and how this may have changed over time. pCO2 (partial pressure of carbon dioxide) was monitored in late summer (late July to mid-August) over a period of four years (2013, 2015, 2017, 2018) from open water areas and is related to habitat type, dissolved organic carbon (DOC) and environmental factors (temperature, radiation, rainfall). Data include both daily averages from most sites, as well as spatial representation of pCO2 in Elson Lagoon and diel cycles of pCO2 from a tundra pond. Pond NEP (net ecosystem production) is estimated by free water metabolism and presented as daily estimates over a four summer period.
#>  2:                                                                                                                                                       <?xml version="1.0" encoding="UTF-8"?>\n\n  <para>Microbial communities in the coastal Arctic Ocean experience extreme variability in organic matter and inorganic nutrients driven by seasonal shifts in sea ice extent and freshwater inputs. Lagoons border more than half of the Beaufort Sea coast and provide important habitats for migratory fish and seabirds; yet, little is known about the planktonic food webs supporting these higher trophic levels. To investigate seasonal changes in bacterial and protistan planktonic communities, amplicon sequences of 16S and 18S rRNA genes were generated from samples collected during periods of ice-cover (April), ice break-up (June), and open water (August) from shallow lagoons along the eastern Alaska Beaufort Sea coast from 2011 through 2013.\n</para>\n  <para>\nThis data package catalogs sequence read archive (SRA) entries available through GenBank BioProject PRJNA530074 at https://www.ncbi.nlm.nih.gov/bioproject/PRJNA530074. This data package is associated with the following publication:\n</para>\n  <para>\nKellogg CTE, McClelland JW, Dunton KH and Crump BC (2019) Strong Seasonality in Arctic Estuarine Microbial Food Webs. Front. Microbiol. 10:2628. doi: 10.3389/fmicb.2019.02628\n</para>\n  <para>\nEnvironmental variables (physiochemical data from YSI and HOBO data loggers, as well as organic matter analysis and stable isotope data from discrete water samples) associated with this genomic dataset are available from the Arctic Data Center:\n</para>\n  <para>\nKenneth Dunton, Byron Crump, and James McClelland. Physical, chemical, and biological data from lagoons and open coastal waters in the nearshore environment of the eastern Alaska Beaufort Sea, 2011-2013. Arctic Data Center. doi:10.18739/A2DG13. \n</para>\n  <para>\nTo join the two datasets together, please use the provided site codes (column "site_name" here) and collection dates (column "collection_date" here) in each dataset. Note that the site codes in this package are without hyphens (e.g. JAA) while site codes in the above environmental data package have hyphens (e.g. JA-A).\n</para>\n  <para>\nInstead of citing this package which is just a catalog, please cite the original GenBank data, journal article, or related Arctic Data Center dataset as appropriate. Citation guidance for the journal article and related Arctic Data Center dataset is available on the respective publishers' websites.\n</para>\n\n
#>  3:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  Multiple water types (river, lagoon, ocean) from the North Slope of Alaska and nearshore Beaufort Sea are sampled seasonally by the Beaufort Lagoon Ecosystems LTER (BLE LTER) Core Program to investigate biogeochemical linkages between terrestrial, lagoon, and open ocean ecosystems. Water samples are collected during full ice cover (April), ice break-up (mid-June to early July), and open water (late July and August) periods, and analyzed for particulate organic carbon (POC) and particulate organic nitrogen (PON) content and stable isotopic composition.
#>  4:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 <?xml version="1.0" encoding="UTF-8"?>\n\n  <para>\nThe Beaufort Lagoon Ecosystems Long Term Ecological Research (BLE LTER) project seasonally collects undisturbed surface sediments during full ice cover (April), ice break-up (mid-June to early July), and open water (late July and August) periods from lagoon sites along the Beaufort Sea (Elson, Simpson, Jago, and Kaktovik lagoons, plus Stefansson Sound) to quantify algal pigment concentrations. Pigments reported are chlorophyll a, pheophorbide, pheophytin, chlorophyllide, fucoxanthin, zeaxanthin, alloxanthin, and peridinin. Pigment concentrations are measured using high-precision liquid chromatography (HPLC). Concentrations are represented both as an areal basis (mg/m<superscript>2</superscript> of surface sediment) and a mass basis (µg/g of dry sediment).\n</para>\n\n
#>  5:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            Multiple water types (river, lagoon, ocean) from the North Slope of Alaska and nearshore Beaufort Sea are sampled seasonally by the Beaufort Lagoon Ecosystems LTER (BLE LTER) Core Program to investigate biogeochemical linkages between terrestrial, lagoon, and open ocean ecosystems. Water samples from multiple depths are collected during full ice cover (April), ice break-up (mid-June to early July), and open water (late July and August) periods for quantification of chlorophyll-a concentrations. Concentrations are reported in micrograms of chlorophyll per liter of filtered seawater (µg/L).
#>  6:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            Several water types (lagoon, river, ocean) and surface sediment porewater from the coastal Beaufort Sea system are sampled seasonally to investigate temporal and spatial shifts in nutrient dynamics. Surface and bottom water samples, and surface sediment samples are collected during full ice cover (April), ice break-up (mid-June to early July), and open water (late July and August) periods, and analyzed for ammonia, nitrate + nitrite, orthophosphate, and silicate concentrations. 
#>  7:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 Multiple water types (river, lagoon, ocean) from the North Slope of Alaska and nearshore Beaufort Sea are sampled seasonally by the Beaufort Lagoon Ecosystems LTER (BLE LTER) Core Program to investigate biogeochemical linkages between terrestrial, lagoon, and open ocean ecosystems. Water samples from multiple depths are collected during full ice cover (April), ice break-up (mid-June to early July), and open water (late July and August) periods, filtered, and analyzed for light absorption spectra within 24 hours of collection. Wavelength-specific light absorption coefficients are reported between 200 and 800 nanometers. The data is organized in "long" or "tidy" format, with columns of station, date, wavelength, and absorption. Please see included MakeColumnsAsWavelengths.R, MakeColumnsAsDates.R, and ReshapeDataInExcel.txt for some common ways to reorganize the table for further CDOM analysis. Please see the Methods section for cautionary notes on data from sampling year 2019. 
#>  8:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            We derived and evaluated a 1 kilometer spatial resolution flow direction grid for the terrestrial drainage of the North Slope of Alaska. The region is resolved by 182,722 grid cells and the associated connectivity. It is bounded by the Brooks Range and Beaufort Sea coast, and extends from the northern Chukchi Sea coast eastward to the small rivers near 140 degrees West. The dataset is provided in raster and tabular format, with the latter including coordinates, river basin identifier, and downstream reach and direction for each grid cell in the region. Over three dozen river basins are identified by name in an associated lookup table. This new mapping resolves the terrestrial drainages for rivers exporting freshwater, nutrients, and other materials to Elson, Simpson, Jago, Kaktovik, and other coastal lagoons at a resolution that captures important processes linked to surface and subsurface hydrological flows. Our analysis suggests that the mapping exhibits notable similarity in basin area boundaries relative to the benchmark USGS National Hydrography Dataset.
#>  9:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             <?xml version="1.0" encoding="UTF-8"?>\n\n  <para>\nPermafrost cores (4.5-7.5 m long) were collected April 10th-19th, 2018, along a geomorphic gradient near Drew Point, Alaska to characterize active layer and permafrost geochemistry and material properties. Cores were collected from a young drained lake basin, an ancient drained lake basin, and primary surface that has not been reworked by thaw lake cycles. Measurements of total organic carbon (TOC) and total nitrogen (TN) content, stable carbon isotope ratios (d<superscript>13</superscript>C) and radiocarbon (<superscript>14</superscript>C) analyses of bulk soils/sediments were conducted on 45 samples from 3 permafrost cores. Porewaters were extracted from these same core sections and used to measure salinity, dissolved organic carbon (DOC), total dissolved nitrogen (TDN), anion (Cl<superscript>-</superscript>, Br<superscript>-</superscript>, SO<subscript>4</subscript>\n        <superscript>2-</superscript>, NO<subscript>3</subscript>\n        <superscript>-</superscript>), and trace metal (Ca, Mn, Al, Ba, Sr, Si, and Fe) concentrations. Radiogenic strontium (<superscript>87</superscript>Sr/<superscript>86</superscript>Sr) was measured on a subset of porewater samples. Cores were also sampled for material property measurements such as dry bulk density, water content, and grain size fractions.\n</para>\n\n
#> 10:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 Multiple sediment samples from lagoons along the nearshore Beaufort Sea are sampled seasonally by the Beaufort Lagoon Ecosystems LTER (BLE LTER) Core Program to investigate biogeochemical linkages between terrestrial, lagoon, and open ocean ecosystems. Sediment samples are collected during full ice cover (April), ice break-up (mid-June to early July), and open water (late July and August) periods, and analyzed for carbon and nitrogen content and stable isotopic composition.
#> 11: <?xml version="1.0" encoding="UTF-8"?>\n\n  <para>In contrast to temperate systems, Arctic lagoons that span the Alaska Beaufort Sea coast face extreme seasonality. Nine months of ice cover up to ~1.7 m thick is followed by a spring thaw that introduces an enormous pulse of freshwater, nutrients, and organic matter into these lagoons over a relatively brief 2–3 week period. Prokaryotic communities link these subsidies to lagoon food webs through nutrient uptake, heterotrophic production, and other biogeochemical processes, but little is known about how the genomic capabilities of these communities respond to seasonal variability. This study characterizes the metabolic capabilities of microbial communities across three seasons in two lagoons and one open coastal site along the eastern Alaska Beaufort Sea coast. We used metagenomic DNA sequence data of bacterial and archaeal water column communities to identify genes of relevant biogeochemical pathways.\n</para>\n  <para>\nThis data package catalogs sequence read archive (SRA) entries available through GenBank BioProject PRJNA642637 at https://www.ncbi.nlm.nih.gov/bioproject/PRJNA642637. This data package is associated with the following publication:\n</para>\n  <para>\nBaker, Kristina D., Colleen T. E. Kellogg, James W. McClelland, Kenneth H. Dunton, and Byron C. Crump. “The Genomic Capabilities of Microbial Communities Track Seasonal Variation in Environmental Conditions of Arctic Lagoons.” Frontiers in Microbiology 12 (2021). https://doi.org/10.3389/fmicb.2021.601901.\n</para>\n  <para>\nEnvironmental variables (physiochemical data from YSI and HOBO data loggers, as well as organic matter analysis and stable isotope data from discrete water samples) associated with this genomic dataset are available from the Arctic Data Center:\n</para>\n  <para>\nKenneth Dunton, Byron Crump, and James McClelland. Physical, chemical, and biological data from lagoons and open coastal waters in the nearshore environment of the eastern Alaska Beaufort Sea, 2011-2013. Arctic Data Center. doi:10.18739/A2DG13. \n</para>\n  <para>\nTo join the two datasets together, please use the provided site codes (column "site_name" here) and collection dates (column "collection_date" here) in each dataset.\n</para>\n  <para>\nInstead of citing this package, which is a catalog, please cite the original GenBank data, journal article, or related Arctic Data Center dataset as appropriate. Citation guidance for the journal article and related Arctic Data Center dataset is available on the respective publishers' websites.\n</para>\n\n
#> 12:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     Multiple water types (river, lagoon, ocean) from the North Slope of Alaska and nearshore Beaufort Sea are sampled seasonally by the Beaufort Lagoon Ecosystems LTER (BLE LTER) Core Program to investigate biogeochemical linkages between terrestrial, lagoon, and open ocean ecosystems. Water samples are collected during full ice cover (April), ice break-up (mid-June to early July), and open water (late July and August) periods and analyzed for dissolved organic carbon and total dissolved nitrogen content.
#> 13:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            This dataset includes bathymetric sounding points for the near-shore regions of the Chukchi Sea and Elson Lagoon (Beaufort Sea) for the Barrow region of northern Alaska, along with a bathymetric surface interpolated from these sounding points. Bathymetric surveying was conducted during July and August of 2015 with high-resolution dGPS and single beam sonar. Surveys were conducted on an inflatable Achilles boat with the dGPS antenna and echo sounder placed (on the same pole) off to one side of the boat. dGPS and sonar data were logged on different platforms that were then time-synced later. Sounding points follow the path of the survey boat. At any one sounding point; water depth, bottom elevation, bottom ellipsoid height among other fields are given. Sounding point depths were corrected for salinity and temperature. The average horizontal precision for any one sounding point is 2.3 cm. The average vertical precision for any one sounding point is 4.6 cm (dGPS uncertainty) plus 0.1% of depth (sonar manufacturers stated accuracy). The 10m resolution interpolated surface was created with the Topo to Raster tool within the 3D Analyst license for ArcGIS for Desktop. Pixel values reflect water depth in meters. Related datasets include: recent digital shorelines from dGPS survey, long-term shorelines digitized from imagery and results of coastal change analysis (annual and long-term rates of erosion or accretion). This bathymetric data may be of interest to land managers, scientist and engineers for modeling storm surge effects and coastal erosion. This dataset was collected as part of the Barrow Area Information Database (BAID, https://barrowmapped.org) and was originally made available on the BAID project website. In 2021/2022 the dataset was edited in metadata only and repackaged for archival on the Environmental Data Initiative repository by the Beaufort Lagoon Ecosystems LTER. 
#> 14:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 This dataset contains model estimates of dissolved organic carbon (DOC) yield (mg C/m^2) and runoff (mm), for surface and subsurface flows, soil temperature (degree C), and soil moisture (% of soil volume) for grid cells spanning the Elson Lagoon watershed in northwest Alaska. Daily air temperature, precipitation, and wind speed data from Utqiagvik airport were used for meteorological forcings for the daily simulation by the Permafrost Water Balance Model (PWBM) from 1981 to 2020. The DOC and runoff data files are organized by grid cell and month. The soil temperature and soil moisture files are organized by grid cell and day of year (DOY), and contain values for the first eight model soil layers, with centers of the layers at 1, 3, 8, 13, 23, 33, 45, 55 cm depth. The estimates are most useful for analyses of the dynamics of the watershed’s surface and subsurface runoff and DOC yield. Leachate DOC concentrations can be obtained using the gridded runoff and yield values. A manuscript describing the data and associated analysis has been accepted for publication in Environmental Research Letters (Rawlins et al., 2021). 
#> 15:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      To understand circulation and seasonality as part of the Beaufort Lagoon Ecosystem Long Term Ecological Research program, temperature, conductivity, salinity, pressure, depth, and current velocity are recorded hourly in situ, starting August 2018 in lagoons across the Beaufort Sea coast (Elson Lagoon, Kaktovik Lagoon, and Jago Lagoon). Moorings include combinations of 1) RBR Concerto CTDs with temperature, conductivity, and pressure sensors; 2) StarOddi CTs with temperature and conductivity sensors; and 3) Lowell TCM-1 Tilt Current meters with MAT-1 Data Loggers for velocity and bearing. In addition, during BLE LTER's annual sampling, water column physiochemical parameters (chlorophyll a, dissolved oxygen, phycoerythrin concentration, pH, temperature, conductivity, salinity) are measured by hand with a YSI data sonde at river, lagoon, and open ocean sites along the Beaufort Sea coast. Here we provide both raw and quality controlled in situ mooring data, the R scripts used for processing, and all YSI sonde data plus a subset used to calibrate and validate the in situ mooring data. 
#> 16:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                Multiple water types (river, lagoon, ocean) from the North Slope of Alaska and nearshore Beaufort Sea are sampled seasonally by the Beaufort Lagoon Ecosystems LTER (BLE LTER) Core Program to investigate biogeochemical linkages between terrestrial, lagoon, and open ocean ecosystems. Water samples are collected during full ice cover (April), ice break-up (mid-June to early July), and open water (late July and August) periods, and analyzed for delta 18O (ratio of oxygen-18 to oxygen-16) to use in mixing models for source water contribution.
#> 17:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            Estimates of runoff, river discharge, snow water equivalent (SWE), subsurface runoff, and soil temperatures are drawn from the Permafrost Water Balance Model (PWBM). The simulation and derived data span the period 1980-2010. The model was forced with daily gridded meteorological data obtained from the Modern-Era Retrospective analysis for Research and Applications (MERRA) reanalysis (version 5.2.0). The estimates of total runoff (daily), soil temperature (daily), subsurface runoff (monthly), and SWE (monthly) are expressed on a spatial grid (N=312; 25x25 km EASE-Grid version 1, Northern Hemisphere) over the North Slope drainage basin, with the coastline extending from Utqiagvik (formerly Barrow) to just west of the Mackenzie River delta. River discharge, calculated as a volume flux of runoff at each grid cell, was routed through the river network defined on a simulated topological network (STN). Archived files contain discharge flux through the grid cell representing the outlet of each of forty-two basins defined across the region on the 25 km resolution EASE-Grid. Details of the PWBM, forcing variables, model validation and results of analysis are described in Rawlins et al. (2019). 
#> 18:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          To understand seasonality and production as part of the Beaufort Lagoon Ecosystem Long Term Ecological Research program, photosynthetically active radiation (PAR) is recorded in situ, starting August 2018 across the Beaufort Sea coast. Spherical quantum sensors measure PAR ~0.5 m above the benthos at underwater mooring locations and cosine sensors measure incident PAR at the surface at a permanent land-based station. 
#> 19:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     Starting August 2018, five moorings deployed on the seafloor of multiple lagoons in the Beaufort Sea will record currents, waves, temperature, and pressure. Moorings are retrieved and re-deployed each August. This data is being collected to better understand the multi-seasonal circulation dynamics between the Beaufort Sea and coastal lagoons. Two moorings are deployed in Elson Lagoon, one in Stefansson Sound, one in Jago Lagoon, and one in Kaktovik Lagoon. Each mooring contains two data loggers: RBRduo3 T.D wave loggers and Lowell Instruments LLC TCM-1 tilt current meters. The RBR instruments measure temperature, pressure, and derived wave energy, average wave period, average wave height, maximum wave period, maximum wave height, 1/10 wave period, 1/10 wave height, significant wave period, significant wave height, tidal slope, depth, and sea pressure. The Lowell LLC TML-1 tilt current meters measure water velocity, heading, and temperature.
#> 20:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  <?xml version="1.0" encoding="UTF-8"?>\n\n  <para>\nMeasurements of the thickness of sea ice and the depth of its snow cover allow us to calculate how their mass changes in response to the varying fluxes of heat between the ocean and atmosphere over the course of a season. Repeated drill measurements are not ideal for this purpose since each drill hole disturbs the ice and its insulating snow cover. Also, spatial variability in ice thickness can mask temporal changes if holes are not drilled in the same place each time. Hence, methods that do not require re-drilling are preferred. Automated systems such as the Seasonal Ice Mass-balance Buoy (SIMB;  Planck et al, 2019) provide high temporal resolution for capturing sub-daily variations and typically include sensor strings to measure the vertical temperature profile from the air to the ocean, which can be used to infer other properties of the ice cover such as strength and porosity. \n</para>\n  <para>\nUnder the Beaufort Lagoon Ecosystems LTER (BLE LTER) research program, several SIMBs are deployed at sites along the Beaufort Sea coast and record a suite of parameters including but not limited to snow depth, ice thickness, position of ice surface and bottom, water/air temperature, and vertical profiles of temperature.\n\n</para>\n  <para>\nPlanck, C. J., J. Whitlock, C. Polashenski, and D. Perovich (2019), The evolution of the seasonal ice mass balance buoy, Cold Regions Science and Technology, 165, 102792, doi: https://doi.org/10.1016/j.coldregions.2019.102792.\n</para>\n\n
#> 21:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      Beginning in August 2018, the Beaufort Lagoon Ecosystems Long Term Ecological Research (BLE LTER) program will record water column pH time series (hourly) from a benthic mooring containing a Seabird SeaFET V2 buoyed 10 cm from the lagoon seafloor. pH values are logged from the instrument’s internal sensor and reported on the total hydrogen ion scale. Site bottom water is collected and analyzed in the laboratory to employ a single point calibration to the data during post-processing. Another discrete water sample is collected months after instrument deployment to determine uncertainty (2018-2019 season: 0.002).
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           abstract
#>     abstract_type
#>  1:     plaintext
#>  2:       docbook
#>  3:     plaintext
#>  4:       docbook
#>  5:     plaintext
#>  6:     plaintext
#>  7:     plaintext
#>  8:     plaintext
#>  9:       docbook
#> 10:     plaintext
#> 11:       docbook
#> 12:     plaintext
#> 13:     plaintext
#> 14:     plaintext
#> 15:     plaintext
#> 16:     plaintext
#> 17:     plaintext
#> 18:     plaintext
#> 19:     plaintext
#> 20:       docbook
#> 21:     plaintext
#>     abstract_type
#>                                                                                    maintenance_description
#>  1:                                                                          No regular updates scheduled.
#>  2:                                                                        No regular updates anticipated.
#>  3: Dataset will be updated every year, normally scheduled for the fall and spring following field season.
#>  4: Dataset will be updated every year, normally scheduled for the fall and spring following field season.
#>  5: Dataset will be updated every year, normally scheduled for the fall and spring following field season.
#>  6: Dataset will be updated every year, normally scheduled for the fall and spring following field season.
#>  7: Dataset will be updated every year, normally scheduled for the fall and spring following field season.
#>  8:                                                                        No regular updates anticipated.
#>  9:                                                                        No regular updates anticipated.
#> 10: Dataset will be updated every year, normally scheduled for the fall and spring following field season.
#> 11:                                                                        No regular updates anticipated.
#> 12:                                                                    Dataset will be updated every year.
#> 13:                                                                        No regular updates anticipated.
#> 14:                                                                        No regular updates anticipated.
#> 15: Dataset will be updated every year, normally scheduled for the fall and spring following field season.
#> 16: Dataset will be updated every year, normally scheduled for the fall and spring following field season.
#> 17:                                                                        No regular updates anticipated.
#> 18: Dataset will be updated every year, normally scheduled for the fall and spring following field season.
#> 19: Dataset will be updated every year, normally scheduled for the fall and spring following field season.
#> 20: Dataset will be updated every year, normally scheduled for the fall and spring following field season.
#> 21: Dataset will be updated every year, normally scheduled for the fall and spring following field season.
#>                                                                                    maintenance_description
#>     maintenance_update_frequency
#>  1:                   notPlanned
#>  2:                   notPlanned
#>  3:                     annually
#>  4:                     annually
#>  5:                     annually
#>  6:                     annually
#>  7:                     annually
#>  8:                   notPlanned
#>  9:                   notPlanned
#> 10:                     annually
#> 11:                   notPlanned
#> 12:                     annually
#> 13:                   notPlanned
#> 14:                   notPlanned
#> 15:                     annually
#> 16:                     annually
#> 17:                   notPlanned
#> 18:                     annually
#> 19:                     annually
#> 20:                     annually
#> 21:                     annually
#>     maintenance_update_frequency
#> 
#> $entities
#>            scope datasetid rev entity  entitytype
#>  1: knb-lter-ble         1   7     11   dataTable
#>  2: knb-lter-ble         1   7     12   dataTable
#>  3: knb-lter-ble         1   7     13   dataTable
#>  4: knb-lter-ble         1   7     14   dataTable
#>  5: knb-lter-ble        10   1     11   dataTable
#>  6: knb-lter-ble        11   1     11   dataTable
#>  7: knb-lter-ble        11   1     12   dataTable
#>  8: knb-lter-ble        12   1     11   dataTable
#>  9: knb-lter-ble        12   1     12   dataTable
#> 10: knb-lter-ble        13   1     11   dataTable
#> 11: knb-lter-ble        13   1     12   dataTable
#> 12: knb-lter-ble        14   3     11   dataTable
#> 13: knb-lter-ble        14   3     12   dataTable
#> 14: knb-lter-ble        14   3     13   dataTable
#> 15: knb-lter-ble        14   3     14   dataTable
#> 16: knb-lter-ble        15   1     11   dataTable
#> 17: knb-lter-ble        15   1     12   dataTable
#> 18: knb-lter-ble        15   1     21 otherEntity
#> 19: knb-lter-ble        15   1     22 otherEntity
#> 20: knb-lter-ble        15   1     23 otherEntity
#> 21: knb-lter-ble        16   1     11   dataTable
#> 22: knb-lter-ble        16   1     12   dataTable
#> 23: knb-lter-ble        16   1     21 otherEntity
#> 24: knb-lter-ble        17   1     11   dataTable
#> 25: knb-lter-ble        17   1     12   dataTable
#> 26: knb-lter-ble        18   2     11   dataTable
#> 27: knb-lter-ble        18   2     12   dataTable
#> 28: knb-lter-ble        19   1     11   dataTable
#> 29: knb-lter-ble         2   4     11   dataTable
#> 30: knb-lter-ble         2   4     12   dataTable
#> 31: knb-lter-ble        22   1     11 otherEntity
#> 32: knb-lter-ble        22   1     12 otherEntity
#> 33: knb-lter-ble        23   1     11   dataTable
#> 34: knb-lter-ble        23   1     12   dataTable
#> 35: knb-lter-ble        23   1     13   dataTable
#> 36: knb-lter-ble         3   1     11   dataTable
#> 37: knb-lter-ble         3   1     12   dataTable
#> 38: knb-lter-ble         3   1     13   dataTable
#> 39: knb-lter-ble         3   1     14   dataTable
#> 40: knb-lter-ble         3   1     15   dataTable
#> 41: knb-lter-ble         3   1     16   dataTable
#> 42: knb-lter-ble         3   1     17   dataTable
#> 43: knb-lter-ble         3   1     18   dataTable
#> 44: knb-lter-ble         3   1     19   dataTable
#> 45: knb-lter-ble         3   1     21 otherEntity
#> 46: knb-lter-ble         3   1     22 otherEntity
#> 47: knb-lter-ble         3   1     23 otherEntity
#> 48: knb-lter-ble         3   1     24 otherEntity
#> 49: knb-lter-ble         4   1     11   dataTable
#> 50: knb-lter-ble         4   1     12   dataTable
#> 51: knb-lter-ble         5   4     11   dataTable
#> 52: knb-lter-ble         5   4     12   dataTable
#> 53: knb-lter-ble         5   4     13   dataTable
#> 54: knb-lter-ble         5   4     14   dataTable
#> 55: knb-lter-ble         5   4     15   dataTable
#> 56: knb-lter-ble         5   4     16   dataTable
#> 57: knb-lter-ble         5   4     17   dataTable
#> 58: knb-lter-ble         5   4     21 otherEntity
#> 59: knb-lter-ble         6   1     11   dataTable
#> 60: knb-lter-ble         6   1     12   dataTable
#> 61: knb-lter-ble         6   1     13   dataTable
#> 62: knb-lter-ble         6   1     14   dataTable
#> 63: knb-lter-ble         7   4     11   dataTable
#> 64: knb-lter-ble         7   4     12   dataTable
#> 65: knb-lter-ble         7   4     13   dataTable
#> 66: knb-lter-ble         7   4     14   dataTable
#> 67: knb-lter-ble         7   4     21 otherEntity
#> 68: knb-lter-ble         7   4     22 otherEntity
#> 69: knb-lter-ble         7   4     23 otherEntity
#> 70: knb-lter-ble         8   7     11   dataTable
#> 71: knb-lter-ble         8   7     12   dataTable
#> 72: knb-lter-ble         8   7     13   dataTable
#> 73: knb-lter-ble         8   7     21 otherEntity
#> 74: knb-lter-ble         9   1     11   dataTable
#> 75: knb-lter-ble         9   1     12   dataTable
#>            scope datasetid rev entity  entitytype
#>                                                                                              entityname
#>  1:                                                                                     Regional survey
#>  2:                                                                           Elson 2015 spatial survey
#>  3:                                                                                IBP C diel pCO2 data
#>  4:                                                                                     IBP C Daily NEP
#>  5:                                Catalog of genomic data archived on GenBank from Kellogg et al. 2019
#>  6:                                               Stable isotopes from particulate organic matter (POM)
#>  7:                               Stable isotopes from particulate organic matter (POM), personnel list
#>  8:                                                                     Sediment pigment concentrations
#>  9:                                                               Sediment pigment data, personnel list
#> 10:                                                           Water column chlorophyll-a concentrations
#> 11:                                                       Water column chlorophyll data, personnel list
#> 12:                                                                          Water column nutrient data
#> 13:                                                                    Sediment porewater nutrient data
#> 14:                                                                      Chemistry analysis information
#> 15:                                             Water column and sediment nutrient data, personnel list
#> 16:                                                                               CDOM absorption scans
#> 17:                                                                           CDOM data, personnel list
#> 18:                                     R script to transform into wide format and use dates as columns
#> 19:                               R script to transform into wide format and use wavelengths as columns
#> 20:                                                               Instructions to reshape data in Excel
#> 21:                                                                 Flow direction grid, tabular format
#> 22:                                                                            Basin name and ID lookup
#> 23:                                                                 Flow direction grid, GeoTIFF format
#> 24:                                                            Soil/sediment and porewater geochemistry
#> 25:                                                Active layer and permafrost core material properties
#> 26:                                         Carbon and nitrogen content and stable isotopic composition
#> 27:                                                                         Sediment CN, personnel list
#> 28:                                  Catalog of genomic data archived on GenBank from Baker et al. 2021
#> 29:                            Dissolved organic carbon and total dissolved nitrogen data, 2018-ongoing
#> 30:                               Dissolved organic carbon and total dissolved nitrogen, personnel list
#> 31:                                                                      Elson Lagoon bathymetry points
#> 32:                                                                     Elson Lagoon bathymetry surface
#> 33: Daily profile soil temperature and moisture from Elson Lagoon watershed, model estimates, 1981-2020
#> 34:   Monthly surface/subsurface DOC and runoff from Elson Lagoon watershed, model estimates, 1981-2020
#> 35:                                                    Model domain definition, grid cells' coordinates
#> 36:                                             Conductivity temperature depth data (CTD), 2018-ongoing
#> 37:                                                         Tilt current meter data (TCM), 2018-ongoing
#> 38:                                               Water column physiochemistry data (YSI), 2018-ongoing
#> 39:                                                                     Raw data: RBR CTD, 2018-ongoing
#> 40:                                                               Raw data: Star Oddi CTD, 2018-ongoing
#> 41:                                                      Raw data: Lowell TCM temperature, 2018-ongoing
#> 42:                                                          Raw data: Lowell TCM current, 2018-ongoing
#> 43:                                         YSI data subset used for CTD data calibration, 2018-ongoing
#> 44:                                                         physiochemistry-hydrography, personnel list
#> 45:                                                                        R script to process CTD data
#> 46:                                                                        R script to process TCM data
#> 47:                                                                HTML report from CTD data processing
#> 48:                                                                HTML report from TCM data processing
#> 49:                                                                                  d18O, 2019-ongoing
#> 50:                                                                                d18O, personnel list
#> 51:                                          Runoff from North Slope basins, model estimates, 1980-2010
#> 52:                                        Baseflow from North Slope basins, model estimates, 1980-2010
#> 53:                           Snow water equivalent from North Slope basins, model estimates, 1980-2010
#> 54:                               Soil temperatures from North Slope basins, model estimates, 1980-2010
#> 55:                          River discharge/export from North Slope basins, model estimates, 1980-2010
#> 56:                                                                             Model domain definition
#> 57:                                                                               GHAAS basins modelled
#> 58:                                                      All model output data in gridded netCDF format
#> 59:                                                        Surface PAR at Endicott Island, 2018-ongoing
#> 60:                                                                        Underwater PAR, 2018-ongoing
#> 61:                                                                              PAR sensor information
#> 62:                                                                                 PAR, personnel list
#> 63:                                                      RBR temperature depth (CTD) data, 2018-ongoing
#> 64:                                                                         RBR wave data, 2018-ongoing
#> 65:                                                         Tilt current meter (TCM) data, 2018-ongoing
#> 66:                                                                      Mooring deployment information
#> 67:                                                           RBR continuous wave burst data, 2018-2019
#> 68:                                                           RBR continuous wave burst data, 2019-2020
#> 69:                                                                                   Mooring schematic
#> 70:                                                                  SIMB data, Elson Lagoon, 2018-2019
#> 71:                                                                   SIMB data, Foggy Island Bay, 2019
#> 72:                                                                              Deployment information
#> 73:                                                                                        SIMB diagram
#> 74:                                                                              Hourly water pH record
#> 75:                                                                             pH data, personnel list
#>                                                                                              entityname
#>                                                                                                                                                                                                                                                                                                                 entitydescription
#>  1:                                                                                                                                                                                                                                                                              Water chemistry from multiple aquatic ecosystems
#>  2:                                                                                                                                                                                                                                                                                         pCO2 survey of Elson Lagoon from 2015
#>  3:                                                                                                                                                                                                                                                                                       Diel pCO2 in tundra pond over 4 summers
#>  4:                                                                                                                                                                                                                                                           Summer Net Ecosystem Production (NEP) in tundra pond over 4 summers
#>  5:                                                                                                                                                                                                                                                                      List of SRA runs, BioSamples, and associated information
#>  6:                                                                                                                                                                                                Carbon and nitrogen stable isotope composition of particulate organic matter from BLE LTER Core Program sampling, 2018-ongoing
#>  7:                                                                                                                                                                                                                                                                           Personnel list with years involved in this data set
#>  8:                                                                                                                                                                                                                          Pigment concentrations extracted from lagoon sediment samples by BLE LTER Core Program, 2018-ongoing
#>  9:                                                                                                                                                                                                                                                                           Personnel list with years involved in this data set
#> 10:                                                                                                                                                                                                                                Chlorophyll-a concentrations from water column sampling by BLE LTER Core Program, 2018-ongoing
#> 11:                                                                                                                                                                                                                                                                           Personnel list with years involved in this data set
#> 12:                                                                                                                                                         Concentrations of ammonia, phosphate, silicate, and nitrate+nitrite from aquatic and marine waters along the Beaufort Sea Alaska, BLE LTER Core Program, 2018-ongoing
#> 13:                                                                                                                                                                Concentrations of ammonia, phosphate, silicate, and nitrate+nitrite from sediment porewater along the Beaufort Sea Alaska, BLE LTER Core Program, 2018-ongoing
#> 14:                                                                                                                                                                                                                                                                                  Information on laboratory chemistry analyses
#> 15:                                                                                                                                                                                                                                                                           Personnel list with years involved in this data set
#> 16:                                                                                                                                                                                                                                          Absorption coefficient values per wavelength (200-800 nm) for filtered water samples
#> 17:                                                                                                                                                                                                                                                                           Personnel list with years involved in this data set
#> 18:                                                                                                                                                                                                                                             R script to transform long format CDOM data to wide format, with dates as columns
#> 19:                                                                                                                                                                                                                                       R script to transform long format CDOM data to wide format, with wavelengths as columns
#> 20:                                                                                                                                                                                                                                                                                     Instructions to reshape the data in Excel
#> 21:                                                                                                                                                                                                                               Flow direction grid for the North Slope drainage basin, Alaska, 1 km resolution, tabular format
#> 22:                                                                                                                                                                                                                                                                                                     River basin names and IDs
#> 23:                                                                                                                                                                                                                               Flow direction grid for the North Slope drainage basin, Alaska, 1 km resolution, GeoTIFF format
#> 24:                                                                                                                                                                                                                                Bulk soil and porewater geochemical constituents from active layer and permafrost core samples
#> 25:                                                                                                                                                                       Material properties of active layer and permafrost core samples. Includes dry bulk density, water content, grain size fractions, and other measurements
#> 26:                                                                                                                                                                                                                                      Carbon and nitrogen content and stable isotopic composition from sediment organic matter
#> 27:                                                                                                                                                                                                                                                                           Personnel list with years involved in this data set
#> 28:                                                                                                                                                                                                                                                                      List of SRA runs, BioSamples, and associated information
#> 29:                                                                                                                                                                                                                   Dissolved organic carbon and total dissolved nitrogen from BLE LTER Core Program sampling, Aug 2018-ongoing
#> 30:                                                                                                                                                                                                                                                                           Personnel list with years involved in this data set
#> 31: Bathymetry points of Elson Lagoon and nearshore Chukchi Sea, based on NAD83 / Alaska Albers. Attributes include location, precision, date and time, elevation, ellipsoid height, and NewDepth (water depth at any given sounding after correction for salinity and temperature). Horizontal and vertical units are in meters.
#> 32:                                                                                                                                                                                      Bathymetry surface of Elson Lagoon and nearshore Chukchi Sea, interpolated from bathymetry sounding points, based on NAD83 / UTM zone 4N
#> 33:                                                                                                                                                                                                 Daily model estimated soil temperatures and moisture content at eight depth levels, Elson Lagoon watershed, Alaska, 1980-2010
#> 34:                                                                                                                                                                                                 Monthly model estimated surface and subsurface dissolved organic carbon and runoff, Elson Lagoon watershed, Alaska, 1981-2020
#> 35:                                                                                                                                                                                                                                                                                                  Model grid cells coordinates
#> 36:                                                                                                                                                                     Temperature, conductivity, and salinity from RBRConcerto and StarOddi DST CT dataloggers deployed on benthos, BLE LTER Core Program, August 2018-ongoing.
#> 37:                                                                                                                                                                                 Current velocity, heading, and temperature from Lowell TCM MAT-1 dataloggers deployed on benthos, BLE LTER Core Program, August 2018-ongoing.
#> 38:                                                                                                      Physiochemical water column parameters (chlorophyll a, dissolved oxygen, phycoerythrin concentration, pH, temperature, conductivity, salinity) from hand cast YSI datasonde, BLE LTER Core Program, August 2018-ongoing.
#> 39:                                                                                                                                                              Raw data: Conductivity, temperature, depth, and derived parameters from RBRConcerto dataloggers deployed on benthos, BLE LTER Core Program, August 2018-ongoing.
#> 40:                                                                                                                                                                          Raw data: Temperature, conductivity, and salinity from Star Oddi DST CT dataloggers deployed on benthos, BLE LTER Core Program, August 2018-ongoing.
#> 41:                                                                                                                                                                                                      Raw data: Temperature from Lowell TCM MAT-1 dataloggers deployed on benthos, BLE LTER Core Program, August 2018-ongoing.
#> 42:                                                                                                                                                                                     Raw data: Current velocity and heading from Lowell TCM MAT-1 dataloggers deployed on benthos, BLE LTER Core Program, August 2018-ongoing.
#> 43:                                                                                                                                                            Used for calibration: YSI datasonde temperature, conductivity, and salinity, BLE LTER Core Program, August 2018-ongoing. This is a smaller subset of the YSI data.
#> 44:                                                                                                                                                                                                                                                                           Personnel list with years involved in this data set
#> 45:                                                                                                                                                                                                                                                       Annotated RMarkdown script to process, calibrate, and flag raw CTD data
#> 46:                                                                                                                                                                                                                                                       Annotated RMarkdown script to process, calibrate, and flag raw TCM data
#> 47:                                                                                                                                                                                                                                      HTML report generated from RMarkdown script to process, calibrate, and flag raw CTD data
#> 48:                                                                                                                                                                                                                                      HTML report generated from RMarkdown script to process, calibrate, and flag raw TCM data
#> 49:                                                                                                                                                                                                                                                        Water delta oxygen-18 from BLE LTER Core Program sampling 2019-ongoing
#> 50:                                                                                                                                                                                                                                                                           Personnel list with years involved in this data set
#> 51:                                                                                                                                                                                                                                                   Daily model estimated runoff, North Slope drainage basin, Alaska, 1980-2010
#> 52:                                                                                                                                                                                                                                      Monthly model estimated subsurface runoff, North Slope drainage basin, Alaska, 1980-2010
#> 53:                                                                                                                                                                                                                                 Monthly model estimated snow water equivalence, North Slope drainage basin, Alaska, 1980-2010
#> 54:                                                                                                                                                                                    Daily model estimated soil temperatures in 15 layers to depth 3.25 meters below the surface, North Slope drainage basin, Alaska, 1980-2010
#> 55:                                                                                                                                                                                                                                   Daily model estimated river discharge/export, North Slope drainage basin, Alaska, 1980-2010
#> 56:                                                                                                                                                                                                                                                                   Model grid cells coordinates and corresponding GHAAS basins
#> 57:                                                                                                                                                                                                GHAAS basins listed in model, North Slope, Alaska. IDs are based on the Global Hydrologic Archive and Analysis System (GHAAS).
#> 58:                                                                                                                                       Gridded model output data in netCDF format, including: daily runoff, soil temperatures, as well as monthly subsurface runoff and snow water equivalence, North Slope, Alaska, 1980-2010
#> 59:                                                                                                                                                                                                                        Surface incident photosynthetically active radiation (PAR), BLE LTER Core Program, August 2018-ongoing
#> 60:                                                                                                                                                                                                                              Underwater photosynthetically active radiation (PAR), BLE LTER Core Program, August 2018-ongoing
#> 61:                                                                                                                                                                                                                                                                         Information on individual sensors used to measure PAR
#> 62:                                                                                                                                                                                                                                                                           Personnel list with years involved in this data set
#> 63:                                                                                                                                                                                              Temperature, pressure, sea pressure, depth, and tidal slope measurements from RBRduo3 TD wave instrument, BLE LTER, 2018-ongoing
#> 64:                                                                                                                                                                                                                                                                        Wave data from RBR instruments, BLE LTER, 2018-ongoing
#> 65:                                                                                                                                                                                                                                        Velocity and temperature data from tilt current meters (TCM-1), BLE LTER, 2018-ongoing
#> 66:                                                                                                                                                                                                                                                Mooring instrument information: serial numbers, deployment and retrieval times
#> 67:                                                                                                                       Wave burst data from RBR instrument, BLE LTER, 2018-2019. Due to high data resolution, this data is packaged as a netCDF file with embedded metadata. See netCDF metadata for description of variables.
#> 68:                                                                                                                       Wave burst data from RBR instrument, BLE LTER, 2019-2020. Due to high data resolution, this data is packaged as a netCDF file with embedded metadata. See netCDF metadata for description of variables.
#> 69:                                                                                                                                                                                                                                                                                       Diagram illustrating instrument mooring
#> 70:                                                                                                                                                                                                                                Measurements collected by a Seasonal Ice Mass-balance Buoy (SIMB)\r\n deployed at Elson Lagoon
#> 71:                                                                                                                                                                                                                            Measurements collected by a Seasonal Ice Mass-balance Buoy (SIMB)\r\n deployed at Foggy Island Bay
#> 72:                                                                                                                                                                                                                                                     Info on deployment details: pinger height and depth, sensor spacing, etc.
#> 73:                                                                                                                                                                                                                   Diagram of a SIMB buoy and measurements as related to various markers (snow/ice surfaces, buoy rangefinder)
#> 74:                                                                                                                                                                                                                            Continuous 1-hour pH data recorded from SeaFET mooring, BLE LTER Core Program, August 2018-ongoing
#> 75:                                                                                                                                                                                                                                                                           Personnel list with years involved in this data set
#>                                                                                                                                                                                                                                                                                                                 entitydescription
#>         nrow                                                filename   filesize
#>  1:      231                                     regional_survey.csv      31626
#>  2:     2963                           Elson_2015_spatial_survey.csv     224030
#>  3:     1168                                     IBP_C_diel_pCO2.csv      71190
#>  4:      286                                     IBP_C_Daily_NEP.csv      14092
#>  5:      650                  BLE_LTER_Kellogg_2019_genomic_data.csv     563446
#>  6:      106                                        BLE_LTER_POM.csv      20030
#>  7:        8                              BLE_LTER_POM_personnel.csv        909
#>  8:      288                           BLE_LTER_sediment_pigment.csv      52444
#>  9:        4                 BLE_LTER_sediment_pigment_personnel.csv        563
#> 10:      104                   BLE_LTER_water_column_chlorophyll.csv      15572
#> 11:        6         BLE_LTER_water_column_chlorophyll_personnel.csv        789
#> 12:      106                      BLE_LTER_nutrient_water_column.csv      20080
#> 13:       51                BLE_LTER_nutrient_sediment_porewater.csv       9101
#> 14:        4           BLE_LTER_nutrient_chemistry_analysis_info.csv        486
#> 15:        7                         BLE_LTER_nutrient_personnel.csv        923
#> 16:    48681                      BLE_LTER_CDOM_absorption_scans.csv    7340604
#> 17:        6                             BLE_LTER_CDOM_personnel.csv        822
#> 18:     <NA>                                     MakeColumnsAsDate.R        392
#> 19:     <NA>                               MakeColumnsAsWavelength.R        359
#> 20:     <NA>                                  ReshapeDataInExcel.txt       1839
#> 21:   182722                   BLE_LTER_flow_direction_1km_table.csv   19932181
#> 22:     1363            BLE_LTER_flow_direction_1km_basin_lookup.csv      19684
#> 23:     <NA>                    BLE_LTER_flow_direction_1km_grid.zip     170671
#> 24:       45                    BLE_LTER_drew_point_geochemistry.csv       9078
#> 25:       54             BLE_LTER_drew_point_material_properties.csv       5650
#> 26:       57                                BLE_LTER_sediment_CN.csv       9775
#> 27:        7                      BLE_LTER_sediment_CN_personnel.csv        941
#> 28:       35                    BLE_LTER_Baker_2021_genomic_data.csv      17707
#> 29:      104                                    BLE_LTER_DOC_TDN.csv      15586
#> 30:        7                          BLE_LTER_DOC_TDN_personnel.csv        828
#> 31:     <NA>                    BLE_LTER_Elson_bathymetry_points.zip   10196053
#> 32:     <NA>                   BLE_LTER_Elson_bathymetry_surface.zip   10536958
#> 33: 67673520 BLE_LTER_Elson_hydromodel_soil_temperature_moisture.csv 2025981654
#> 34:   277920                BLE_LTER_Elson_hydromodel_DOC_runoff.csv   14004960
#> 35:      579                    BLE_LTER_Elson_hydromodel_domain.csv      18930
#> 36:    70513                            BLE_LTER_hydrography_CTD.csv   13635345
#> 37:    68474                            BLE_LTER_hydrography_TCM.csv    9005153
#> 38:      127                            BLE_LTER_hydrography_YSI.csv      26279
#> 39:    35221                    BLE_LTER_hydrography_CTD_RBR_raw.csv    6434348
#> 40:    70515               BLE_LTER_hydrography_CTD_StarOddi_raw.csv    3365404
#> 41:    68525                   BLE_LTER_hydrography_TCM_temp_raw.csv    2512497
#> 42:    68475                BLE_LTER_hydrography_TCM_current_raw.csv    3523970
#> 43:       15            BLE_LTER_hydrography_YSI_for_calibration.csv        790
#> 44:        6                      BLE_LTER_hydrography_personnel.csv        702
#> 45:     <NA>                       BLE_LTER_hydrography_CTD_QAQC.Rmd       9674
#> 46:     <NA>                       BLE_LTER_hydrography_TCM_QAQC.Rmd       4740
#> 47:     <NA>                      BLE_LTER_hydrography_CTD_QAQC.html    2022638
#> 48:     <NA>                      BLE_LTER_hydrography_TCM_QAQC.html     968709
#> 49:       88                                       BLE_LTER_d18O.csv      14225
#> 50:        7                             BLE_LTER_d18O_personnel.csv        828
#> 51:  3532776                          BLE_LTER_hydromodel_runoff.csv  113647361
#> 52:   116064                        BLE_LTER_hydromodel_baseflow.csv    3409474
#> 53:   116064           BLE_LTER_hydromodel_snow_water_equivalent.csv    3600111
#> 54: 52991640                       BLE_LTER_hydromodel_soiltemps.csv 2071460799
#> 55:   460194                BLE_LTER_hydromodel_discharge_export.csv   15232189
#> 56:      312                          BLE_LTER_hydromodel_domain.csv       9747
#> 57:       42                          BLE_LTER_hydromodel_basins.csv       1849
#> 58:     <NA>                   BLE_LTER_hydromodel_gridded_output.nc   38837324
#> 59:     3019                                BLE_LTER_surface_PAR.csv     326673
#> 60:     2935                             BLE_LTER_underwater_PAR.csv     329566
#> 61:        3                            BLE_LTER_PAR_sensor_info.csv        209
#> 62:        5                              BLE_LTER_PAR_personnel.csv        580
#> 63:    62333                            BLE_LTER_circulation_CTD.csv   10750752
#> 64:    70222                           BLE_LTER_circulation_wave.csv   15790011
#> 65:    61166                            BLE_LTER_circulation_TCM.csv   10020748
#> 66:       10                BLE_LTER_circulation_deployment_info.csv       1044
#> 67:     <NA>                 BLE_LTER_circulation_burst_2018_2019.nc   77730915
#> 68:     <NA>                 BLE_LTER_circulation_burst_2019_2020.nc   30698754
#> 69:     <NA>           BLE_LTER_circulation_deployment_schematic.png      74268
#> 70:     4641                BLE_LTER_SIMB_Elson_Lagoon_2018_2019.csv    6073032
#> 71:     3404                 BLE_LTER_SIMB_Foggy_Island_Bay_2019.csv    4286399
#> 72:        2                       BLE_LTER_SIMB_deployment_info.csv        674
#> 73:     <NA>                               BLE_LTER_SIMB_diagram.pdf      30328
#> 74:     8831                                         BLE_LTER_pH.csv    1079408
#> 75:        6                               BLE_LTER_pH_personnel.csv        699
#>         nrow                                                filename   filesize
#>     filesizeunit                         checksum
#>  1:         byte 65c40c28f5373fd8ad5da428f4b2afeb
#>  2:         byte 5d7d2753c65ee3eb921742d7d1e580b8
#>  3:         byte d3a158536bc6bcc4b354e8c3220b8801
#>  4:         byte 3e953a033cc23f2c35f58a0cd14c73a1
#>  5:         byte b245f9567d9e7c781337ac8f5c4d93c1
#>  6:         byte bae1f545080c852d26f2d551f0f0a4f4
#>  7:         byte d77ab9a04f5f3eaa32a270b601e568ca
#>  8:         byte 46f9733302bccb447b5bd0615c86c731
#>  9:         byte aeac2f87e32f05454268fb6cc387c399
#> 10:         byte 13126e88788b1307c5823bcfe8bedc42
#> 11:         byte 02ce6d4fc22870d4311d6a02c4da18e1
#> 12:         byte d29e8764f3c8d2f21082a24dca76fd32
#> 13:         byte a3001312587d5f9494810820bf37f56b
#> 14:         byte defac8778cb1b3aedcee694aeacacf21
#> 15:         byte f926358789e355aedb9ff17049c50207
#> 16:         byte 1b95094e2c231008b3ab2946d0714628
#> 17:         byte 4f05e7f70613ec8715b23bf0be2d4996
#> 18:         byte c5016baa7c757e1a4b994a2d1bf1bf6d
#> 19:         byte 30fdedba2721af26238f49d202030d41
#> 20:         byte f5cb9fb435ddfc64b0d048a028dfbf56
#> 21:         byte f22eeaec5cfa10148c40a4bc07d51505
#> 22:         byte 810fdbef0313af388e1a9572abda4811
#> 23:         byte 7dc159fa0c9a1108816434e81508b43e
#> 24:         byte d2fe383ad87e5dab1c3088a4f2babae9
#> 25:         byte b4d90b87998e0b2131f442d3157e94f2
#> 26:         byte f73c84e3dc6bca2fca06cb11291995cf
#> 27:         byte 3c858e75043197cf8813b74306812a4b
#> 28:         byte d3880d4fbe719967a2370f4d031ed832
#> 29:         byte 76a07ab9f3f527a9dd67a20e80bad5df
#> 30:         byte 0ed535db2feb8b420843d8102bf68ba6
#> 31:         byte a4f61f3d03370993ebb86541a13db240
#> 32:         byte 5276e3a4171173c6f9c8b981704b7114
#> 33:         byte 9b5fea90366b14444f357e0b289337b8
#> 34:         byte efb3919fe3d5ca1d9ca8bb7b4ada49d4
#> 35:         byte 4484442edf2fc4f42182dff4e17bf4db
#> 36:         byte 59d146dcf553ce87426b745e79ce2073
#> 37:         byte b211513f0a6edf8a9decbeece2132872
#> 38:         byte dda46629bde5ca18b252599a48744eaf
#> 39:         byte d0aa24d1e132704fd57759b74e9de5d7
#> 40:         byte de7d418f8072fa693043de46257fe381
#> 41:         byte 26c4985d569f4ee950a664d5007fc8ce
#> 42:         byte 14c6f06529aeac4b57a71718612b12f5
#> 43:         byte 4335742cefd56309e550edbb8343fd57
#> 44:         byte 8a92275699e3b326088362f9059de675
#> 45:         byte 8547b7a63fcf6c1f0913a5bd7549d9d1
#> 46:         byte ce7ba47ca37323d92b5a674dc85dac10
#> 47:         byte 6428a696ff06d788cc6b94e7a2b283cb
#> 48:         byte 540cdc73d447772a9a3a9dd47bf1bd35
#> 49:         byte e73dc118141a89e1ce416c7f41d6104f
#> 50:         byte c1cfe529befa63979d8fc1c465ece34c
#> 51:         byte 4fd1df35ad2bd5d1a09b80442758f477
#> 52:         byte 4615b6e7e970ba2b5f492ca5e775d813
#> 53:         byte a080c4568ef2dcd0ad0c4398e5c4ca17
#> 54:         byte 81b2b5d0a7f989f2b1961a3c24884d72
#> 55:         byte 1fe74bab57aa5a7901e56517f028d5ac
#> 56:         byte 931f8c15de98ff2a4c1021917dba088a
#> 57:         byte 05575bf911b54287904e73a92eeb742d
#> 58:         byte 27aa82bef67969a232c9c81e4a17ec97
#> 59:         byte 87344b63be30f00cd9a77a64f06a6ffe
#> 60:         byte 6f32bc2517e5a8c9f0a5919b4063a0d1
#> 61:         byte 202f448c248ac08980c35b67000911cc
#> 62:         byte 023eef1039577475aca69146aa3c98a3
#> 63:         byte 499589dc49c611763b9191f29785f918
#> 64:         byte d256db587e4f17d6a1a32fd7fd34ad73
#> 65:         byte eabe30eebc4755dfbce60b45de4dd158
#> 66:         byte faab03185b3ad4e15fba4ca70f86bea9
#> 67:         byte daf9881eb3171d8d0ea168dbb49295ac
#> 68:         byte 639fedad32e051d96945005c9c09a86e
#> 69:         byte 39a05f555c6a55696635fb3d774ff2ab
#> 70:         byte 0ae8d840191be44213ba84bdb8c2c7d9
#> 71:         byte 649a9737aa39c5a26427c78a896123a2
#> 72:         byte 8edb817c3d234052413a287bdf4883e5
#> 73:         byte 0b146a17d4d312cbc8aaf1dc80012151
#> 74:         byte 1fd4268e8815ddbbf073e7fb51637d30
#> 75:         byte 4bcd84decfc3b1ad0b2f1edbafdae9ef
#>     filesizeunit                         checksum
#> 
#> $attributes
#>              scope datasetid rev entity entitytype         id attributeName
#>    1: knb-lter-ble         1   7     11  dataTable d1-e1-att1          Year
#>    2: knb-lter-ble         1   7     11  dataTable d1-e1-att2       Habitat
#>    3: knb-lter-ble         1   7     11  dataTable d1-e1-att3         FwSal
#>    4: knb-lter-ble         1   7     11  dataTable d1-e1-att4          Site
#>    5: knb-lter-ble         1   7     11  dataTable d1-e1-att5       Station
#>   ---                                                                      
#> 1056: knb-lter-ble         9   1     12  dataTable d9-e2-att4       surname
#> 1057: knb-lter-ble         9   1     12  dataTable d9-e2-att5          role
#> 1058: knb-lter-ble         9   1     12  dataTable d9-e2-att6     beginyear
#> 1059: knb-lter-ble         9   1     12  dataTable d9-e2-att7       endyear
#> 1060: knb-lter-ble         9   1     12  dataTable d9-e2-att8         orcid
#>             attributeLabel
#>    1:                 Year
#>    2:              Habitat
#>    3: Freshwater or Saline
#>    4:                 Site
#>    5:              Station
#>   ---                     
#> 1056:              Surname
#> 1057:                 Role
#> 1058:           Begin year
#> 1059:             End year
#> 1060:                ORCID
#>                                                                                       attributeDefinition
#>    1:                                                                            Year data were collected
#>    2:                                                     Habitat type (pond, lake, river, lagoon, ocean)
#>    3:                                         Identifies freshwater or saline (incl. brackish) conditions
#>    4:           Site name. Not to be confused with a "site" defined in the EML element geographicCoverage
#>    5: When multiple sites within a single site were sampled, they were assigned a different subsite name.
#>   ---                                                                                                    
#> 1056:                                                                                Surname or last name
#> 1057:                                                                                     Role in dataset
#> 1058:                                                                   Beginning year of role in dataset
#> 1059:                                                                         End year of role in dataset
#> 1060:                                                                                               ORCID
#>       storageType formatString dateTimePrecision measurementScale
#>    1:     integer         YYYY                 1         dateTime
#>    2:      string         <NA>              <NA>          nominal
#>    3:      string         <NA>              <NA>          nominal
#>    4:      string         <NA>              <NA>          nominal
#>    5:      string         <NA>              <NA>          nominal
#>   ---                                                            
#> 1056:      string         <NA>              <NA>          nominal
#> 1057:      string         <NA>              <NA>          nominal
#> 1058:    dateTime         YYYY                 1         dateTime
#> 1059:    dateTime         YYYY                 1         dateTime
#> 1060:      string         <NA>              <NA>          nominal
#>                 domain definition unit numberType minimum maximum code
#>    1:   dateTimeDomain       <NA> <NA>       <NA>    <NA>    <NA> <NA>
#>    2: enumeratedDomain       <NA> <NA>       <NA>    <NA>    <NA> <NA>
#>    3: enumeratedDomain       <NA> <NA>       <NA>    <NA>    <NA> <NA>
#>    4:       textDomain   any text <NA>       <NA>    <NA>    <NA> <NA>
#>    5:       textDomain   any text <NA>       <NA>    <NA>    <NA> <NA>
#>   ---                                                                 
#> 1056:       textDomain   any text <NA>       <NA>    <NA>    <NA> <NA>
#> 1057:       textDomain   any text <NA>       <NA>    <NA>    <NA> <NA>
#> 1058:   dateTimeDomain       <NA> <NA>       <NA>    <NA>    <NA> <NA>
#> 1059:   dateTimeDomain       <NA> <NA>       <NA>    <NA>    <NA> <NA>
#> 1060:       textDomain   any text <NA>       <NA>    <NA>    <NA> <NA>
#>       codeExplanation precision label label label label label label label label
#>    1:            <NA>      <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>
#>    2:            <NA>      <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>
#>    3:            <NA>      <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>
#>    4:            <NA>      <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>
#>    5:            <NA>      <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>
#>   ---                                                                          
#> 1056:            <NA>      <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>
#> 1057:            <NA>      <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>
#> 1058:            <NA>      <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>
#> 1059:            <NA>      <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>
#> 1060:            <NA>      <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>
#>       label label label label label label code codeExplanation
#>    1:  <NA>  <NA>  <NA>  <NA>  <NA>  <NA> <NA>            <NA>
#>    2:  <NA>  <NA>  <NA>  <NA>  <NA>  <NA> <NA>            <NA>
#>    3:  <NA>  <NA>  <NA>  <NA>  <NA>  <NA> <NA>            <NA>
#>    4:  <NA>  <NA>  <NA>  <NA>  <NA>  <NA> <NA>            <NA>
#>    5:  <NA>  <NA>  <NA>  <NA>  <NA>  <NA> <NA>            <NA>
#>   ---                                                         
#> 1056:  <NA>  <NA>  <NA>  <NA>  <NA>  <NA> <NA>            <NA>
#> 1057:  <NA>  <NA>  <NA>  <NA>  <NA>  <NA> <NA>            <NA>
#> 1058:  <NA>  <NA>  <NA>  <NA>  <NA>  <NA> <NA>            <NA>
#> 1059:  <NA>  <NA>  <NA>  <NA>  <NA>  <NA> <NA>            <NA>
#> 1060:  <NA>  <NA>  <NA>  <NA>  <NA>  <NA> <NA>            <NA>
#> 
#> $codes
#>             scope datasetid rev entity entitytype attribute attributeName
#>   1: knb-lter-ble         1   7     11  dataTable         2       Habitat
#>   2: knb-lter-ble         1   7     11  dataTable         2       Habitat
#>   3: knb-lter-ble         1   7     11  dataTable         2       Habitat
#>   4: knb-lter-ble         1   7     11  dataTable         2       Habitat
#>   5: knb-lter-ble         1   7     11  dataTable         2       Habitat
#>  ---                                                                     
#> 283: knb-lter-ble         8   7     12  dataTable         8       z_bot_m
#> 284: knb-lter-ble         8   7     12  dataTable        17 water_depth_m
#> 285: knb-lter-ble         9   1     11  dataTable        11  habitat_type
#> 286: knb-lter-ble         9   1     11  dataTable        11  habitat_type
#> 287: knb-lter-ble         9   1     11  dataTable        11  habitat_type
#>         codetype       code                                          definition
#>   1:      factor     Lagoon                                              Lagoon
#>   2:      factor       LAKE                                                Lake
#>   3:      factor       POND                                                Pond
#>   4:      factor Salt-River River influenced by saltwater intrusion from lagoon
#>   5:      factor    TK-POND                                    Thermokarst Pond
#>  ---                                                                           
#> 283: missingcode         NA                            not available/applicable
#> 284: missingcode         NA                            not available/applicable
#> 285:      factor      ocean                                               Ocean
#> 286:      factor     lagoon                                              Lagoon
#> 287:      factor      river                                    Freshwater river
#> 
#> $parties
#>      id        scope rev order              type role firstname   surname
#>   1:  1 knb-lter-ble   7    11           creator <NA>      <NA>      <NA>
#>   2:  1 knb-lter-ble   7    12           creator <NA> Vanessa L  Lougheed
#>   3:  1 knb-lter-ble   7  <NA>           contact <NA>      <NA>      <NA>
#>   4:  1 knb-lter-ble   7  <NA>         publisher <NA>      <NA>      <NA>
#>   5:  1 knb-lter-ble   7  <NA>  metadataProvider <NA>      <NA>      <NA>
#>  ---                                                                     
#> 491:  9 knb-lter-ble   1  <NA> project personnel <NA>     Craig   Tweedie
#> 492:  9 knb-lter-ble   1  <NA> project personnel <NA> Christina   Bonsell
#> 493:  9 knb-lter-ble   1  <NA> project personnel <NA>    Nathan   McTigue
#> 494:  9 knb-lter-ble   1  <NA> project personnel <NA>   Timothy Whiteaker
#> 495:  9 knb-lter-ble   1  <NA> project personnel <NA>     An T.    Nguyen
#>                            organization            position
#>   1:    Beaufort Lagoon Ecosystems LTER                <NA>
#>   2: The University of Texas at El Paso                <NA>
#>   3:    Beaufort Lagoon Ecosystems LTER Information Manager
#>   4:    Beaufort Lagoon Ecosystems LTER                <NA>
#>   5:    Beaufort Lagoon Ecosystems LTER                <NA>
#>  ---                                                       
#> 491: The University of Texas at El Paso                <NA>
#> 492:  The University of Texas at Austin                <NA>
#> 493:  The University of Texas at Austin                <NA>
#> 494:  The University of Texas at Austin                <NA>
#> 495:  The University of Texas at Austin                <NA>
#>                                                     address         city state
#>   1:                                   750 Channel View Dr. Port Aransas    TX
#>   2: 500 W University Ave Department of Biological Sciences      El Paso    TX
#>   3:             MC R8000 The University of Texas at Austin       Austin    TX
#>   4:                                   750 Channel View Dr. Port Aransas    TX
#>   5:                                   750 Channel View Dr. Port Aransas    TX
#>  ---                                                                          
#> 491:                                                   <NA>         <NA>  <NA>
#> 492:                                                   <NA>         <NA>  <NA>
#> 493:                                                   <NA>         <NA>  <NA>
#> 494:                                                   <NA>         <NA>  <NA>
#> 495:                                                   <NA>         <NA>  <NA>
#>      country   zip        phone                 email
#>   1:     USA 78373         <NA>     BLE-IM@utexas.edu
#>   2:     USA 79902 915-747-6887    vlougheed@utep.edu
#>   3:     USA 78712         <NA>     BLE-IM@utexas.edu
#>   4:     USA 78373         <NA>     BLE-IM@utexas.edu
#>   5:     USA 78373         <NA>     BLE-IM@utexas.edu
#>  ---                                                 
#> 491:    <NA>  <NA>         <NA>     ctweedie@utep.edu
#> 492:    <NA>  <NA>         <NA>   cbonsell@utexas.edu
#> 493:    <NA>  <NA>         <NA>    mctigue@utexas.edu
#> 494:    <NA>  <NA>         <NA>  whiteaker@utexas.edu
#> 495:    <NA>  <NA>         <NA> enthusiast@utexas.edu
#>                                     online_url
#>   1:                  https://ble.lternet.edu/
#>   2: https://expertise.utep.edu/node/26254\r\n
#>   3:                  https://ble.lternet.edu/
#>   4:                  https://ble.lternet.edu/
#>   5:                  https://ble.lternet.edu/
#>  ---                                          
#> 491:                                      <NA>
#> 492:                                      <NA>
#> 493:                                      <NA>
#> 494:                                      <NA>
#> 495:                                      <NA>
#> 
#> $keywords
#>             scope datasetid rev                         keyword keywordtype
#>   1: knb-lter-ble         1   7    movement of inorganic matter       theme
#>   2: knb-lter-ble         1   7      movement of organic matter       theme
#>   3: knb-lter-ble         1   7              primary production       theme
#>   4: knb-lter-ble         1   7              aquatic ecosystems       theme
#>   5: knb-lter-ble         1   7                 biogeochemistry       theme
#>  ---                                                                       
#> 465: knb-lter-ble         9   1                 Kaktovik Lagoon       place
#> 466: knb-lter-ble         9   1 Beaufort Lagoon Ecosystems LTER       theme
#> 467: knb-lter-ble         9   1                             BLE       theme
#> 468: knb-lter-ble         9   1           BLE LTER Core Program       theme
#> 469: knb-lter-ble         9   1                            LTER       theme
#>                                thesaurus
#>   1:            LTER Core Research Areas
#>   2:            LTER Core Research Areas
#>   3:            LTER Core Research Areas
#>   4:       LTER Controlled Vocabulary v1
#>   5:       LTER Controlled Vocabulary v1
#>  ---                                    
#> 465: Geographic Names Information System
#> 466:      BLE LTER Controlled Vocabulary
#> 467:      BLE LTER Controlled Vocabulary
#> 468:      BLE LTER Controlled Vocabulary
#> 469:      BLE LTER Controlled Vocabulary
```

### Step 4: Normalize tables

``` r
# tbls <- normalize_tables(dfs)
```

## Customized usage of pkEML

### Stop when you have what you want

One can stop at any point in the above sequence, of course. A logical
place to stop would be after running `EML2df` on your EML corpus. At
this point, you’ve got a set of rich tables to do a lot with.

### Getting specific metadata elements

`EML2df` simply wraps around a set of more granular `get_` functions.
These are all exported functions and can be used to get specific
metadata elements in table form:

``` r
datasets <- get_dataset(corpus = emls)
#> Getting datasets...
#>     Returning 21 rows.
taxonomy <- get_coverage_tax(corpus = emls)
#> Getting taxonomicCoverage ...
#>     Returning 0 rows.
```

### Getting a particular metadata element (that I didn’t write a `get_` function for)

Even more potentially powerful is the adaptable `get_multilevel_element`
and `get_datasetlevel_element` functions. These take a EML corpus, an
EML element name, and a parse function as arguments. For example,
`get_coverage_geo` is actually just a wrapper around
`get_multilevel_element`:

``` r
# get_coverage_geo(corpus = emls) 

# is equivalent to 

# get_multilevel_element(corpus = emls, element_names = c("coverage", "geographicCoverage"), parse_function = parse_geocov) 
```

`geographicCoverage` is an element that can be used to describe any
combination of datasets, entities, and attributes in EML.
`get_multilevel_element` grabs all occurrences of the
`geographicalCoverage` node at each level, then runs them through the
`parse_geocov` function, while preserving the context of where each
occurrence was – which dataset, which entity, which attribute.

Ditto for `get_datasetlevel_element`, a very similar function but works
only at the dataset level, since there are many EML elements unique to
this level.

To grab an EML element without a ready-made `get_` function, just write
a custom parse function and pass to these generic functions.

## Getting help

Report an issue and I’ll try my best to get to you.
