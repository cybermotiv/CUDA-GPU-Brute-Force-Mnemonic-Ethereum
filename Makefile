# Makefile для Linux-порта BruteForceMnemonic (CUDA)
# Использование:
#   make            — сборка eth_brute (по умолчанию sm_70 / V100)
#   make ARCH=sm_86 — другая архитектура GPU (RTX 30xx и т.п.)
#   make tools      — сборка CPU-утилиты Tools (без CUDA)

NVCC      ?= nvcc
CXX       ?= g++
ARCH      ?= 70
GENCODE   := -gencode arch=compute_$(ARCH),code=sm_$(ARCH)

STD       := -std=c++17
OPT       := -O3

INCLUDES  := -I. -IBruteForceMnemonic -ITools -Iconfig -Ibitcoin -Ibitcoin/crypto

CUDA_SRC  := \
	BruteForceMnemonic/kernel.cu \
	BruteForceMnemonic/Dispatcher.cu \
	BruteForceMnemonic/GPU.cu \
	BruteForceMnemonic/Helper.cu \
	BruteForceMnemonic/KernelStride.cu

CPU_SRC   := \
	Tools/tools.cpp \
	Tools/utils.cpp \
	Tools/segwit_addr.cpp \
	config/Config.cpp \
	bitcoin/base58.cpp \
	bitcoin/hash.cpp \
	bitcoin/crypto/sha256.cpp \
	bitcoin/crypto/sha512.cpp \
	bitcoin/crypto/hmac_sha512.cpp

LIBS      := -lcudart -lssl -lcrypto -lpthread

TARGET    := eth_brute

.PHONY: all tools clean

all: $(TARGET)

$(TARGET): $(CUDA_SRC) $(CPU_SRC)
	$(NVCC) $(OPT) $(STD) $(GENCODE) $(INCLUDES) \
		$(CUDA_SRC) $(CPU_SRC) -o $(TARGET) $(LIBS)

# CPU-only утилита Tools (не требует CUDA)
tools:
	$(CXX) $(OPT) $(STD) -fopenmp $(INCLUDES) \
		Tools/main.cpp Tools/tools.cpp Tools/utils.cpp Tools/segwit_addr.cpp \
		config/Config.cpp bitcoin/base58.cpp bitcoin/hash.cpp \
		bitcoin/crypto/sha256.cpp bitcoin/crypto/sha512.cpp bitcoin/crypto/hmac_sha512.cpp \
		-o tools_bin -lssl -lcrypto

clean:
	rm -f $(TARGET) tools_bin *.o
