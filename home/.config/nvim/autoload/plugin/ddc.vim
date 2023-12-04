
function! plugin#ddc#init () abort
  call ddc#custom#patch_global ('ui', 'native')
  " call ddc#custom#patch_global ('completionMenu', 'pum.vim')
  call ddc#custom#patch_global ('autoCompleteEvents', ['TextChangedI', 'TextChangedP'])
  call ddc#custom#patch_global ('sources', ['lsp', 'around', 'skkeleton'])
  call ddc#custom#patch_global ('sourceOptions', {
        \ '_': {
        \   'matchers': ['matcher_fuzzy'],
        \   'sorters': ['sorter_fuzzy'],
        \   'converters': ['converter_fuzzy'],
        \ },
        \ 'around': {'mark': 'A'},
        \ 'lsp': {
        \   'mark': 'lsp',
        \   'forceCompletionPattern': '\w|:\w*|->\w*',
        \   'ignoreCase': v:true,
        \ },
        \})
  call ddc#custom#patch_global ('sourceParams', {
        \ 'around': {'maxSize': 500},
        \})
  call ddc#enable ()
endfunction
