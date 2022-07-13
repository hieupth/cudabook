ARG PLATFORM=amd64
ARG CUDNN_VERSION=8
ARG CUDA_VERSION=11.6.2
ARG TINI_VERSION=v0.19.0
#
ARG MINIFORGE_NAME=Miniforge3
ARG MINIFORGE_VERSION=4.12.0-2
#
ARG IMAGE_STAGE=runtime
ARG OS_VERSION=ubuntu20.04
#
FROM nvidia/cuda:${CUDA_VERSION}-cudnn${CUDNN_VERSION}-${IMAGE_STAGE}-${OS_VERSION}
# 
ENV CONDA_DIR=/opt/conda
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH=${CONDA_DIR}/bin:${PATH}
# Install necessary packages.
RUN apt-get update > /dev/null && \
    apt-get install --no-install-recommends --yes \
        wget bzip2 git curl ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    TARGETARCH="$(echo ${TARGETPLATFORM} | cut -d / -f 2)"; case ${TARGETARCH} in "ppc64le") TARGETARCH="ppc64el" ;; *) ;; esac ; \
    wget --no-hsts --quiet https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-${TARGETARCH} -O /usr/local/bin/tini && \
    chmod +x /usr/local/bin/tini && \
    wget --no-hsts --quiet https://github.com/conda-forge/miniforge/releases/download/${MINIFORGE_VERSION}/${MINIFORGE_NAME}-${MINIFORGE_VERSION}-Linux-$(uname -m).sh -O /tmp/miniforge.sh && \
    /bin/bash /tmp/miniforge.sh -b -p ${CONDA_DIR} && \
    rm /tmp/miniforge.sh && \
    conda clean -tipsy && \
    find ${CONDA_DIR} -follow -type f -name '*.a' -delete && \
    find ${CONDA_DIR} -follow -type f -name '*.pyc' -delete && \
    conda clean -afy && \
    echo ". ${CONDA_DIR}/etc/profile.d/conda.sh && conda activate base" >> /etc/skel/.bashrc && \
    echo ". ${CONDA_DIR}/etc/profile.d/conda.sh && conda activate base" >> ~/.bashr
# Create new environment.
RUN conda create -n cudabook python=${PYTHON_VERSION} \
    mkl mkl-include
# Make RUN commands use the new environment.
SHELL ["conda", "run", "--no-capture-output", "-n", "cudabook", "/bin/bash", "-c"]
# 
ENTRYPOINT ["tini", "--"]