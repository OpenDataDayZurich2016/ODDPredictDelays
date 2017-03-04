all:
	R -q -e 'remake::make(remake::list_targets())'
