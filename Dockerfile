FROM rocker/r-ver:4.0.2 AS prod

RUN install2.r googleCloudRunner here

COPY . /home
WORKDIR /home

CMD Rscript main.R