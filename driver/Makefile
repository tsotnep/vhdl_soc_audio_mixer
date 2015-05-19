obj-m := myled.o

all:
	make -C ../linux-digilent/ M=$(PWD) modules

clean:
	make -C ../linux-digilent/ M=$(PWD) clean 
