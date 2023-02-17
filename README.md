
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
#> Installing package into 'C:/Software/Anaconda/Temp/RtmpYhuIxJ/temp_libpath44b42546789b'
#> (as 'lib' is unspecified)
remotes::install_github("atn38/pkEML")
#> Downloading GitHub repo atn38/pkEML@HEAD
#> Installing package into 'C:/Software/Anaconda/Temp/RtmpYhuIxJ/temp_libpath44b42546789b'
#> (as 'lib' is unspecified)
#> Warning in i.p(...): installation of package 'C:/Software/Anaconda/Temp/
#> RtmpmwBZhV/file5b044511a25/pkEML_0.1.0.tar.gz' had non-zero exit status
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
lapply(dfs, colnames)
#> $datasets
#>  [1] "packageId"                    "scope"                       
#>  [3] "datasetid"                    "revision_number"             
#>  [5] "title"                        "shortname"                   
#>  [7] "abstract"                     "abstract_type"               
#>  [9] "maintenance_description"      "maintenance_update_frequency"
#> 
#> $entities
#>  [1] "scope"             "datasetid"         "rev"              
#>  [4] "entity"            "entitytype"        "entityname"       
#>  [7] "entitydescription" "nrow"              "filename"         
#> [10] "filesize"          "filesizeunit"      "checksum"         
#> 
#> $attributes
#>  [1] "scope"               "datasetid"           "rev"                
#>  [4] "entity"              "entitytype"          "id"                 
#>  [7] "attributeName"       "attributeLabel"      "attributeDefinition"
#> [10] "storageType"         "formatString"        "dateTimePrecision"  
#> [13] "measurementScale"    "domain"              "definition"         
#> [16] "unit"                "numberType"          "minimum"            
#> [19] "maximum"             "code"                "codeExplanation"    
#> [22] "precision"           "label"               "label"              
#> [25] "label"               "label"               "label"              
#> [28] "label"               "label"               "label"              
#> [31] "label"               "label"               "label"              
#> [34] "label"               "label"               "label"              
#> [37] "code"                "codeExplanation"    
#> 
#> $codes
#>  [1] "scope"         "datasetid"     "rev"           "entity"       
#>  [5] "entitytype"    "attribute"     "attributeName" "codetype"     
#>  [9] "code"          "definition"   
#> 
#> $parties
#>  [1] "id"           "scope"        "rev"          "order"        "type"        
#>  [6] "role"         "firstname"    "surname"      "organization" "position"    
#> [11] "address"      "city"         "state"        "country"      "zip"         
#> [16] "phone"        "email"        "online_url"  
#> 
#> $keywords
#> [1] "scope"       "datasetid"   "rev"         "keyword"     "keywordtype"
#> [6] "thesaurus"  
#> 
#> $changehistory
#> [1] "scope"        "datasetid"    "rev"          "change_scope" "date"        
#> [6] "old_value"    "new_value"    "note"        
#> 
#> $geocov
#>  [1] "scope"              "datasetid"          "rev"               
#>  [4] "entity"             "entitytype"         "attribute"         
#>  [7] "attributename"      "geographicCoverage" "desc"              
#> [10] "west"               "east"               "north"             
#> [13] "south"              "altitude_min"       "altitude_max"      
#> [16] "altitude_unit"     
#> 
#> $tempocov
#>  [1] "scope"                           "datasetid"                      
#>  [3] "rev"                             "entity"                         
#>  [5] "entitytype"                      "attribute"                      
#>  [7] "attributename"                   "temporalCoverage"               
#>  [9] "datetype"                        "begin"                          
#> [11] "end"                             "alternativeTimeScaleName"       
#> [13] "alternativeTimeScaleAgeEstimate"
#> 
#> $taxcov
#> character(0)
#> 
#> $projects
#> [1] "scope"     "datasetid" "rev"       "title"     "abstract"  "funding"  
#> 
#> $annotations
#>  [1] "scope"         "datasetid"     "rev"           "entity"       
#>  [5] "entitytype"    "attribute"     "attributename" "annotation"   
#>  [9] "propertylabel" "propertyURI"   "valuelabel"    "valueURI"     
#> 
#> $methods
#>  [1] "scope"             "datasetid"         "rev"              
#>  [4] "entity"            "entitytype"        "attribute"        
#>  [7] "attributename"     "methodStep"        "methoddescription"
#> [10] "methodtype"
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
