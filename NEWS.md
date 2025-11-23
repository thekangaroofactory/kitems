# kitems v0.7.1-beta

> **Important!**\
> This version requires a data model upgrade.

## New features

### Communication & workflows

#### Trigger

-   Allow trigger to get multiple events in one shot (#507)
-   Implement an event helper function (#506)

#### Filter

-   Implement filter reactive parameter (#320)
-   Remove filter_date reactive object (#531)
-   Implement filter layers (#496)
-   Replace filter_date element by filters in module server return value (#533)
-   Improve date_slider widget (#486)
-   date_slider_widget should return a basic ui object (#397)
-   Implement filter helper function (#530)

### Data-model

-   Rename filter into display (#392)
-   Improve data model migration procedure (#519)
-   Data model migration should be performed by the admin console (#524)
-   Implement package constant with latest data model migration required (#525)

## Misc

-   Upgrade demo app data model to version 0.7.1 (#520)

## Test coverage

-   Warning in test-server_attribute_wizard_update (#522)
-   Warning in test-server_date_slider (#521)

## Bug Fix

-   Passing reactiveVal to trigger will fire create dialog on start (#502)
-   A create item modal window is displayed upon module server startup (#511)
-   Remove date attribute test fails (#518)
-   Warning displayed in the console when sliderInput value is greater than max (#423)
-   Error when trying to delete an item with trigger (#517)

# kitems v0.7.0-beta

The milestone focuses on the communication strategy & item workflows This is a major milestone (would be a major version if not beta)

## Communication & workflows

-   Implement item create workflow (#457)
-   Implement item update workflow (#459)
-   Implement internal item workflow functions (#472)
-   Implement module server options (#447)
-   Implement options parameter (#465)
-   Drop item_create_modal function (#460)
-   Improve item selection to support triggers (#469)
-   Improve item_dialog to cover all workflows (#471)
-   Align item create workflow with update workflow (#489)
-   Create / Update workflows should be secured against failure (#477)
-   Rename item_delete into rows_delete (#492)

## Misc

-   Implement parameter check (#458)
-   Check how to avoid filtered items to be initialized with all items (#357)
-   Duplicated input / output IDs for date_slider (#485)
-   Remove item_chk_str function (#470)
-   Should filter_date be replaced by input\$date_slider (#466)
-   First in table selection is not kept (#483)
-   Check that functions don't get reactive values (#468)

## Test coverage

-   Implement expect functions (#476)

## Documentation

-   Upgrade existing documentation
-   Upgrade module server communication article
-   Deliver item workflows article

# kitems v0.6.1-beta

The milestone focuses on the migration to {iker} package instead of {kfiles}

## Migration to {iker}

-   Migrate item_load to {iker} (#412)
-   Migrate item_save function to {iker} (#411)
-   Migrate import_server function to {iker} (#414)
-   Delegate ISO-8601 datetime continuity to {iker} (#409)
-   Item load and save functions should now rely on connector wrapper functions (#424)
-   item_load function should take col.classes argument instead of data.model (#421)
-   Drop create parameter from item_load function signature (#419)
-   Drop create parameter from kitems function signature (#420)
-   Manage item_load impacts in kitems (#415)
-   Remove {kfile} from the package dependencies (#418)
-   kitems_admin should use {ktools} to create data (#413)

## Bug Fix

-   Item create fails when date attribute is left empty in the input form (#428)
-   Fatal error when creating an item with empty value for POSIXct attribute (#427)
-   Demo apps fail to start with error (#422)

# kitems v0.6.0-beta

The milestone focuses on package architecture & cleanup. Also a new trace mechanism is implemented to reduce outputs & improve performance.

## Misc

-   Check & cleanup exported functions (#354)
-   Rename widget functions (#382)
-   Rename admin_server into kitems_admin (#385)
-   Improve trace mechanism

## Bug Fix

-   Admin standalone app needs to be delivered in inst directory (#404)

# kitems v0.5.7-beta

The milestone focuses on the admin console, demo apps, documentation.

## New features

### Items

-   Filtered view should display a message when the table is empty (#362)

### Misc

-   Implement a specific app for the admin console (#355)
-   View tab should display a message when the table is empty (#358)
-   Split demo app into single use cases (#371)
-   Implement sub-folders to group item related files (#356)
-   Test coverage convergence (#353)

### Documentation

-   Implement module server return value vignette (#381)
-   Add motivations vignette (#379)

## Bug Fix

-   Error in if la condition est de longueur \> 1 in item_load (#359)
-   The module server return value filter_date is always NULLbug (#375)

# kitems v0.5.6-beta

The milestone focuses on item operations and introduces shortcuts for item creation

## New features

### Data-model

-   Check that attribute name does not contain blank space (#336)

### Items

-   Item creation should protect against duplicated id (#330)
-   item_add should secure that item has expected structure & types (#345)
-   item_delete should secure id parameter (#350)
-   item add, update and delete functions should work out of a reactive context (#347)
-   item add, update & delete should be secured by tryCatch (#351)
-   Implement search function (#254)
-   Implement value suggestion for item creation inputs (#295)

### Misc

-   Implement backup / restore mechanism (#294)
-   Cleanup range in date_slider section (#338)

### Documentation

-   Implement NEWS (#334)
-   Implement pkgdown & GitHub Page CI (#331)

## Bug Fix

-   Data model should be stored only once items have been migrated after adding an attribute (#324)
-   Error in if when trying to migrate items with a new POSIXct attribute (#325)
-   Need to double check that POSIXct column is there in the items before conversion (#326)
-   All attributes get skip & filter set to TRUE after import (#329)
-   item_search function needs to use .data (#328)
-   item_search throws a warning in tidyselect (#348)

# kitems v0.5.5-beta

The milestone focus is on code coverage

## New features

### Misc

-   Remove DT package import
-   Improve test coverage
-   Implement R-CMD-check CI (GitHub action)
-   Update codecov CI (GitHub action)

# kitems v0.5.4-beta

The milestone focus is on code architecture

## New features

### Data-model

-   Implement attribute_delete function (#309)
-   Externalize delete data model as functions(#308)
-   Externalize attribute wizard as a module (#307)

### Items

-   Reload items only if data model integrity check impacts them (#306)

### Misc

-   Externalize import as a module (#312)
-   Implement danger_zone_ui function (#310)

## Bug fix

### Data-model

-   Delete data model modal gets wrong confirmation string (#311)

# kitems v0.5.3-beta

The milestone focus is on code architecture

## New features

### Misc

-   Implement admin parameter in main server (#301)
-   Homogenize input / output names (#288)
-   Homogenize function names (#292)
-   Externalize admin in a dedicated shiny module (#301)
-   Code cleanup (#289)
-   Test coverage (#299)

# kitems v0.5.2-beta

> **Important!**\
> This version requires a data model upgrade.

The milestone focus is on data-model

## New features

### Data-model

-   Implement modal wizard to create or update data model's attribute (#281)
-   Support arguments in default_fun mechanism (#63)
-   Implement multiple ordering in the data model definition (#239)
-   Remove support of POSIXlt class (#280)
-   Improve support of POSIXct class (timezone, form, persistence, ISO-8601) (#253)
-   Implement delete data model (and manage impacts) (#282)
-   Deleting the last attribute of a data model cleans data model & items (#273)
-   Implement warning when autosave is turned off (#283)
-   Improve admin UI to show module vs nested module call (#250)

### Item

-   Check attribute type persistence during load (POSIXct, ISO-8601) (#177)

### Misc

-   Remove standard view (#278)
-   Update demo app to demonstrate module call vs nested module call (#241)

## Bug fix

### Data-model

-   Data model is saved after check integrity even if autosave is FALSE (#291)

### Item

-   Create button is still available after data model is deleted (#290)

### Misc

-   Deleting attribute date generates an error in filter / selected items (#287)
-   Date_slider is updated twice upon init app (#285)
-   Reorder column is called when initializing the admin UI (#284)

# kitems v0.5.1-beta

This is a minor revision focusing on code cleanup, test & documentation

## Code cleanup

-   Cleanup code (#275)
-   Update kitems_names.R to remove triggers, items, data model (#264)
-   Remove hard coded parameters for id (#219)
-   Turn trigger_create into a function
-   Remove r dependency and update server signature (#276)
-   Cleanup tests (#277)

## Documentation

-   Update readme file with module return value pattern (#263)

# kitems v0.5.0-beta

This is a major revision introducing module server return value (instead of triggers)

## Breaking changes

-   Implement module server return value (#257, #258)
-   Remove / turn triggers into functions (#259, #261, #262, #265)

## New features

-   Ensure datetime continuity over read / write (#269)

## Bug fixes

-   Crash when trying to delete latest attribute from the data model (#272)
-   Data model admin table should display all attributes (#244)
-   App crashes during create if logical attribute has no default value (#246)
-   Update id attribute default function does not work (#248)
-   Item file is created even if autosave is FALSE when creating a data model from the admin UI (#271)
-   Id does not get the default function when creating a new data model (#249)
