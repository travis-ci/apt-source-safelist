# APT source whitelist

This repo contains JSON files for the sources approved for addition in restricted build environments, specifically meant for the `apt` addon in travis-build.

## Source approval process

0. Check the list of approved source for your build environment (most likely [`ubuntu`](./ubuntu.json)).
0. If it's not in there, check for [existing issues requesting the source you 
   want](https://github.com/travis-ci/apt-source-whitelist/issues), and if one doesn't exist please
   open an issue requesting the source you need in the [this
   repo](https://github.com/travis-ci/apt-source-whitelist/issues/new?title=APT+source+whitelist+request+for+___SOURCE___)
   (and be sure to replace `__SOURCE__` in the issue title :wink:).  The body of the issue must include the "deb 
   source line" which may be a ppa alias such as `ppa:fkrull/deadsnakes`.
   If the deb source is not a PPA, you must also include the URL to the GPG key.
0. Please be patient :smiley_cat:
