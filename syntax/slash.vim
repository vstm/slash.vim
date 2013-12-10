" Vim syntax file
" Language: slash-lang
" Maintainer: Stefan Vetsch <s@svetsch.ch>
" Last Change: Dec 9, 2013
" Version: 0.5
" URL: 
"
" Inspired by "php.vim", regexp part from "ruby.vim".
"
" Options:  slash_sql_query = 1          for SQL syntax highlighting inside
"                                        strings
"           slash_html_in_strings = 1    for HTML syntax highlighting inside
"                                        strings
"           slash_parent_error_close = 1 for highlighting parent error ] or )
"           slash_parent_error_open = 1  for skipping an slash end tag,
"                                        if there exists an open ( or [
"                                        without a closing one
"           slash_sync_method = x        x=-1 to sync by search ( default )
"                                        x>0 to sync at least x lines backwards
"                                        x=0 to sync from start

if exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = 'slash'
endif

runtime! syntax/html.vim
unlet! b:current_syntax

" Set sync method if none declared
if !exists("slash_sync_method")
  if exists("slash_minlines")
    let slash_sync_method=slash_minlines
  else
    let slash_sync_method=-1
  endif
endif

syn cluster htmlPreproc add=slashRegion,slashCommentRegion

syn include @sqlTop syntax/sql.vim
syn sync clear
unlet! b:current_syntax
syn cluster sqlTop remove=sqlString,sqlComment

if exists("slash_sql_query")
  syn cluster slashAddStrings contains=@sqlTop
endif

if exists("slash_html_in_strings")
  syn cluster slashAddStrings add=@htmlTop
endif

syn case match
 
" Magic Constants
syn keyword slashMagicConstants __LINE__ __FILE__ contained

" Control Structures
syn keyword slashConditional if elsif else unless switch contained
syn keyword slashRepeat for in while until next last contained
syn keyword slashStatement return contained

" Class Keywords
syn keyword slashStructure class extends def contained
syn keyword slashStructure lambda λ contained
syn match slashStructure "\\" contained display

" Exception Keywords
syn keyword slashException try catch throw contained

" These special keywords have traditionally received special colors
syn keyword slashSpecial print contained
syn keyword slashUse use contained

" Operator
syn match slashOperator "\(<<=\|>>=\|=\|+=\|-=\|\*\*=\|\*=\|/=\|%=\|^=\|&=\|&&=\||=\|||=\)" contained display
syn match slashOperator "\(==\|!=\|<=\>\|<=\|<\|>=\|>\)" contained display
syn match slashOperator "\(<<\|>>\|+\|-\|\*\*\|\*\|/\|%\|^\|&\|&&\||\|||\|\~\|!\|++\|--\|and\|or\|not\)" contained display
syn match slashOperator "\(\.\.\.\|\.\.\|:\|::\)" contained display
syn match slashOperator "\(,\|=>\)" contained display

syn match slashMemberSelector "\."  contained display

" Identifier
syn match  slashConstants    "[A-Z][a-zA-Z0-9_']*"  contained display
syn match  slashIdentifier   "[a-z][a-zA-Z0-9_']*"  contained display
syn match  slashIvar         "@[a-z][a-zA-Z0-9_']*"  contained display
syn match  slashCvar         "@@[a-z][a-zA-Z0-9_']*"  contained display

" Boolean
syn keyword slashBoolean true false contained
syn keyword slashNil nil contained

" Number
syn match slashNumber "-\=\<\d\+\>" contained display

" Float
syn match slashNumber "-\=\<\d\+\(e[+-]\=\d\+\)\=\>" contained display
syn match slashNumber "\(-\=\<\d+\|-\=\)\.\d\+\(e[+-]\=\d\+\)\=\>" contained display

" String
syn region slashString matchgroup=slashStringDelimiter start=+"+ skip=+\\\\\|\\"+ end=+"+  contains=@Spell,@slashAddStrings,slashSpecialChar,slashInterpolation contained extend
syn match slashSingleString "'[a-zA-Z0-9_]\+" contained display

syn region slashInterpolation matchgroup=slashInterpolationDelimiter start="#{" end="}" contained contains=@slashClTop

" SpecialChar
syn match slashSpecialChar "\\[nrte\\]" contained display
syn match slashSpecialChar "\\x\x\{2}" contained display
syn match slashSpecialChar +\\"+   contained display
syn match slashSpecialChar "\\\\"  contained display

" Regex
syn region slashRegexp matchgroup=slashRegexpDelimiter start="%r{" end="}[iomxneus]*" skip="\\\\\|\\}" contains=@slashRegexpSpecial extend

syn region slashRegexpComment   matchgroup=slashRegexpSpecial   start="(?#" skip="\\)"  end=")"  contained
syn region slashRegexpParens    matchgroup=slashRegexpSpecial   start="(\(?:\|?<\=[=!]\|?>\|?<[a-z_]\w*>\|?[imx]*-[imx]*:\=\|\%(?#\)\@!\)" skip="\\)"  end=")"  contained transparent contains=@slashRegexpSpecial
syn region slashRegexpBrackets  matchgroup=slashRegexpCharClass start="\[\^\=" skip="\\\]" end="\]" contained transparent contains=slashStringEscape,slashRegexpEscape,slashRegexpCharClass oneline

syn match  slashRegexpCharClass   "\\[DdHhSsWw]"         contained display
syn match  slashRegexpCharClass   "\[:\^\=\%(alnum\|alpha\|ascii\|blank\|cntrl\|digit\|graph\|lower\|print\|punct\|space\|upper\|xdigit\):\]" contained
syn match  slashRegexpEscape      "\\[].*?+^$|\\/(){}[]" contained
syn match  slashRegexpQuantifier  "[*?+][?+]\="          contained display
syn match  slashRegexpQuantifier  "{\d\+\%(,\d*\)\=}?\=" contained display
syn match  slashRegexpAnchor      "[$^]\|\\[ABbGZz]"     contained display
syn match  slashRegexpDot         "\."                   contained display
syn match  slashRegexpSpecial     "|"                    contained display
syn match  slashRegexpSpecial     "\\[1-9]\d\=\d\@!"     contained display
syn match  slashRegexpSpecial     "\\k<\%([a-z_]\w*\|-\=\d\+\)\%([+-]\d\+\)\=>" contained display
syn match  slashRegexpSpecial     "\\k'\%([a-z_]\w*\|-\=\d\+\)\%([+-]\d\+\)\='" contained display
syn match  slashRegexpSpecial     "\\g<\%([a-z_]\w*\|-\=\d\+\)>" contained display
syn match  slashRegexpSpecial     "\\g'\%([a-z_]\w*\|-\=\d\+\)'" contained display

syn cluster slashRegexpSpecial contains=slashInterpolation,slashNoInterpolation,slashStringEscape,slashRegexpSpecial,slashRegexpEscape,slashRegexpBrackets,slashRegexpCharClass,slashRegexpDot,slashRegexpQuantifier,slashRegexpAnchor,slashRegexpParens,slashRegexpComment

" Error
if exists("slash_parent_error_close")
  syn match slashParentError "[)\]}]"  contained display
endif

" Todo
syn keyword slashTodo todo fixme xxx note contained

" Comment
syn region slashCommentRegion start="<%#" end="%>" contained contains=slashTodo,@Spell extend
syn region slashComment start="/\*" end="\*/" contained contains=slashTodo,@Spell extend
syn match slashComment  "#.\{-}\(%>\|$\)\@="  contained contains=slashTodo,@Spell
syn match slashComment  "//.\{-}\(%>\|$\)\@=" contained contains=slashTodo,@Spell

" Parent
if exists("slash_parent_error_close") || exists("slash_parent_error_open")
  syn match  slashParent "[{}]"  contained
  syn region slashParent matchgroup=Delimiter start="(" end=")"  contained contains=@slashClFunction transparent
  syn region slashParent matchgroup=Delimiter start="\[" end="\]"  contained contains=@slashClInside transparent
  if !exists("slash_parent_error_close")
    syn match slashParent "[\])]" contained
  endif
else
  syn match slashParent "[({[\]})]" contained
endif

" Clusters
syn cluster slashClConst contains=slashIdentifier,slashIvar,slashCvar,slashConditional,slashRepeat,slashStatement,slashOperator,slashMemberSelector,slashString,slashSingleString,slashRegexp,slashNumber,slashBoolean,slashNil,slashStructure,slashConstants,slashException,slashMagicConstants
syn cluster slashClInside contains=@slashClConst,slashComment,slashParent,slashParentError,slashUse
syn cluster slashClFunction contains=@slashClInside,slashSpecial
syn cluster slashClTop contains=@slashClFunction

" slash Region
if exists("slash_parent_error_open")
  syn region slashRegion matchgroup=Delimiter start="<%\(=\|!!\|#\@!\)" end="%>" contains=@slashClTop
else
  syn region slashRegion matchgroup=Delimiter start="<%\(=\|!!\|#\@!\)" end="%>" contains=@slashClTop keepend
endif

" Sync
if slash_sync_method==-1
  syn sync match slashRegionSync grouphere slashRegion "^\s*<%\s*$"
  syn sync match slashRegionSync grouphere NONE "^\s*%>\s*$"
  syn sync match slashRegionSync grouphere slashRegion "def\s.*(.*\$"
elseif slash_sync_method>0
  exec "syn sync minlines=" . slash_sync_method
else
  exec "syn sync fromstart"
endif

hi def link slashComment          Comment
hi def link slashCommentRegion    Comment
hi def link slashTodo             Todo

hi def link slashConstants        Type
hi def link slashMagicConstants   Constant
hi def link slashBoolean          Constant
hi def link slashNil              Constant
hi def link slashNumber           Constant

hi def link slashFunctions        Identifier
hi def link slashClasses          Identifier
hi def link slashIdentifier       None
hi def link slashIvar             Identifier
hi def link slashCvar             Identifier

hi def link slashConditional      Conditional
hi def link slashRepeat           Repeat
hi def link slashStatement        Statement
hi def link slashException        Exception
hi def link slashOperator         Operator
hi def link slashMemberSelector   Operator

hi def link slashStructure        Keyword

hi def link slashUse              PreProc
hi def link slashSpecial          PreProc

hi def link slashParent           Special
hi def link slashParentError      Error

hi def link slashSingleString     String
hi def link slashString           String
hi def link slashSpecialChar      Special
hi def link slashStringDelimiter  Delimiter
hi def link slashInterpolationDelimiter  Delimiter

hi def link slashRegexp           String
hi def link slashRegexpDelimiter  Delimiter
hi def link slashRegexpSpecial    Special
hi def link slashRegexpEscape     slashRegexpSpecial
hi def link slashRegexpQuantifier slashRegexpSpecial
hi def link slashRegexpAnchor     slashRegexpSpecial
hi def link slashRegexpDot        slashRegexpCharClass
hi def link slashRegexpCharClass  slashRegexpSpecial

let b:current_syntax = "slash"

if main_syntax == 'slash'
  unlet main_syntax
endif

" vim: ts=8 sts=2 sw=2 expandtab fileencoding=utf-8
