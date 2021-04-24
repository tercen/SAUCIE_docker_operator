FROM tensorflow/tensorflow:2.4.1

ENV R_BASE_VERSION 4.0.4
ENV TZ Europe/Paris5
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y --no-install-recommends software-properties-common dirmngr
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran40/'

RUN apt-get update && apt-get install -y --no-install-recommends \
  openssl  \
  libssl-dev \
  rustc \
  cargo \
  r-base-core=${R_BASE_VERSION}-* \
  r-base-dev=${R_BASE_VERSION}-* \
  r-recommended=${R_BASE_VERSION}-* \
  git

RUN pip install pandas
RUN pip install sklearn
RUN R -e "install.packages(c('renv'))"

WORKDIR /operator
ADD . saucie
WORKDIR /operator/saucie

RUN R -e "renv::consent(provided=TRUE)"
RUN R -e "renv::restore(confirm=FALSE)"

ENV TERCEN_SERVICE_URI https://tercen.com

ENTRYPOINT [ "R","--no-save","--no-restore","--no-environ","--slave","-f","main.R", "--args"]
CMD [ "--taskId", "someid", "--serviceUri", "https://tercen.com", "--token", "sometoken"]
