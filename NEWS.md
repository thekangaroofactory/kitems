
# kitems 0.8.0.9000

The update is a patch on top of v0.8.0 to cover the following critical issues:

- Tests fail on MacOS (#905)
- Module server won't start right after data model migration to YAML config (#909)
- The path to the items should be relative to the R_KITEMS_PATH environment variable (#911)


# kitems v0.8.0

The revision is an extensive review of the package functions & core concepts.
It introduced a YAML config instead of the old data.model as well as package grammar.
A new Admin Console has been delivered.
Also many core & performance improvements have been delivered.

## [v0.8.x] Rework QA test coverage

QA test coverage has been updated and deeply reworked to cover the new YAML config
and grammar approach.

## [v0.8.x] Documentation upgrade

The documentation has been reviewed and updated with new articles related to
features introduced in this version.

## [v0.8.x] Upgrade kitems admin app

The Admin Console has been completely reworked to support the new YAML config
approach.

## [v0.8.x] Extend package grammar

-   Rename worlflow functions (#848)
-   config I/O functions should not be exported (#849)
-   items function should not be exported (#850)
-   Check functions should remain internal (#851)
-   Update function doc & run tests (#852)

## [v0.8.x] Introduce package grammar

-   Implement design verb (#752)
-   Diffuse impacts on the main module server (#746)
-   Merge single & multiple item creation in design function (#762)
-   Merge single & multiple attribute creation in design function (#763)
-   Make sure design returns something if no instruction is understood (#767)
-   Merge item & item in design (#768)
-   Implement recursive call to run several instructions at once (#769)
-   Implement extend verb (#771)
-   Implement amend verb (#772)
-   Implement shrink verb (#773)
-   Implement the skip grammar (#780)
-   Implement the refresh grammar (#785)
-   Implement hide grammar (#787)
-   Implement a getter function for sort (#790)
-   Allow organize to work with YAML config (#791)
-   Upgrade check verb to YAML config (#794)
-   Implement default implicit value for item argument (#795)
-   Replace name & url functions by name (#801)
-   Drop unused / obsolete functions

## [v0.8.x] Implement YAML config approach

-   Implement is_item and is_attribute functions (#778)
-   config_attribute_append should check if item exists (#756)
-   Implement config_read function (#681)
-   Implement config_write function (#683)
-   Use config_read in module server (#684)
-   Add version to the YAML config file (#686)
-   Implement dm_to_yaml migration function (#689)
-   Add an item description field in the YAML configuration file (#697)
-   Implement an config_item function (#702)
-   config_item_create should check that id is a character string (#753)
-   config_item_append should test for NULL in ... (#754)
-   config_attribute_create should check type (#755)
-   config_attribute_append should secure from adding attribute if there is no item (#757)
-   config_attribute_append should check for duplicated attribute name(s) (#758)
-   Implement is_config function (#759)
-   Design should sent item to config_attribute_append even if there is a single item (#761)
-   config_item_append should secure from duplicated item id (#764)
-   hide, skip & refresh should be handled by specific functions (#765)
-   Allow multiple attributes in config_attribute_append (#766)
-   config_item_create should manage the mandatory id attribute (#760)
-   config_create should check project length (#770)
-   Drop functions need to be secured against non existing objects (#774)
-   Warning about missing item should be raised by config_item_position (#775)
-   Map config functions with levels & return values (#776)
-   Implement skip core functions (#777)

## [v0.8.x] Improve kitems module server

-   Warning in test-server_date_slider.R (#615)
-   Date slider widget should return NULL when there is no items (#580)
-   Implement save workflow for data model & items (#546)
-   Rename trigger into workflow (#529)
-   Allow trigger to get a reactive callback parameter (#509)
-   Should module server function return an OOP object (#448)
-   Implement YAML config file (#677)
-   Make trigger & filter reactive objects conditional (#678)
-   Send timestamp along with trigger action to ensure unicity (#679)
-   Check data model integrity won't work when admin mode is ON (#682)
-   data model save should be dropped from the main module (#680)
-   Check if path & options should be overwritten by the config (#732)
-   Call to the kitems_admin module should be dropped (#745)
-   Use connector from the config to manage the items (#804)
-   Factorize code (#805)
-   Check usage of as_default (#807)
-   Conditional filters not fully implemented (#831)
-   get_context function returns NULL (#832)
-   Improve conditional observers (#833)
-   Item dialog shows only the first attribute's input (#835)
-   Autosave is broken (#836)
-   Update dialog is not displayed (#837)
-   Wrong values in item form upon update (#838)
-   Error in trigger_update_dialog (#839)
-   Date value is not recognized in the update dialog (#840)
-   Error in trigger_delete_dialog (#841)
-   trigger_event should check if value has expect shape (#842)
-   ktools::date_range is deprecated (#843)
-   Error in eventReactiveValueFunc: objet 'date_expr' (#844)
-   Module server crashes if the item file does not exist (#853)
-   Use of limit() is ignored in the item form (#855)
-   Secure compute within tryCatch (#856)
-   Date filter is empty when a date value is missing (#857)
-   Implement validation step (#858)
-   Insert fails when items is NULLSomething isn't working (#861)

## [v0.8.x] Improve item management

-   Update does not work with POSIXct attribute (#676)
-   Review intem_integrity function (#675)
-   Implement wrapper around check data.model & items (#674)
-   Review item_migrate function (#673)
-   Save function should rely on a connector object parameter (#672)
-   Load function should rely on a connector object parameter (#671)
-   attribute_values function should return a data.frame object (#670)
-   Error when migrating a data.model (#669)
-   Manage impacts of the reworked item workflows (#668)
-   dm_mask function should be extended to items (#667)
-   Turn item_mask function into item_reveal (#666)
-   Cleanup rows_update function (#665)
-   Cleanup rows_insert function (#664)
-   Factorize attribute_values function (#663)
-   Implement prepare_values function (#662)
-   Review the item_input_values function (#661)
-   Drop attribute_suggestion function (#660)
-   Filter skip & refresh columns in dm_default (#658)
-   Factorize firing dialog from button or trigger (#653)
-   Implement attribute values computation (#659)
-   Maybe dm_default should include skip (#657)
-   Implement function to turn an item into default values for the inputs (#656)
-   Check supported types for double (#655)
-   Drop check in attribute_input function (#654)
-   Rework the item input workflow (#652)
-   Drop item_search function (#650)
-   Drop shortcut from kitems server options (#649)
-   Drop attribute_input_update function (#648)
-   Drop attribute_shortcut function (#647)
-   attribute_input function should take attribute name and type as separate arguments (#646)
-   attribute_shortcut misses to call the new convert function (#623)
-   rows_update function should not check value for id (#620)
-   Improve default value workflow (#598)
-   attribute_values should be renamed into item_values (#569)
-   attribute_suggestion could return without executing all tests (#566)
-   Throw warning whenever additional names are found in values vs data model (#516)
-   Parameter items should be optional in item_form function since shortcut is FALSE by default (#429)
-   Implement item recommendation (#322)
-   Implement an overview table of the data (#270)

## [v0.8.x] Improve data model management

-   Merge default.val and default.fun into a unique column (#651)
-   Enable data-masking support to generate default values (#643)
-   Implement lifecycle mechanism (#293)
-   Add created_at and updated_at attributes to the data model template (#440)
-   Implement option to force update skipped attributes (#441)
-   Data model & items integrity fix should be done in admin console (#562)
-   Implement values mechanism (#594)
-   Allow format for POSIXct attributes (#510)
-   Move data model template to data-raw folder (#617)
-   Improve dm_colClasses function (#618)
-   attribute_delete function should return a data.model (#619)
-   Improve the data model builder function (#621)
-   Upgrade data model migration function (#624)
-   Upgrade integrity check (#625)
-   The function should detect if the expected output is a data.model or a single attribute (#627)
-   Improve the attribute builder function (#630)
-   Integrity check should check data.model structure (#632)
-   Autosave should handle NULL data.model & items (#633)
-   Improve attribute_update function (#634)
-   Improve dm_version function (#635)
-   Improve hide / show workflow (#636)
-   Implement helpers to set or unset skip & refresh (#637)
-   Make sure id attribute cannot be refreshed upon update (#638)
-   Implement organize function (#639)
-   Should TEMPLATE_DATA_MODEL be kept (#640)
-   Update package version (#631)

## [v0.8.x] Miscellaneous improvements (warm-up)

-   Converge trace mechanism (#482)
-   Reorganize module server function signature (#528)
-   Allow notifications to be turned off (#500)
-   Add type in the data model template (#407)
-   Deprecate dynamic_sidebar function (#571)
-   Rename attribute_value into attribute_values (#568)
-   Factorize match options into a function (#613)
-   Drop items_url from the module server return value (#549)
-   Update id in the data model template (#614)
-   Update argument should be replaced by workflow in item_form function (#572)
-   Update backup & restore function signatures (#609)
-   Remove factor from supported types (#544)

## [v0.8.x] Improve path management

-   Replace kitems_path option by R_KITEMS_PATH environment variable (#450)
-   Secure path function parameter (#514)
-   Remove new url in check path section (#532)
-   Implement data path environment variable (#535)
-   Path should be handled in a non ambiguous way (#563)
-   Check use of shiny options for path in admin function (#576)
-   Drop path parameter from the admin function signature (#425)
-   Update documentation about path (#606)
-   Check if path argument is needed in kitems_admin function (#607)
-   Update test coverage (#608)
-   Factorize path checks into a dedicated function (#610)
-   Factorize building filenames into helper functions (#612)


# kitems v0.7.3-beta

The milestone mostly contains bug fixes.

## Bug Fix

-   Create item workflow fails with no default for Date attribute (#588)
-   filtered_items are still initialized with all items (#589)
-   Launching kitems module with initialized filter is ignored (#590)
-   Date filter is applied even when the dateSliderInput is not implemented (#591)
-   Only first expression is applied (#593
-   Admin console crashes when no column is selected for display (#595)
-   Data model file is scrached when no column is selected for the table view (#596)
-   Warnings are displayed in the console at module server startup (#597)
-   Only first expression is applied at main level (#601)

## Documentation

-   Update package version (#600)
-   Update roadmap article (#602)
-   Roadmap link is broken (#603)

# kitems v0.7.2-beta

The milestone focuses on the package documentation & website.\
Many articles have been added to cover the core concepts of the framework as well as the features.

## Demo

-   Drop nested module example (#494)
-   Upgrade demo app (#574)
-   Upgrade from scratch demo example (#575)

## Documentation

-   Implement get started page (#539)
-   Update & cleanup readme (#550)
-   Update changelog with data model upgrades (#554)
-   Review functions documentation (#560)

## Articles

-   Update limitations article (#559)
-   Update filtering article to fit with v0.7.1 concepts (#495)
-   Add article to cover core concepts (#523)
-   Add article to cover shiny module delivery (#545)
-   Implement admin article (#527)
-   Add article to describe the different implementations (#435)
-   Add article to describe workflows (#512)
-   Add article to describe communication architecture (#513)
-   Add ordering article (#561)
-   Add an article to cover shortcuts (#547)
-   Add an environment article (#555)
-   Add roadmap article (#558)

## Miscellaneous

-   Implement light / dark mode in package documentation (#541)
-   Add author link to footer (#543)
-   Organize articles per sections (#538)
-   Group function reference into sections (#387)

## Bug Fix

-   Migrate button is displayed when creating a data model from scratch (#578)
-   Hidden attributes are displayed in admin console (#577)
-   The item view message is wrong when there is no item (#581)
-   The item view displays an error when there is no attribute to display(#582)
-   An error is displayed after the empty item table message (#579)
-   Create item fails after creating a data model from scratch (#583)
-   Error is raised when data model has no date attribute but widget is in the UI (#585)
-   Data.table popup error is displayed in the admin UI about missing Id column (#586)

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
