FROM ruby:3.4-slim

RUN apt-get update -qq && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
  make \
  gcc \
  g++ \
  libsqlite3-dev \
  libyaml-dev \
  git-core && \
  apt-get clean

WORKDIR /app
