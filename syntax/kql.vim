" Kusto Query Language (KQL) vim syntax definition
" Borrowed from https://github.com/josin/kusto-syntax-highlighting/blob/master/syntaxes/kusto.tmLanguage

if exists("b:current_syntax")
  finish
endif

syntax keyword kqlFunctions let count ingestion_time and or max min iff isempty
syntax keyword kqlFunctions isnotempty log sum extract now false true makeset makelist
syntax keyword kqlFunctions any dcount sumif countif avg materialize pack database strcat
syntax keyword kqlFunctions substring tostring toscalar strlen 'contains' in startswith
syntax keyword kqlFunctions endswith split typeof translate any arg_max arg_min
syntax keyword kqlFunctions extractjson between parse isnotnull

syntax keyword kqlControl where summarize extend mvexpand project sort project on by
syntax keyword kqlControl project-away join union limit order sort top print datatable

highlight default link kqlFunctions Function
highlight default link kqlControl   Statement

let b:current_syntax = "kql"
