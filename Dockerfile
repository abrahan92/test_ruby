FROM ruby:2.6.1

# Update the package lists before installing.
RUN apt-get update -qq && apt install -y vim nano

RUN apt-get update -q && \
    apt-get install -qy procps curl ca-certificates gnupg2 build-essential --no-install-recommends && apt-get clean

# Create a directory called `/workdir` and make that the working directory
ENV PAGE=${PAGE}
RUN mkdir /workdir
WORKDIR /workdir

# Copy all files
COPY . /workdir/

ENTRYPOINT ["sh", "./entrypoint.sh"]