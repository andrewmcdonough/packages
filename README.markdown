Tribesports Package & Repository Management
===========================================

This repo contains scripts to build various Tribesports dependencies, create .deb packages from them using [fpm](https://github.com/jordansissel/fpm), build a signed apt repository and upload it to S3. Bits of it are lifted wholesale from the [alphagov packages repo](https://github.com/alphagov/packages). All hail Government Digital Services.

Requirements
------------

You will need the following files to sign and upload the resulting repository:

  * `tribesports-privkey.asc` - repository signing private key
  * `tribesports-pubkey.asc` - repository signing public key
  * `s3cfg-tribesports` - `s3cmd` configuration containing S3 access keys

The private key must be imported before running `repo.sh` using the following command:

    gpg --import tribesports-privkey.asc

Workflow
--------

  1. Build the selected package using the appropriate script, e.g. `./ruby-1.9.sh`
  2. Fetch existing packages from repo: `./fetch.sh`
  3. Build the repository: `./repo.sh` (you will be asked for the private key's passphrase)
  4. Upload the repository: `./sync.sh`

New Packages
------------

Cargo-cult an existing script. Note that most of the scripts rely on the source package's `make install` command responding to the `DESTDIR` environment variable. If building a package that does not, you may have to manually copy things into a suitable location for `fpm` (see `redis.sh` for an example).
