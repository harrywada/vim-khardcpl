" Complete email addresses based on khard(1) contacts.
" Last Change:	2024 Apr 10
" Maintainer:	Harry Wada <spam@harrywada.com>
" License:	WTFPL

if exists("b:did_ftplugin")
	finish
endif
let b:did_ftplugin = 1

if !executable("khard")
	echoerr "Failed to load khardcpl because khard is not installed"
	finish
endif

setlocal omnifunc=KhardComplete
function! KhardComplete(findstart, base)
	if a:findstart
		let line = getline(".")
		if line =~# "^\\u\\a*\\(-\\u\\a*\\)*: "
			return max([
				\ stridx(line, ": ") + 2,
				\ strridx(line, ", ", col(".")) + 2
				\ ])
		else
			return -3 " Cancel and leave completion mode
		endif
	else
		const khard_cmd = "khard email --remove-first-line --parsable"
		let matches = []

		for entry in systemlist(khard_cmd . " " . a:base)
			let [email, name, abook] = split(entry, "\t")
			call add(matches, {
				\ "word": name . " <" . email . ">",
				\ "abbr": email,
				\ "menu": name,
				\ "icase": 1,
				\ })
		endfor

		return { "words": matches }
	endif
endfunction
