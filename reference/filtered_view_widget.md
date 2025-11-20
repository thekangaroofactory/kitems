# Filtered View Widget

Filtered View Widget

## Usage

``` r
filtered_view_widget(id)
```

## Arguments

- id:

  the id of the module server instance

## Value

a rendered DT data table

## Examples

``` r
filtered_view_widget(id = "mydata")
#> <div class="shiny-panel-conditional" data-display-if="document.getElementById(&quot;mydata-filtered_view&quot;).children.length==0" data-ns-prefix="">
#>   <p>All attributes are filtered, the table is empty.</p>
#> </div>
#> <div class="datatables html-widget html-widget-output shiny-report-size html-fill-item" id="mydata-filtered_view" style="width:100%;height:auto;"></div>
```
