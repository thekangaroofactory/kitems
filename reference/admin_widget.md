# Admin Widget

Admin Widget

## Usage

``` r
admin_widget(id)
```

## Arguments

- id:

  the module id

## Value

a tagList() object to admin the data model

## Examples

``` r
admin_widget(id = "mydata")
#> <div class="row">
#>   <div class="col-sm-2 well">
#>     <ul class="nav nav-pills nav-stacked" data-tabsetid="1133">
#>       <li class="navbar-brand">Administration console</li>
#>       <li class="active">
#>         <a href="#tab-1133-2" data-toggle="tab" data-bs-toggle="tab" data-value="Data model">Data model</a>
#>       </li>
#>       <li>
#>         <a href="#tab-1133-3" data-toggle="tab" data-bs-toggle="tab" data-value="Raw table">Raw table</a>
#>       </li>
#>       <li>
#>         <a href="#tab-1133-4" data-toggle="tab" data-bs-toggle="tab" data-value="View">View</a>
#>       </li>
#>     </ul>
#>   </div>
#>   <div class="col-sm-10">
#>     <div class="tab-content" data-tabsetid="1133">
#>       <div class="tab-pane active" data-value="Data model" id="tab-1133-2">
#>         <div class="well">
#>           <h3>Name:  mydata</h3>
#>           <div id="mydata-admin-dm_tab" class="shiny-html-output"></div>
#>         </div>
#>       </div>
#>       <div class="tab-pane" data-value="Raw table" id="tab-1133-3">
#>         <div class="well">
#>           <h3>Name:  mydata</h3>
#>           <div id="mydata-admin-raw_tab" class="shiny-html-output"></div>
#>         </div>
#>       </div>
#>       <div class="tab-pane" data-value="View" id="tab-1133-4">
#>         <div class="well">
#>           <h3>Name:  mydata</h3>
#>           <div id="mydata-admin-masked_tab" class="shiny-html-output"></div>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
```
