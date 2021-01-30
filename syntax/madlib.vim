if exists("b:current_syntax")
    finish
endif

let b:current_syntax = "madlib"

syntax sync fromstart
syntax case match

setlocal foldmethod=indent
setlocal foldignore=

syntax keyword madNoBind         _
           \   nextgroup=madParens,madOperators

syntax keyword madInterface      interface
           \   nextgroup=madDataIdentifier
highlight link madInterface      Keyword

syntax keyword madInstance       instance
           \   nextgroup=madDataIdentifier
highlight link madInstance       Keyword 

syntax keyword madWhere          where is
           \   nextgroup=madParens,madBlock
highlight link madWhere          Keyword

syntax match   madIdentifier     "\v<[a-zA-z0-9_]+>"
           \   nextgroup=madAssignment,madOperators,madParens
highlight link madIdentifier     Identifier

syntax match   madNumber         "\v<\-?\d*\.?\d+>"
highlight link madNumber         Number

syntax match   madTypeSig
           \   "^\s*[_a-z][a-zA-Z0-9_']*#\?\(,\s*[_a-z][a-zA-Z0-9_']*#\?\)*\_s\+::\_s"
           \   contains=madWhere,madIdentifier,madOperators,madSeparator,madParens
highlight link madTypeSig        Typedef 

syntax match   madSeparator      "[,;]"
highlight link madSeparator      Noise

syntax match   madAssignment     "="
highlight link madAssignment     Operator

syntax match   madFatArrow       "=>"
highlight link madFatArrow       Operator

syntax match   madSkinnyArrow    "->"
highlight link madSkinnyArrow    Operator

syntax match   madOperators      "[-!#$%&\*\+/<>\?@\\^|~:.]\+\|\<_\>"
highlight link madOperators      Operator

syntax keyword madData           data 
           \   nextgroup=madDataIdentifier
highlight link madData           Keyword

syntax match   madTypeVar        contained /\<\K\k\+/
           \   skipwhite
highlight link madTypeVar        Constant

syntax match   madDataIdentifier "\<[A-Z][a-zA-Z0-9_']*\>" 
           \   nextgroup=madTypeVar,madOperators,madParens
highlight link madDataIdentifier TypeDef

syntax keyword madFrom           contained from
           \   skipwhite skipempty 
           \   nextgroup=madString
highlight link madFrom           Keyword

syntax match   madModuleComma    contained /,/
           \   skipwhite skipempty 
           \   nextgroup=madModuleKeyword,madModuleAsterisk,madModuleGroup
highlight link madModuleComma    Noise

syntax match   madModuleAsterisk contained /\*/
           \   skipwhite skipempty 
           \   nextgroup=madModuleKeyword,madFrom
highlight link madModuleAsterisk Special

syntax match   madModuleKeyword  contained /\<\K\k*/
           \   skipwhite skipempty 
           \   nextgroup=madFrom,madModuleComma
highlight link madModuleKeyword  Keyword

syntax keyword madExport         export
highlight link madExport         Underlined

syntax keyword madImport         import
           \   skipwhite skipempty 
           \   nextgroup=madModuleKeyword,madModuleGroup
highlight link madImport         Keyword

syntax match   madComment        "\v\/\/.*$"
highlight link madComment        Comment

syntax keyword madTodo           TODO
           \   contained
           \   containedin=madBlockComment,madComment
highlight link madTodo           Todo

syntax region  madBlockComment
           \   start="/\*" end="\*/"
           \   contains=madTodo,@Spell
highlight link madBlockComment   Comment

" STRINGS & REGULAR EXPRESSIONS
" syntax region  madTemplateExpression
"            \   contained
"            \   matchgroup=madTemplateBraces
"            \   start=+${+
"            \   end=+}+
"            \   contains=@madExpression
"            \   keepend

syntax match   madSpecial        contained
           \   "\v\\%(x\x\x|u%(\x{4}|\{\x{4,5}})|c\u|.)"
highlight link madSpecial        Identifier
syntax region  madString
           \   start=+\z(["']\)+
           \   skip=+\\\%(\z1\|$\)+
           \   end=+\z1+
           \   end=+$+
           \   contains=madSpecial
           \   extend
highlight link madString         String
syntax region  madTemplateString
           \   start=+`+
           \   skip=+\\`+
           \   end=+`+
           \   contains=madSpecial
           \   extend
highlight link madTemplateString         String
syntax match   madTaggedTemplate   /\<\K\k*\ze`/ nextgroup=madTemplateString
highlight link madTaggedTemplate         Identifier

syntax keyword madBool                   true false
highlight link madBool                   Boolean

syntax region  madModuleGroup    contained
           \   start=/{/ end=/}/   
           \   skipwhite skipempty
           \   matchgroup=madModuleBraces
           \   contains=madModuleKeyword,madModuleComma,madComment
           \   nextgroup=madFrom
           \   fold
syntax region  madParens
           \   matchgroup=madDelimiter
           \   start="(" end=")" 
           \   contains=TOP,@madTypeSig,@Spell
syntax region  madBrackets
           \   matchgroup=madDelimiter
           \   start="\[" end="]" 
           \   contains=TOP,@madTypeSig,@Spell
syntax region  madBlock
           \   matchgroup=madDelimiter
           \   start="{" end="}" 
           \   contains=TOP,@Spell

syntax region  madFenceBounded
           \   start='#-' end='-#'
highlight link madFenceBounded   Todo 
syntax region  madFenceUnbounded
           \   start='^#-' end='-#'
highlight link madFenceUnbounded Error
 
