FROM ruby:2.3-slim

RUN apt-get update -qq && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
  make \
  gcc \
  g++ \
  libsqlite3-dev \
  git-core && \
  apt-get clean
