all:
	swipl -q -g start -o flp20-log -c main.pl

test:
	mkdir out
	./flp20-log < tests/test1 > out/test1
	diff tests/refs/test1 out/test1

	./flp20-log < tests/test2 > out/test2
	diff tests/refs/test2 out/test2
	
	./flp20-log < tests/test3 > out/test3
	diff tests/refs/test3 out/test3
	
	./flp20-log < tests/test4 > out/test4
	diff tests/refs/test4 out/test4
	
	./flp20-log < tests/test5 > out/test5
	diff tests/refs/test5 out/test5

	rm -r out

zip:
	zip -r flp-log-xkaras34.zip *

clean:
	rm flp20-log