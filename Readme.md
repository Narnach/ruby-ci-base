# Ruby Continuous Integration / development base image

> I've stopped using this myself, so this project is archived to reflect this. As with all my open source code, it's licensed under MIT so feel free to use this however you want.

Operating System-level dependencies can vary between projects, which makes local development annoying when e.g. having to juggle different versions of OpenSSL or MySQL. Putting everything (development + dependencies) in Docker can help. This image is based on [one](https://github.com/Narnach/bl-ruby-ci-base) I created for a client that needed Microsoft SQL Server, which is not available on Mac OS X other than in Docker. Obviously most projects don't use MS SQL server, so this is a stripped down version of that project (or maybe I can update that one to be an enhanced version of this one?)

This contains:

- Ubuntu 18.04
- Ruby 2.6.5 & bundler 1.17.3
- Node.js (some recent version)
- Other (random-ish) stuff useful for getting a Rails app running, such as libxml

## Using this

The images built from this repository are available on [Docker hub](https://hub.docker.com/r/narnach/ruby-ci-base). You can download the latest version via:

```bash
docker pull narnach/ruby-ci-base
```

## Build instructions

```bash
# Build the image for local use, tagging it with the Ruby version and the "latest" tag.
docker build -t narnach/ruby-ci-base:latest -t narnach/ruby-ci-base:ruby-2.6.5 .

# Push the image (only useful for me, the Docker hub repository owner)
docker push narnach/ruby-ci-base:ruby-2.6.5 && docker push narnach/ruby-ci-base:latest
```

After step 1, you can locally use the Docker image `ruby-ci-base:ruby-2.6.5`.
Step 2 is what I have performed to get the latest version on Docker hub.

Ruby versions I've created images for in this way:

- Ruby 2.6.5

## Version updates / custom images

* Update the `ARG` settings at the top of the `Dockerfile`
* Update this Readme to refer to the correct versions.
* Commit the changes
* Build (anyone) and push (me) the image. In case of errors, go back to previous steps until it _does_ work.
