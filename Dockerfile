FROM tensorflow/tensorflow:2.4.1

ENV TZ Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y openssl libssl-dev rustc r-base git

RUN R -e "install.packages(c('renv', 'dplyr'))"

WORKDIR /operator

RUN git clone https://github.com/tercen/SAUCIE_python_operator

WORKDIR /operator/SAUCIE_python_operator

RUN echo 0.0.3 && git pull
RUN git checkout 0.0.3

RUN R --vanilla -e "renv::restore(confirm=FALSE)"

ENV TERCEN_SERVICE_URI https://tercen.com

ENTRYPOINT [ "R","--no-save","--no-restore","--no-environ","--slave","-f","main.R", "--args"]
CMD [ "--taskId", "someid", "--serviceUri", "https://tercen.com", "--token", "sometoken"]
