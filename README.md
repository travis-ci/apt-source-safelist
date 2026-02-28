# APT source safelist

This repo contains JSON files for the sources approved for addition in
restricted build environments, specifically meant for the `apt` addon in
travis-build. You can check here [how to install packages with the APT
addon](https://docs.travis-ci.com/user/installing-dependencies#Installing-Packages-with-the-APT-Addon).
-Travis

-

Travis CI Enterprise

This documentation site is open source. The README in our Git repository explains how to contribute.

Improve this page on GitHub

Installing Dependencies

INSTALLING PACKAGES ON STANDARD INFRASTRUCTURE

INSTALLING PACKAGES ON MACOS

INSTALLING PACKAGES ON FREEBSD

INSTALLING DEPENDENCIES ON MULTIPLE OPERATING SYSTEMS

INSTALLING PROJECTS FROM SOURCE

Installing Packages on Standard Infrastructure #

To install Ubuntu packages that are not included in the standard precise, trusty, xenial, or bionic distribution, use apt-get in the before_install step of your .travis.yml:

before_install:

  - sudo apt-get -y install libxml2-dev

YAML

By default, apt-get update does not get run automatically. If you want to update apt-get update automatically on every build, there are two ways to do this. The first is by running apt-get update explicitly in the before_install step:

before_install:

  - sudo apt-get update

  - sudo apt-get -y install libxml2-dev

YAML

The second way is to use the APT addon:

before_install:

  - sudo apt-get -y install libxml2-dev

addons:

  apt:

    update: true

YAML

Do not run apt-get upgrade in your build as it downloads up to 500MB of packages and significantly extends your build time. Additionally, some packages may fail to update, which will lead to a failed build.

Use the -y parameter with apt-get to assume yes to all queries by the apt tools.

Installing Packages from a custom APT repository #

For some packages, you may find an existing repository, which isn’t yet set up on our build environment by default. You can easily add custom repositories and Launchpad PPAs as part of your build.

For example, to install gcc from the ubuntu-toolchain ppa

before_install:

  - sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test

  - sudo apt-get -q update

  - sudo apt-get -y install gcc-4.8

YAML

For repositories not hosted on Launchpad, you need to add a GnuPG key as well.

If you’re installing packages this way, make sure you download the correct version for your environment.

This example adds the APT repository for Varnish 3.0 for Ubuntu 12.04 to the locally available list of APT sources and then installs the varnish package.

before_script:

  - curl http://repo.varnish-cache.org/debian/GPG-key.txt | sudo apt-key add -

  - echo "deb http://repo.varnish-cache.org/ubuntu/ precise varnish-3.0" | sudo tee -a /etc/apt/sources.list

  - sudo apt-get -qq update

  - sudo apt-get -y install varnish

YAML

Installing Packages without an APT Repository #

For some projects, there may be a Debian/Ubuntu package available, but no corresponding APT repository. These are still easy to install, but require the extra step of downloading.

If you’re installing packages this way, make sure you download the correct version for your environment.

Say your project requires the pngquant tool to compress PNG files, here’s how to download and install the .deb file:

before_install:

  - wget http://pngquant.org/pngquant_1.7.1-1_i386.deb

  - sudo dpkg -i pngquant_1.7.1-1_i386.deb

YAML

Installing Packages with the APT Addon #

You can also install packages and sources using the APT addon, without running apt-get commands in your before_install script.

If your requirements goes beyond the normal installation, please use another method described above.

Adding APT Sources #

To add APT sources, you can use one of the following three types of entries:

aliases defined in source safelist

sourceline key-value pairs which will be added to /etc/apt/sources.list

when APT sources require GPG keys, you can specify this with key_url pairs in addition to sourceline.

The following snippet shows these three types of APT sources

addons:

  apt:

    sources:

    - deadsnakes

    - sourceline: 'ppa:ubuntu-toolchain-r/test'

    - sourceline: 'deb https://packagecloud.io/chef/stable/ubuntu/precise main'

      key_url: 'https://packagecloud.io/gpg.key'

YAML

Adding APT Packages #

List APT packages under the addons.apt.packages key:

addons:

  apt:

    packages:

    - cmake

    - time

YAML

Note: When using APT sources and packages together, you need to make sure they are under the same key space in the YAML file. e.g.

addons:

  apt:

    sources:

    - ubuntu-toolchain-r-test

    packages:

    - gcc-4.8

    - g++-4.8

YAML

Note: If apt-get install fails, the build is marked an error.

You can also have a look at the Apt section in our Travis CI Build Config Reference.

Installing Snap Packages with the Snaps Addon #

You can install snap packages using our Xenial or Bionic images:

dist: xenial

YAML

or

dist: bionic

YAML

The Ubuntu Snap store offers many packages directly maintained by upstream developers, often with newer versions than the ones available in the Apt archive.

You can specify snaps as an array of snap specifications, each of which is of the two possible forms:

The name of the snap, which will be passed on to the snap install without additional flags. For example,

   dist: xenial

   addons:

     snaps:

       - hugo

YAML

This results in:

   $ sudo snap install hugo

The map specifying how the snap should be installed. Possible keys are: name, confinement, and channel. The confinement key will be used to add --classic or --devmode flag, and channel will be passed to --channel flag. For example,

   dist: xenial

   addons:

     snaps:

       - name: aws-cli

         confinement: classic # or devmode

         channel: latest/edge # will be passed to --channel flag

YAML

This results in:

   $ sudo snap install aws-cli --classic --channel=latest/edge

confinement and channel are optional.

Installing Packages on macOS #

To install packages that are not included in the default macOS environment use Homebrew.

For convenience, you can use Homebrew addon in your .travis.yml. For example, to install beanstalk:

addons:

  homebrew:

    packages:

    - beanstalk

YAML

By default, the Homebrew addon will not run brew update before installing packages. brew update can take a long time and slow down your builds. If you need more up-to-date versions of packages than the snapshot on the build VM has, you can add update: true to the addon configuration:

addons:

  homebrew:

    packages:

    - beanstalk

    update: true

YAML

Installing Casks #

The Homebrew addon also supports installing casks. You can add them to the casks key in the Homebrew addon configuration to install them:

addons:

  homebrew:

    casks:

    - dotnet-sdk

YAML

Installing From Taps #

Homebrew supports installing casks and packages from third-party repositories called taps, and you can use these with the Homebrew addon.

For instance, Homebrew maintains a tap of older versions of certain casks at homebrew/cask-versions. If you wanted to install Java 8 on an image with Java 10 installed, you can add that tap and then install the java8 cask:

osx_image: xcode10

addons:

  homebrew:

    taps: homebrew/cask-versions

    casks: java8

YAML

Using a Brewfile #

Under the hood, the Homebrew addon works by creating a ~/.Brewfile and running brew bundle --global. You can also use the addon to install dependencies from your own Brewfile that is checked in to your project. By passing brewfile: true, the addon will look for a Brewfile in the root directory of your project:

addons:

  homebrew:

    brewfile: true

YAML

You can also provide a path if your Brewfile is in a different location.

addons:

  homebrew:

    brewfile: Brewfile.travis

YAML

Using Homebrew without addon on older macOS images #

If you’re running the brew command directly in your build scripts, and you’re using an older macOS image, you may see a warning such as this:

Homebrew must be run under Ruby 2.3! You're running 2.0.0.

You’ll need to update to Ruby 2.3 or newer:

rvm use 2.3 --install --binary

brew update

brew install openssl

rvm use $TRAVIS_RUBY_VERSION # optionally, switch back to the Ruby version you need.

You can also have a look at the Homebrew section in our Travis CI Build Config Reference.

Installing Packages on FreeBSD #

To install packages that are not included in the default FreeBSD environment use pkg in the before_install step of your .travis.yml:

before_install:

  - su -m root -c 'pkg install -y curl'

YAML

For convenience, you can use the pkg addon in your .travis.yml. For example, to install go and curl:

addons: 

 pkg: 

  - go 

  - curl

YAML

Installing Dependencies on Multiple Operating Systems #

If you’re testing on both Linux and macOS, you can use both the APT addon and the Homebrew addon together. Each addon will only run on the appropriate platform:

addons:

  apt:

    packages: foo

  homebrew:

    packages: bar

YAML

If you’re installing packages manually, use the $TRAVIS_OS_NAME variable to install dependencies separately for each OS:

install:

  - if [ $TRAVIS_OS_NAME = linux ]; then sudo apt-get install foo; else brew install bar; fi

YAML

Installing Projects from Source #

Some dependencies can only be installed from a source package. The build may require a more recent version or a tool or library that’s not available as a Ubuntu package.

You can easily include the build steps in either your .travis.yml or, and this is the recommended way, by running a script to handle the installation process.

Here’s a simple example that installs CasperJS from a binary package:

before_script:

  - wget https://github.com/n1k0/casperjs/archive/1.0.2.tar.gz -O /tmp/casper.tar.gz

  - tar -xvf /tmp/casper.tar.gz

  - export PATH=$PATH:$PWD/casperjs-1.0.2/bin/

YAML

Note that when you’re updating the $PATH environment variable, that part can’t be moved into a shell script, as it will only update the variable for the sub-process that’s running the script.

To install something from source, you can follow similar steps. Here’s an example to download, compile and install the protobufs library.

install:

  - wget https://protobuf.googlecode.com/files/protobuf-2.4.1.tar.gz

  - tar -xzvf protobuf-2.4.1.tar.gz

  - pushd protobuf-2.4.1 && ./configure --prefix=/usr && make && sudo make install && popd

YAML

These three commands can be extracted into a shell script, let’s name it install-protobuf.sh:

#!/bin/sh

set -ex

wget https://protobuf.googlecode.com/files/protobuf-2.4.1.tar.gz

tar -xzvf protobuf-2.4.1.tar.gz

cd protobuf-2.4.1 && ./configure --prefix=/usr && make && sudo make install

Bash

Once it’s added to the repository, you can run it from your .travis.yml:

before_install:

  - ./install-protobuf.sh

YAML

Note that the first version uses pushd and popd to ensure that after the install section completes, the working directory is returned to its original value. This is not necessary in the shell script, as it runs in a sub-shell and so does not alter the original working directory.













Changelog.log




















Thank you!

## about key_url values

The sources present in `ubuntu.json` contain `key_url` values that are included
for backward compatibility with any version of
[travis-build](https://github.com/travis-ci/travis-build) that may require it.
