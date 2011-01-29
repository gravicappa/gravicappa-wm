BEGIN {
	split(s, x, /[ 	\n]+/);
	for (i in x) {
		split(x[i], st, ":")
		ev[st[1]] = st[2]
		acc[st[1]] = st[3]
	}
}
/^typedef struct/ {collect = 1; n = 0; next}
!collect {next}
/^}/ {
	gsub(/;$/, "")
	collect = 0
	if ($2 in ev)
		printf("(define-c-struct (\"%s\" \"%s\")", ev[$2], acc[$2])
	else
		printf("(define-c-struct (\"%s\")", $2)
	num = length(types)
	for (i = 1; i <= num; i++) {
		split(vars[i], slots, /,/)
		for (j in slots)
			if (slots[j] !~ /[\[\]]/)
				printf("\n  (%s %s)", types[i], slots[j]);
	}
	printf(")\n\n");
	delete types
	delete vars
	next;
}
/[{}]/ {next}
NF && /^  [a-zA-Z]/ {
	gsub(/;$/, "");
	type = $1
	for (i = 2; i < NF; i++)
		if ($i ~ /^(long|char|int|short)$/)
			type = type "-" $i
		else
			break
	if ($i ~ /^\*/) {
		type = type "*"
		sub(/^\*/, "", $i)
	}
	gsub(/,/, "")
	v = $i
	i++
	for (; i <= NF; i++)
		v = v "," $i
	n++
	types[n] = type
	vars[n] = v
}
