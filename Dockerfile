#
# This first bit has some configuration options!
#

# Configure Ubuntu version
ARG UBUNTU_VERSION="18.04"

# Actually use the Ubuntu version to pick a base buildpack.
# Buildpacks have useful development libraries.
FROM buildpack-deps:$UBUNTU_VERSION

# Configure Ruby & Bundler version
ENV RUBY_VERSION="2.6.5"
ENV BUNDLER_VERSION="1.17.3"

#
# It's all build instructions from here. No more configuration.
#

# Rbenv relevant info
ENV RBENV_ROOT=/usr/local/rbenv
# Rbenv has non-standard paths
ENV PATH=$RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH
# Ruby compilation should not generate documentation
ENV CONFIGURE_OPTS="--disable-install-doc"
# Good default: don't install documentation and RI for gems
RUN echo 'gem: --no-document --no-ri' >> /root/.gemrc

# Set timezone so tzdata does not ask about it. UTC is a sane default for development and testing.
# Don't rely on "local" timezone, but always store as UTC and cast to the end user's timezone.
ENV TZ="Etc/UTC"
# Make installs be hands-off
ENV DEBIAN_FRONTEND="noninteractive"

# Base packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        # Enable HTTPS sources
        apt-transport-https \
        # Compile stuff
        build-essential \
        # Helps us fix locales to not run into odd C errors
        locales \
        # Helpful headers for Nokogiri
        libxml2-dev libxslt1-dev\
        # If you use Javascript, you need this
        nodejs \
        # Timezone data
        tzdata \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Fix the default locale in the image to something that does not raise odd C errors (before we compile anything)
RUN locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8

# Rbenv and ruby-build
RUN git clone --depth 1 git://github.com/sstephenson/rbenv.git /usr/local/rbenv && \
    git clone --depth 1 https://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build && \
    /usr/local/rbenv/plugins/ruby-build/install.sh

# Ruby
RUN rbenv install $RUBY_VERSION && \
    rbenv global $RUBY_VERSION

# Bundler
RUN eval "$(rbenv init -)"; gem install bundler --version $BUNDLER_VERSION

