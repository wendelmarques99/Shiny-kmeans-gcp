FROM rocker/shiny-verse

# Instalar bibliotecas para o tidyverse
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
  build-essential \
  libcurl4-gnutls-dev \
  libxml2-dev \
  libssl-dev \
  r-cran-curl \
  r-cran-openssl \
  curl \
  gnupg1 \
  r-cran-xml2

# Instalar seu próprio app (e suas dependências)
COPY ./ /tmp/app/
RUN R -e "remotes::install_local('/tmp/app/')"


# Copiar arquivos para o lugar certo
EXPOSE 80/tcp
RUN rm /srv/shiny-server/index.html
COPY ./inst/app /srv/shiny-server/
COPY ./inst/app/shiny-server.conf /etc/shiny-server/shiny-server.conf
#docker image
COPY ./inst/app/shiny-server.sh /usr/bin/shiny-server.sh

# allow permission
RUN sudo chown -R shiny:shiny /srv/shiny-server

RUN ["chmod", "+x", "/usr/bin/shiny-server.sh"]

# Run
CMD ["/usr/bin/shiny-server.sh"]


