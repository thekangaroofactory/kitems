# Date slider Widget

Date slider Widget

## Usage

``` r
date_slider_widget(id)
```

## Arguments

- id:

  the server module id

## Value

a ui object (output of fluidRow)

## Examples

``` r
date_slider_widget(id = "mydata")
#> <div style="display: inline-block; vertical-align:middle; margin-right:40px;">
#>   <div class="form-group shiny-input-container" style="width:300px;">
#>     <label class="control-label" id="mydata-date_slider-label" for="mydata-date_slider">Date</label>
#>     <input class="js-range-slider" id="mydata-date_slider" data-skin="shiny" data-type="double" data-min="1763856000000" data-max="1763856000000" data-from="1763856000000" data-to="1763856000000" data-step="86400000" data-grid="true" data-grid-num="NaN" data-grid-snap="false" data-prettify-separator="," data-prettify-enabled="true" data-keyboard="true" data-drag-interval="true" data-data-type="date" data-time-format="%F"/>
#>   </div>
#> </div>
#> <div style="display: inline-block; vertical-align:middle;">
#>   <div id="mydata-date_slider_strategy" class="form-group shiny-input-radiogroup shiny-input-container shiny-input-container-inline" role="radiogroup" aria-labelledby="mydata-date_slider_strategy-label">
#>     <label class="control-label" id="mydata-date_slider_strategy-label" for="mydata-date_slider_strategy">Strategy</label>
#>     <div class="shiny-options-group">
#>       <label class="radio-inline">
#>         <input type="radio" name="mydata-date_slider_strategy" value="this-year" checked="checked"/>
#>         <span>this-year</span>
#>       </label>
#>       <label class="radio-inline">
#>         <input type="radio" name="mydata-date_slider_strategy" value="keep-range"/>
#>         <span>keep-range</span>
#>       </label>
#>     </div>
#>   </div>
#> </div>
```
