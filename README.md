# pkEML
pkEML

A R package to convert Ecological Metadata Language (EML) documents to tables, and, optionally, normalizes them into tables suited for import into a relational database system, such as the LTER-core-metabase schema. Data managers can use pkEML to aid migration of their metadata archives, while researchers working on meta-analyses can use pkEML to quickly gather metadata details from a large set of datasets.  While pkEML was developed with the LTER network in mind, any users of the Ecological Metadata Language may find its functionality useful.

How to say "pkEML": spell out each letter. pk is meant to stand for primary key, but one can also intepret as peak-EML or pack-EML.

## Installation

```
# Requires the remotes package
install.packages("remotes")
remotes::install_github("atn38/pkEML")
```

## How to use pkEML

```
library(pkEML)
```

### Assemble a "corpus" of EML documents

A corpus of EML documents can correspond to a research program's metadata archives, or any set of assembled metadata documents. A corpus is the unit of 

pkEML has a function to quickly and conveniently download all EML documents from an Environment Data Initiative (EDI) repository's "scope":

```
pkEML::download_corpus(scope = "knb-lter-ble", path = getwd())
```

This downloads into the specified directory all EML documents from the most recent revisions of datasets under the "knb-lter-ble" scope in EDI, which is the Beaufort Lagoon Ecosystems LTER program. 

If working with a more heterogeneous set, use your favorite method to download the EML documents into a directory.

### Import the EML corpus into R

```
emls <- import_corpus(path = getwd())
```

`import_corpus` outputs a nested list of EML documents represented under the `emld` format. Each list item is a EML document and named after the full packageId in the metadata body (not the .xml file name in the directory).

### Convert EML corpus to tables

```
dfs <- EML2df(corpus = emls)
```

`dfs` is a nested list of data.frames. Each data.frame will contain assembled information from all your datasets, each on key metadata groups such as dataset-level information, entity-level, attribute-level, attribute codes (enumeration and missing), geographical/temporal/taxonomic coverage, and so on. These data.frames are de-normalized, meaning all occurrences in EML are recorded and there may be loads of repeated information. For example, key personnel from your research program will be listed as contributors on many datasets, core sampling locations will be listed many times, and so on. 

```
dfs
```

### Normalize tables 

```
tbls <- normalize(dfs)
```

### Customized usage of pkEML

One can stop at any point in the above sequence, of course. 

`EML2df` simply wraps around a set of more granular `get_` functions. These are all exported functions and can be used to get specific metadata elements in table form:

```
datasets <- get_datasets(corpus = emls)
taxonomy <- get_coverage_tax(corpus = emls)
```

Even more potentially powerful is the adaptable `get_multilevel_element` and `get_datasetlevel_element` functions. These take a EML corpus, an EML element name, and a parse function as arguments. For example, `get_coverage_geo` is actually just a wrapper around `get_multilevel_element`:

```
# get_coverage_geo(corpus = emls) 

# is equivalent to 

# get_multilevel_element(corpus = emls, element_names = c("coverage", "geographicCoverage"), parse_function = parse_geocov) 
```

Since `geographicCoverage` is an element that can be used to describe any combination of datasets, entities, and attribute in EML, `get_multilevel_element` grabs all occurrences of the `geographicalCoverage` node at each level, then runs them through the `parse_geocov` function. Ditto for `get_datasetlevel_element`, a very similar function but works only at the dataset level, since there are many EML elements unique to this level. It follows that a custom parse function can be written and passed to these adaptable functions, so that one can grab an EML element without a ready-made `get_` function.


## Getting help

Report an issue and I'll try my best to get to you.




