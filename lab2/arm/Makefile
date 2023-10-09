.PHONY: test_example,test_fb,test_fbf,clean

test_example:
	arm-linux-gnueabihf-gcc example.S -o example.out
	qemu-arm -L /usr/arm-linux-gnueabihf ./example.out
test_fb:
	arm-linux-gnueabihf-gcc fb.S -o fb.out
	qemu-arm -L /usr/arm-linux-gnueabihf ./fb.out
test_fbf:
	arm-linux-gnueabihf-gcc fb_float.S -o fb_float.out
	qemu-arm -L /usr/arm-linux-gnueabihf ./fb_float.out
clean:
	rm -fr example.out