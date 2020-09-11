" Kusto Query Language (KQL) vim syntax definition
" Created from https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/

if exists("b:current_syntax")
  finish
endif

syntax match kqlComment /\v\/\/.*$/

" TODO: datetime format parsing, create group and link to ??
" TODO: float formats, link to Float
" TODO: dynamic array/property access notation
" TODO: dynamic literal format?
" TODO: guid format
" TODO: number format?
" TODO: long format? I think the default format is long for bare numbers...
" TODO: Other real/double literals
" TODO: timespan literals (spaces aren't as strict as the docs suggest...)
syntax keyword kqlTypes bool boolean datetime date decimal dynamic
syntax keyword kqlTypes guid uuid uniqueid int long real double
syntax keyword kqlTypes string timespan time
syntax keyword kqlBoolean true false

" Handle things like real(NaN)
syntax match kqlReal /\v((real|double)\()@<=(nan|NaN|\+inf|-inf)/

" Generic string matching - nothing continues across lines.
syntax region kqlString start=/"/ skip=/\\"/ end=/"/ oneline contains=kqlStringSpecial
syntax region kqlObfuscatedString start=/\v(h|H)"/ skip=/\\"/ end=/"/ oneline contains=kqlStringSpecial

syntax region kqlString start=/'/ skip=/\\'/ end=/'/ oneline contains=kqlStringSpecial
syntax region kqlObfuscatedString start=/\v(h|H)'/ skip=/\\'/ end=/'/ oneline contains=kqlStringSpecial

" These are the only escapes I know right now.
syntax match kqlStringSpecial /\v\\(t|n)/ contained

" A string prefixed with '@' cannot escape anything, so there's nothing to skip.
syntax region kqlString start=/@"/ end=/"/ oneline
syntax region kqlObfuscatedString start=/\v(h|H)\@"/ end=/"/ oneline
syntax region kqlString start=/@'/ end=/'/ oneline
syntax region kqlObfuscatedString start=/\v(h|H)\@'/ end=/'/ oneline

syntax keyword kqlNull null
syntax keyword kqlUnsupportedTypes float int16 uint16 uint32 uint64 uint8

" TODO: database["foo"] or database foo must come after alias
" TODO: 'view' keyword, as in 'let foo = view () { range ... }' - note, no args.
syntax keyword kqlStatement alias let set

" https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/patternstatement
" If I understand correctly (and I may not), you can:
" `declare pattern name` on one line
" `declare\npattern\nname` on multiple lines, but no intervening newlines
" Tokens must be separated by at least one whitespace character, unless it's the start of a line.
syntax match kqlPatternStatement /declare\(\s\+\|\n\s*\)pattern\(\s\+\|\n\s*\)/
" TODO: pattern definitions

" https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/queryparametersstatement
" Similar rules to `declare pattern`, but space before the actual parameters is optional.
syntax match kqlQueryParametersStatement /declare\(\s\+\|\n\s*\)query_parameters\n\?\s*/
" TODO: parameter definitions

" https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/restrictstatement
syntax match kqlRestrictAccessStatement /restrict\(\s\+\|\n\s*\)access\(\s\+\|\n\s*\)to\n\?\s*/
" TODO: restrict access definitions

" https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/tabularexpressionstatements
" TODO: can we disallow a starting pipe if the previous line ended in a
" semicolon? is that even wise?
syntax match kqlParen /\((\|)\)/
syntax match kqlColon /;/

" https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/asoperator
syntax keyword kqlOperator as
syntax match kqlOperatorHint /\(as\s\+\)\@<=hint\.materialized/

" https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/consumeoperator
syntax keyword kqlOperator consume
syntax match kqlOperatorHint /\(consume\s\+\)\@<=decodeblocks/

syntax keyword kqlOperator count distinct extend fork getschema invoke limit

" https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/datatableoperator
syntax match kqlOperator /\(|\s*\)\@<!datatable/

" https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/evaluateoperator
syntax keyword kqlOperator evaluate
syntax match kqlOperatorHint /\(evaluate.\+\)\@<=hint\.\(distribution\|pass_filters\(_column\)\?\)/
syntax match kqlOperatorHintValue /\(hint\.distribution\s*=\s*\)\@<=\(single\|per_\(node\|shard\)\)/

syntax match kqlEvaluatePlugin /\v(evaluate.+)@<=(autocluster|bag_unpack|basket|dcount_intersect|diffpatterns|diffpatterns_text|infer_storage_schema|narrow|pivot|preview|python|r|rolling_percentile|schema_merge|sql_request|sequence_detect)/

" https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/externaldata-operator
syntax match kqlOperator /\(|\s*\)\@<!externaldata/
syntax match kqlOperator /\(externaldata.*\)\@<=with\(\s*(\)\@=/

" https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/facetoperator
syntax keyword kqlOperator facet
syntax match kqlOperator /\(facet.*\)\@<=with\(\s*(\)\@=/

"https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/findoperator
" TODO: we could support this syntax a bit more.
syntax keyword kqlOperator find
syntax match kqlOperator /\(find.*\)\@<=in\(\s*(\)\@=/
syntax match kqlOperator /\(find.*in.*\)\@<=where/
syntax match kqlOperatorHint /\(find\s\+\)\@<=withsource/

" https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/joinoperator
syntax keyword kqlOperator join
syntax match kqlOperator /\(join.*\)\@<=on/
syntax match kqlOperatorHint /\(hint\.\(remote\|strategy\)\|kind\)/
syntax match kqlOperatorHintValue /\(kind\s*=\s*\)\@<=\(leftanti\(semi\)\?\|rightanti\(semi\)\?\|inner\(unique\)\?\|leftsemi\|rightsemi\|leftouter\|rightouter\|fullouter\)/

" https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/shufflequery
syntax match kqlOperatorHint /\(\(join\|summarize\|make-series\).*\)\@<=hint\.\(strategy\|shufflekey\)/
syntax match kqlOperatorHintValue /\(hint.strategy\s*=\s*\)\@<=shuffle/

" https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/joincrosscluster
syntax match kqlOperatorHintValue /\(hint.remote\s*=\s*\)\@<=\(left\|right\|local\|auto\)/

" https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/broadcastjoin
syntax match kqlOperatorHintValue /\(hint.strategy\s*=\s*\)\@<=broadcast/

" https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/lookupoperator
syntax keyword kqlOperator lookup
syntax match kqlOperatorHint /\(lookup.*\)\@<=kind/
syntax match kqlOperatorHintValue /\(lookup.*kind\s*=\s*\)\@<=\(leftouter\|inner\)/
syntax match kqlOperator /\(lookup.*\)\@<=on/

" https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/make-seriesoperator
syntax match kqlOperator /make-series/
syntax region kqlMakeSeries start=/\(make-series\)\@<=./ end=/\(;\||\)/me=e-1 contains=kqlMakeSeriesKeywords,kqlOperatorHint,kqlOperatorHintValue transparent
syntax keyword kqlMakeSeriesKeywords on from to step by containedin=kqlMakeSeries contained
syntax match kqlOperatorHint /\(make-series.*\)\@<=\(default\|kind\)/ containedin=kqlMakeSeries contained
syntax match kqlOperatorHintValue /\(make-series.*kind\s*=\s*\)\@<=nonempty/ containedin=kqlMakeSeries contained

syntax match kqlOperator /mv-apply/
syntax region kqlMvApply start=/\(mv-apply\)\@<=./ end=/\(on\s*(.\+)\)\@<=\(;\||\)/me=e-1 contains=kqlMvApplyKeywords,kqlOperatorHint transparent
syntax keyword kqlMvApplyKeywords to on limit containedin=kqlMvApply contained
syntax match kqlOperatorHint /\(mv-apply.*\)\@<=with_itemindex/ containedin=kqlMvApply contained

syntax match kqlOperator /mv-expand/
syntax region kqlMvExpand start=/\(mv-expand\)\@<=./ end=/\(;\||\)/me=e-1 contains=kqlMvExpandKeywords,kqlOperatorHint,kqlOperatorHintValue transparent
syntax keyword kqlMvExpandKeywords to limit containedin=kqlMvExpand contained
syntax match kqlOperatorHint /\(mv-expand.*\)\@<=\(with_itemindex\|bagexpansion\)/ containedin=kqlMvExpand contained
syntax match kqlOperatorHintValue /\(mv-expand.*bagexpansion\s*=\s*\)\@<=\(bag\|array\)/ containedin=kqlMvExpand contained

syntax match kqlOperator /order by/
syntax match kqlOperator /\(order by .\+\)\@<=\(asc\|desc\|nulls first\|nulls last\)/

" syntax region kqlStatement start=/^/ end=/;/ transparent contains=CONTAINED
syntax match kqlPipe /\(|\s*\)\@<!|/


" TODO: operators
" boolean: == != and or
" dynamic: in !in
" union

" TODO: variables (both in 'let' expressions, and also perhaps in user-defined
" function args)
" TODO: user-defined functions highlighted as functions

" Types
highlight default link kqlTypes             Type
highlight default link kqlUnsupportedTypes  Error

" Literals
highlight default link kqlBoolean   Boolean
highlight default link kqlReal      Float
highlight default link kqlNull      Special

highlight default link kqlString    String
highlight default link kqlStringSpecial SpecialChar
highlight default link kqlObfuscatedString Character

highlight default link kqlPatternStatement          kqlStatement
highlight default link kqlQueryParametersStatement  kqlStatement
highlight default link kqlRestrictAccessStatement   kqlStatement
highlight default link kqlStatement Statement

highlight default link kqlPipe    kqlPunctuation
highlight default link kqlParen   kqlPunctuation
highlight default link kqlColon   kqlPunctuation
highlight default link kqlPunctuation Statement

highlight default link kqlEvaluatePlugin kqlOperator
highlight default link kqlMakeSeriesKeywords kqlOperator
highlight default link kqlMvApplyKeywords kqlOperator
highlight default link kqlMvExpandKeywords kqlOperator

highlight default link kqlOperator            Function
highlight default link kqlOperatorHint        PreProc
highlight default link kqlOperatorHintValue   Special

highlight default link kqlComment  Comment

let b:current_syntax = "kql"
" Some patterns span newlines, and it's hard to keep in sync. Since kql files
" should generally not be that long, let's force a re-parse from the start
" during editing operations.
syntax sync fromstart
