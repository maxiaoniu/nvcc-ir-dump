CLANG = clang++
DIS = llvm-dis-3.4
AS = llvm-as-3.4
CUDA_ROOT ?= /opt/cuda-7.5
CUDA_ARCH ?= compute_30
LIBDUMP = libdump.so
NVCC_PRELOAD = LD_PRELOAD=$(shell pwd)/$(LIBDUMP)

all: test.bc
clean:
	rm -f *.so *.ptx *.ll *.bc
$(LIBDUMP): dump.cpp
	$(CLANG) -fPIC -shared $< -o $@
test0.bc: test.cu $(LIBDUMP)
	$(NVCC_PRELOAD) LLVM_BC_NAME="test" $(CUDA_ROOT)/bin/nvcc -ptx test.cu -arch=$(CUDA_ARCH) -o test.ptx
test.ll: test0.bc
	$(DIS) < $< > $@
test_cleaned.ll: test.ll
	$(shell grep -v "datalayout" $< | grep -v "llvm.used" > $@)
test.bc: test_cleaned.ll
	$(AS) < $< > $@
