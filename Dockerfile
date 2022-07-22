ARG CUDA=11.6.2
ARG FLAVOR=runtime

FROM hieupth/minicuda:${CUDA}-devel as BUILD

RUN conda install astunparse numpy ninja pyyaml cffi typing_extensions future six requests dataclasses mkl mkl-include magma-cuda116 -c pytorch

RUN git clone --recursive -j8 https://github.com/pytorch/pytorch

WORKDIR pytorch

RUN MAX_JOBS=1 USE_CUDA=1 USE_CUDNN=1 BUILD_TEST=0 USE_MKLDNN=1 TORCH_CUDA_ARCH_LIST=All \
    CMAKE_PREFIX_PATH=${CONDA_PREFIX:-"$(dirname $(which conda))/../"} && \
    python setup.py clean && \
    python setup.py bdist_wheel