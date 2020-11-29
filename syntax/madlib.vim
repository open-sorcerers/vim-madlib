" Vim syntax file
" Language:     madlib 
" Maintainer:   open-sorcerers
" URL:          https://github.com/open-sorcerers/vim-madlib


if !exists("main_syntax")
  let main_syntax = 'madlib'
endif

" BEM syntax is base__element--modifier
" here we're using {prefix}{name}[_cl{cluster}][_re{region}][_tag{tag}][_hi{highlight}]
" i.e. a comma (called "thing" below) can be anywhere, but is contained, its name should be:
" , madThing_clRoot_hiNoise -- meaning the Root cluster and `hi def link xxx Noise`
" equivalent forms:
" , madThing_hiNoise -- clRoot is the default cluster
" more examples
" . madDot_hiNoise_hiNoise
" = madEqual_hiNoise


syntax sync fromstart
syntax case match

syntax match   madComma_hiNoise +,+ 
syntax match   madDot_hiNoise   /\./ skipwhite skipempty nextgroup=madProperty,madMethodCall
syntax match   madAssignment_hiOperator +=+ skipwhite skipempty nextgroup=@madCluster_tagExpression
syntax match   madSpread_hiOperator +\.\.\.+ skipwhite skipempty nextgroup=@madCluster_tagExpression

" BRACES / PARENS
syntax match   madParens_tagInvalid_hiError /[)}\]]/
syntax region  madParens_reParens_hiOperator start='('  end=')' skipwhite skipempty contains=@madCluster_tagExpression extend fold
syntax region  madBrace_reBrace_hiNoise start='{' end='}' contains=@madCluster_tagExpression

" PATTERN MATCHING
syntax keyword madWhere_hiKeyword where

" NUMBERS
syntax match   madNumber_hiFloat /\c\<\%(\d\+\.\d\+\|\d\+\.\|\.\d\+\)\%(e[+-]\=\d\+\)\=\>/

" BOOLEANS
syntax keyword madTrue_hiKeyword true
syntax keyword madFalse_hiKeyword false 

" OPERATORS
syntax match   madPipe_hiOperator /|>/ skipempty skipwhite nextgroup=@madCluster_tagExpression
syntax match   madFatArrow_hiOperator /=>/ skipempty skipwhite nextgroup=@madCluster_tagExpression,madParens_reParens_hiOperator
syntax match   madStar_hiOperator '*'  skipempty skipwhite nextgroup=@madCluster_tagExpression
syntax match   madPercent_hiOperator '%'  skipempty skipwhite nextgroup=@madCluster_tagExpression
syntax match   madSlash_hiOperator '/'  skipempty skipwhite nextgroup=@madCluster_tagExpression
syntax match   madPlus_hiOperator '+'  skipempty skipwhite nextgroup=@madCluster_tagExpression
syntax match   madPlusPlus_hiOperator '++'  skipempty skipwhite nextgroup=@madCluster_tagExpression
syntax match   madEquivalent_hiOperator '=='  skipempty skipwhite nextgroup=@madCluster_tagExpression
syntax match   madGreaterThan_hiOperator '>'  skipempty skipwhite nextgroup=@madCluster_tagExpression
syntax match   madGreaterThanEqual_hiOperator '>='  skipempty skipwhite nextgroup=@madCluster_tagExpression
syntax match   madLessThanEqual_hiOperator '<='  skipempty skipwhite nextgroup=@madCluster_tagExpression
syntax match   madLessThan_hiOperator '<'  skipempty skipwhite nextgroup=@madCluster_tagExpression

" read ! cat syntax/madlib.vim | node consumeSyntax.js | snang -iP "filter(pathEq(['structure', 'hi'], 'Operator')) | map(prop('name')) | join(',') | z => 'syntax cluster madOperator contains=' + z"
syntax cluster madOperator contains=madAssignment_hiOperator,madSpread_hiOperator,madParens_reParens_hiOperator,madPipe_hiOperator,madFatArrow_hiOperator,madStar_hiOperator,madPercent_hiOperator,madSlash_hiOperator,madPlus_hiOperator,madPlusPlus_hiOperator,madEquivalent_hiOperator,madGreaterThan_hiOperator,madGreaterThanEqual_hiOperator,madLessThanEqual_hiOperator,madLessThan_hiOperator,madTypeAssignment_tagTypeDef_hiOperator,madTypeDef_tagTypeDef_hiOperator,madTypeYields_tagTypeDef_hiOperator

" TYPES
syntax keyword madType_tagTypeDef_hiKeyword type skipempty skipwhite nextgroup=madType
syntax keyword madData_tagTypeDef_hiKeyword data skipempty skipwhite nextgroup=madComplexType,@madCluster_tagGlobalType

syntax keyword madTypeString_tagGlobalType_hiConstant String skipempty skipwhite nextGroup=@madTypeExpression
syntax keyword madTypeBoolean_tagGlobalType_hiConstant Boolean skipempty skipwhite nextGroup=@madTypeExpression
syntax keyword madTypeNumber_tagGlobalType_hiConstant Number skipempty skipwhite nextGroup=@madTypeExpression
syntax keyword madTypeList_tagGlobalType_hiConstant List skipempty skipwhite nextGroup=@madTypeExpression

syntax cluster madCluster_tagGlobalType contains=madTypeString_tagGlobalType_hiConstant,madTypeNumber_tagGlobalType_hiConstant,madTypeBoolean_tagGlobalType_hiConstant,madTypeList_tagGlobalType_hiConstant

syntax match   madTypeAssignment_tagTypeDef_hiOperator /=/ nextgroup=@madTypeExpression
syntax match   madTypeDef_tagTypeDef_hiOperator /::/ skipempty skipwhite nextgroup=@madTypeExpression,@madCluster_tagGlobalType
syntax match   madTypeYields_tagTypeDef_hiOperator /->/ skipempty skipwhite nextgroup=@madTypeExpression,@madCluster_tagGlobalType
syntax match   madComplexType "[A-Z][a-zA-z0-9_']*" contained nextgroup=madTypeAssignment_tagTypeDef_hiOperator,@madCluster_tagGlobalType
syntax match   madType_tagTypeDef_hiIdentifier contained /\<\K\k*/ skipwhite skipempty nextgroup=@madTypeExpression,@madCluster_tagGlobalType

syntax cluster madTypeExpression contains=madTypeDef_tagTypeDef_hiOperator,madTypeYields_tagTypeDef_hiOperator,madVar_hiIdentifier,madParens_reParens_hiOperator,madComplexType,madType

" COMMENTS
syntax region  madComment_hiComment start=+//+ end=/$/ extend keepend

" IDENTIFIERS
syntax match   madVar_hiIdentifier /^\K\k\+/ skipwhite nextgroup=madAssignment_hiOperator,madParens_reParens_hiOperator,madComma_hiNoise,madDot_hiNoise,madBrace_reBrace_hiNoise
syntax match   madVar_tagTypeDef_hiIdentifier /<\K\k\+/ skipwhite nextgroup=madTypeAssignment_tagTypeDef_hiOperator,madVar_tagTypeDef_hiIdentifier

" STRINGS
syntax region  madString_reString_hiString              start=+\z(["']\)+  skip=+\\\%(\z1\|$\)+  end=+\z1+ end=+$+ extend
syntax region  madString_reString_tagTemplate_hiString      start=+`+  skip=+\\`+  end=+`+     contains=madString_reString extend
syntax region  madString_reString  contained matchgroup=madTemplateBraces start=+${+ end=+}+ contains=@madCluster_tagExpression keepend

" IMPORTS
syntax keyword madImport_tagImport_hiKeyword import skipwhite skipempty nextgroup=madImport_tagImport_hiIdentifier,madBraceBlock
syntax match   madImport_tagImport_hiIdentifier /\k\+/ skipwhite skipempty nextgroup=madBrace_reBrace_hiNoise,madImportFrom_tagImport_hiKeyword,madComma_hiNoise
syntax keyword madImportFrom_tagImport_hiKeyword from skipwhite skipempty nextgroup=madString

syntax cluster madCluster_tagImport contains=madImport_tagImport_hiKeyword,madImport_tagImport_hiIdentifier,madImportFrom_tagImport_hiKeyword

" FENCE
syntax region  madFence_hiTodo        start='#-' end='-#'
syntax region  madFence_hiError      start='^#-' end='-#'

" SNANG RULES
" get keywords
" :%w !snang -P "split(C.n) | filter(startsWith('syntax')) | groupBy((z) => z.split(' ').map(trim)[1]) | prop('keyword') | map(pipe(split(' ') | nth(2))) | map(z => 'hi def link ' + z + '      Keyword') | j2"
" :read !cat syntax/madlib.vim | snang -P "split(C.n) | filter(startsWith('syntax')) | groupBy((z) => z.split(' ').map(trim)[1]) | prop('keyword') | map(pipe(split(' ') | nth(2))) | map(z => 'hi def link ' + z + '      Keyword') | join('\n')"
" get matches
" :%w !snang -P "split(C.n) | filter(startsWith('syntax')) | groupBy((z) => z.split(' ').map(trim)[1]) | prop('match') | map(pipe(split(' ') | filter(I) | nth(2)))" -o
" :read !cat syntax/madlib.vim | snang -P "split(C.n) | filter(startsWith('syntax')) | groupBy((z) => z.split(' ').map(trim)[1]) | prop('match') | map(pipe(split(' ') | filter(I) | nth(2))) | map(z => 'hi def link ' + z + '            Constant') | join('\n')"

" regenerate!
" read ! cat syntax/madlib.vim |  node consumeSyntax.js | node generateHighlights.js
hi def link madComma_hiNoise Noise
hi def link madDot_hiNoise Noise
hi def link madAssignment_hiOperator Operator
hi def link madSpread_hiOperator Operator
hi def link madParens_reParens_hiOperator Operator
hi def link madBrace_reBrace_hiNoise Noise
hi def link madWhere_hiKeyword Keyword
hi def link madNumber_hiFloat Float
hi def link madTrue_hiKeyword Keyword
hi def link madFalse_hiKeyword Keyword
hi def link madPipe_hiOperator Operator
hi def link madFatArrow_hiOperator Operator
hi def link madStar_hiOperator Operator
hi def link madPercent_hiOperator Operator
hi def link madSlash_hiOperator Operator
hi def link madPlus_hiOperator Operator
hi def link madPlusPlus_hiOperator Operator
hi def link madEquivalent_hiOperator Operator
hi def link madGreaterThan_hiOperator Operator
hi def link madGreaterThanEqual_hiOperator Operator
hi def link madLessThanEqual_hiOperator Operator
hi def link madLessThan_hiOperator Operator
hi def link madType_tagTypeDef_hiKeyword Keyword
hi def link madData_tagTypeDef_hiKeyword Keyword
hi def link madTypeString_tagGlobalType_hiConstant Constant
hi def link madTypeBoolean_tagGlobalType_hiConstant Constant
hi def link madTypeNumber_tagGlobalType_hiConstant Constant
hi def link madTypeList_tagGlobalType_hiConstant Constant
hi def link madTypeAssignment_tagTypeDef_hiOperator Operator
hi def link madTypeDef_tagTypeDef_hiOperator Operator
hi def link madTypeYields_tagTypeDef_hiOperator Operator
hi def link madType_tagTypeDef_hiIdentifier Identifier
hi def link madComment_hiComment Comment
hi def link madVar_hiIdentifier Identifier
hi def link madVar_tagTypeDef_hiIdentifier Identifier
hi def link madString_reString_hiString String
hi def link madString_reString_tagTemplate_hiString String
hi def link madImport_tagImport_hiKeyword Keyword
hi def link madImport_tagImport_hiIdentifier Identifier
hi def link madImport_tagImport_hiIdentifier Identifier
hi def link madImportFrom_tagImport_hiKeyword Keyword
hi def link madFence_hiTodo Todo
hi def link madFence_hiError Error


syntax cluster madCluster_tagExpression contains=madNoise,madDot_hiNoise,madProperty,madMethod,madPipe_hiOperator,madVar_hiIdentifier,madBrace_reBrace_hiNoise,madString_reString_hiString,madString_reString_tagTemplate_hiString,madFence_hiTodo,@madOperators

syntax cluster madCluster_tagAll contains=@madCluster_tagImport,@madCluster_tagExpression,@madTypeExpression

syntax cluster madlib contains=@madCluster_tagAll

let b:current_syntax = "madlib"
if main_syntax == 'madlib'
  unlet main_syntax
endif
