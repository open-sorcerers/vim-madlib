" Vim syntax file
" Language:     madlib 
" Maintainer:   open-sorcerers
" URL:          https://github.com/open-sorcerers/vim-madlib


if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'madlib'
endif

syntax sync fromstart
syntax case match

syntax keyword madOperatorKeyword     import export from             skipwhite

" syntax region  madDataDefinition      contains=madData,madDataAssignment,madDataOr,madTypeContainer,madTypeVariable
" syntax region  madTypeDefinition      contains=madTypeDef,madTypeContainer,madTypeVariable,madDataNext

syntax keyword madDataKeyword         data                 skipwhite nextgroup=madDataTypeContainer,madDataTypeVariable
syntax match   madDataTypeContainer                        contained /\<\K\k\+/ skipwhite nextgroup=madDataTypeVariable,madDataOr,madDataAssignment
syntax match   madDataTypeVariable                         contained /\<\K\k\+/ skipwhite nextgroup=madDataOr,madDataAssignment 
syntax match   madDataAssignment      /=/                  contained skipwhite skipempty nextgroup=madDataParens,madDataTypeContainer,madDataTypeVariable
syntax match   madDataParens          "[()]"               contained skipwhite skipempty nextgroup=madDataTypeContainer,madDataTypeVariable
syntax match   madDataOr              /|/                  contained skipwhite skipempty nextgroup=madTypeContainer,madTypeVariable

syntax cluster madData                contains=madDataKeyword,madDataTypeContainer,madDataTypeVariable,madDataAssignment,madDataOr

syntax match   madTypeIdentifier      /^\K\k\+/            skipwhite nextgroup=madTypeDef
syntax match   madTypeDef             /::/                 contained skipwhite skipempty nextgroup=madTypeParens
syntax match   madTypeAssignment      /=/                  contained skipwhite skipempty nextgroup=madTypeContainer,madTypeVariable
syntax match   madTypeContainer                            contained /\<\K\k\+/ skipwhite nextgroup=madTypeVariable,madTypeNext
syntax match   madTypeVariable                             contained /\<\K\k\+/ skipwhite nextgroup=madTypeNext
syntax region  madTypeParens          start='('  end=')'   contained skipwhite skipempty nextgroup=madTypeContainer,madTypeVariable,madTypeIdentifier,madTypeNext
syntax match   madTypeNext            /->/                           skipwhite skipempty 

syntax cluster madType                contains=madTypeIdentifier,madTypeDef,madTypeAssignment,madTypeContainer,madTypeVariable,madTypeNext

syntax match madPipe                  /|>/                 contained skipwhite nextgroup=@madExpression
syntax match madIdentifier            /^\K\k\+/            skipwhite nextgroup=madAssignment
syntax match madAssignment            /=/                  contained skipwhite skipempty nextgroup=madFunctionParameters
syntax match madFunctionNoise         '[,]'                contained skipwhite skipempty
syntax region madFunctionParameters   start='('  end=')'   contains=madTypeVariable,madFunctionNoise
syntax match madArrow                 /=>/                           skipwhite nextgroup=@madExpression

syntax keyword madTodo                                     contained TODO

syntax region  madComment             start='--' end='$'   contains=madTodo extend keepend

syntax match   madNumber              '\d\+'               contained display
syntax match   madNumber              '[-+]\d\+'           contained display

syntax keyword madBooleanTrue         True          
syntax keyword madBooleanFalse        False          

syntax region  madString              start=+\z(["']\)+  skip=+\\\%(\z1\|$\)+  end=+\z1+ end=+$+ extend
syntax region  madTemplateString      start=+`+  skip=+\\`+  end=+`+     contains=madTemplateExpression extend
syntax region  madTemplateExpression  contained matchgroup=madTemplateBraces start=+${+ end=+}+ contains=@madExpression keepend

syntax region  madFence               start='#-' end='-#'  contained

syntax cluster madExpression          contains=madPipe,madData,madType,madString,madFence,madBooleanTrue,madBooleanFalse,madNumber

hi def link    madDataKeyword         Keyword
hi def link    madBooleanTrue         Keyword
hi def link    madBooleanFalse        Keyword
hi def link    madComment             Comment
hi def link    madTypeDef             TypeDef 
hi def link    madTypeParens          Noise
hi def link    madTemplateBraces      Noise
hi def link    madTypeIdentifier      Constant 
hi def link    madIdentifier          Constant 
hi def link    madString              String
hi def link    madTemplateString      String
hi def link    madTypeExpression      Type
hi def link    madTypeNext            Keyword
hi def link    madPipe                Keyword
hi def link    madArrow               Keyword
hi def link    madDataOr              Operator 
hi def link    madDataAssignment      Operator 

let b:current_syntax = "madlib"
if main_syntax == 'madlib'
  unlet main_syntax
endif
