Tribesports Package & Repository Management
===========================================

This repo contains scripts to build various Tribesports
dependencies, create .deb packages from them using
[fpm](https://github.com/jordansissel/fpm), build a signed apt
repository and upload it to S3. Bits of it are lifted wholesale from the
[alphagov packages repo](https://github.com/alphagov/packages). All hail
Government Digital Services.

Requirements
------------

You will need the following files to sign and upload the resulting
repository:

  * `tribesports-privkey.asc` - repository signing private key
  * `tribesports-pubkey.asc` - repository signing public key
  * `s3cfg-tribesports` - `s3cmd` configuration containing S3 access keys

You will also need the password for the signing key.

Workflow
--------

A Vagrantfile and provisioning script are provided to set up VMs
to build the packages. A 32-bit and 64-bit VM are provisioned and booted.

  1. Fetch existing packages from repo: `./fetch.sh`
  2. Provision and boot the VMs: `vagrant up`
  3. Build your chosen package(s), e.g.: `./vagrant_run.sh
     ruby-1.9.sh`
  4. Build the repo: `./vagrant_run.sh repo.sh` (you will be prompted
     for the signing passphrase)
  5. Upload the repo `./sync.sh`

By default the `vagrant_run.sh` script will run the provided command
on both 32 and 64-bit environments. Some packages may not require
arch-specific builds (e.g. solr, being a Java package) - if this is
the case specify the box you would like to build on, either `x86` or
`amd64`:

    $ ./vagrant_run.sh test.sh amd64
    Script successfully run on: Linux lucid64 2.6.32-38-server #83-Ubuntu SMP Wed Jan 4 11:26:59 UTC 2012 x86_64 GNU/Linux

If you want to do this manually on some non-Vagrant-provisioned box for
`<%= reasons %>`, check out the `server_init.sh` script to get an idea
of the setup steps.

New Packages
------------

Cargo-cult an existing script. Note that most of the scripts rely on
the source package's `make install` command responding to the `DESTDIR`
environment variable. If building a package that does not, you may
have to manually copy things into a suitable location for `fpm` (see
`redis.sh` for an example).

Packages are responsible for installing their own prerequisites - assume
that the script will be run as a user with password-free sudo access.

Using the repo
--------------

You will need the public key as above, and must tell `apt` about it thusly:

    $ sudo apt-key add tribesports-pubkey.asc

Then add the repo to your sources:

    deb http://packages.tribesports.com/ubuntu lucid-tribesports main

Finally, update apt:

    $ sudo apt-get update
