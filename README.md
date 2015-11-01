# nvcc-ir-dump
This is a simple tool that can dump the bitcode from nvcc and use llvm-dis to generate ir file.
The main idea is add a hook in the libnvvm function "nvvmAddModuleToProgram".
The idea is from https://github.com/apc-llc/nvcc-llvm-ir
