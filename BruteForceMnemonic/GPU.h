/**
  ******************************************************************************
  * @author		Anton Houzich
  * @version	V2.0.0
  * @date		29-April-2023
  * @mail		houzich_anton@mail.ru
  * discussion  https://t.me/brute_force_gpu
  ******************************************************************************
  */
#pragma once

#include <stdint.h>
#include "stdafx.h"
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

__global__ void gl_bruteforce_mnemonic(
	const uint64_t* __restrict__ entropy,
	const tableStruct* __restrict__ tables,
	retStruct* __restrict__ ret
);

__global__ void gl_bruteforce_mnemonic_for_save(
	const uint64_t* __restrict__ entropy,
	const tableStruct* __restrict__ tables,
	retStruct* __restrict__ ret,
	uint32_t* __restrict__ hash160_ret,
	uint8_t* __restrict__ for_save
);


extern "C" cudaError_t init_device_constants(
    uint32_t num_bytes,
    const uint32_t* generate_path,
    uint32_t num_childs,
    uint32_t num_paths,
    const int16_t* words_indices
);


