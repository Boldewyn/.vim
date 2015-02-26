" HTML5 elements
" @see <http://www.w3.org/TR/html5-diff/#new-elements>
syn keyword htmlTagName contained section article main aside hgroup header
syn keyword htmlTagName contained footer nav figure figcaption video track
syn keyword htmlTagName contained embed mark progress meter time data dialog
syn keyword htmlTagName contained ruby rt rp bdi wbr canvas menuitem details
syn keyword htmlTagName contained datalist keygen output

" HTML5 attributes
syn keyword htmlArg contained async autocomplete autofocus charset
syn keyword htmlArg contained contenteditable contextmenu crossorigin dirname
syn keyword htmlArg contained download draggable dropzone form formaction
syn keyword htmlArg contained formenctype formmethod formnovalidate formtarget
syn keyword htmlArg contained hidden inert inputmode list manifest max menu
syn keyword htmlArg contained min multiple novalidate pattern placeholder
syn keyword htmlArg contained required reversed role sandbox scoped seamless
syn keyword htmlArg contained sizes sortable sorted spellcheck srcdoc srcset
syn keyword htmlArg contained step translate typemustmatch

syn match   htmlArg contained "\<\(aria-[a-z]\+\)\>"
syn match   htmlArg contained "\<\(data-[a-z0-9\-]\+\)\>"
