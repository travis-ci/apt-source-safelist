# APT source safelist

This repo contains JSON files for the sources approved for addition in
restricted build environments, specifically meant for the `apt` addon in
travis-build. You can check here [how to install packages with the APT
addon](https://docs.travis-ci.com/user/installing-dependencies#Installing-Packages-with-the-APT-Addon).

At this moment, we are unable to continue processing the APT sources requests.
If you require a new source, please use `sudo: required` in your `.travis.yml`
file.

Thank you!

## about key_url values

The sources present in `ubuntu.json` contain `key_url` values that are included
for backward compatibility with any version of
[travis-build](https://github.com/travis-ci/travis-build) that may require it.

## key expiration
The command `bin/travis-check-expiration` can be run on a system, and parses the
output of `apt-key`. Specifically, it will error and report when keys in the
system's apt cache will expire. Usage:

```sh
bin/travis-check-expiration 3 month
```

Without any arguments, the expiration of today is reported. Accepted units are
`day`, `month`, `year`.
