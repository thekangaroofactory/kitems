# kitems v0.5.6-beta

The milestone focuses on item operations and introduces shortcuts for item creation

## New features

### Data-model
* Check that attribute name does not contain blank space (#336)

### Items
* Item creation should protect against duplicated id (#330)
* item_add should secure that item has expected structure & types (#345)
* item_delete should secure id parameter (#350)
* item add, update and delete functions should work out of a reactive context (#347)
* item add, update & delete should be secured by tryCatch (#351)
* Implement search function (#254)
* Implement value suggestion for item creation inputs (#295)

### Misc

* Implement backup / restore mechanism (#294)
* Cleanup range in date_slider section (#338)

### Documentation

* Implement NEWS (#334)
* Implement pkgdown & GitHub Page CI (#331)


## Bug Fix

* Data model should be stored only once items have been migrated after adding an attribute (#324)
* Error in if when trying to migrate items with a new POSIXct attribute (#325)
* Need to double check that POSIXct column is there in the items before conversion (#326)
* All attributes get skip & filter set to TRUE after import (#329)
* item_search function needs to use .data (#328)
* item_search throws a warning in tidyselect (#348)


# kitems v0.5.5-beta

The milestone focus is on code coverage

## New features

### Misc
* Remove DT package import
* Improve test coverage
* Implement R-CMD-check CI (GitHub action)
* Update codecov CI (GitHub action)


# kitems v0.5.4-beta

The milestone focus is on code architecture

## New features

### Data-model
* Implement attribute_delete function (#309)
* Externalize delete data model as functions(#308)
* Externalize attribute wizard as a module (#307)

### Items
* Reload items only if data model integrity check impacts them (#306)

### Misc
* Externalize import as a module (#312)
* Implement danger_zone_ui function (#310)


## Bug fix

### Data-model

* Delete data model modal gets wrong confirmation string (#311)


# kitems v0.5.3-beta

The milestone focus is on code architecture

## New features

### Misc

* Implement admin parameter in main server (#301)
* Homogenize input / output names (#288)
* Homogenize function names (#292)
* Externalize admin in a dedicated shiny module (#301)
* Code cleanup (#289)
* Test coverage (#299)


# kitems v0.5.2-beta

The milestone focus is on data-model

## New features

### Data-model
* Implement modal wizard to create or update data model's attribute (#281)
* Support arguments in default_fun mechanism (#63)
* Implement multiple ordering in the data model definition (#239)
* Remove support of POSIXlt class (#280)
* Improve support of POSIXct class (timezone, form, persistence, ISO-8601) (#253)
* Implement delete data model (and manage impacts) (#282)
* Deleting the last attribute of a data model cleans data model & items (#273)
* Implement warning when autosave is turned off (#283)
* Improve admin UI to show module vs nested module call (#250)

### Item
* Check attribute type persistence during load (POSIXct, ISO-8601) (#177)

### Misc
* Remove standard view (#278)
* Update demo app to demonstrate module call vs nested module call (#241)


## Bug fix

### Data-model
* Data model is saved after check integrity even if autosave is FALSE (#291)

### Item
* Create button is still available after data model is deleted (#290)

### Misc
* Deleting attribute date generates an error in filter / selected items (#287)
* Date_slider is updated twice upon init app (#285)
* Reorder column is called when initializing the admin UI (#284)


# kitems v0.5.1-beta

This is a minor revision focusing on code cleanup, test & documentation

## Code cleanup

* Cleanup code (#275)
* Update kitems_names.R to remove triggers, items, data model (#264)
* Remove hard coded parameters for id (#219)
* Turn trigger_create into a function
* Remove r dependency and update server signature (#276)
* Cleanup tests (#277)

## Documentation

* Update readme file with module return value pattern (#263)


# kitems v0.5.0-beta

This is a major revision introducing module server return value (instead of triggers)

## Breaking changes

* Implement module server return value (#257, #258)
* Remove / turn triggers into functions (#259, #261, #262, #265)

## New features

* Ensure datetime continuity over read / write (#269)

## Bug fixes

* Crash when trying to delete latest attribute from the data model (#272)
* Data model admin table should display all attributes (#244)
* App crashes during create if logical attribute has no default value (#246)
* Update id attribute default function does not work (#248)
* Item file is created even if autosave is FALSE when creating a data model from the admin UI (#271)
* Id does not get the default function when creating a new data model (#249)
