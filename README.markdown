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

You need vagrant 1.2 or higher, available from
[http://vagrantup.com](http://vagrantup.com). This is different from the
gem; Vagrant is now distributed as a binary download.

You will need the following files to sign and upload the resulting
repository:

  * `tribesports-privkey.asc` - repository signing private key
  * `tribesports-pubkey.asc` - repository signing public key
  * `s3cfg-tribesports` - `s3cmd` configuration containing S3 access keys

You will also need the password for the signing key.

Workflow
--------

A Vagrantfile and provisioning script are provided to set up VMs to
build the packages. 32-bit and 64-bit VMs are provisioned and booted,
named lucid{32,64} and precise{32,64}. You will need 
  1. Fetch existing packages from repo: `./fetch.sh`
  2. Provision and boot the VMs: `vagrant up`
  3. Build your chosen package(s), e.g.: `./vagrant_run.sh
     ruby-1.9.sh`
  4. Build the repo: `./vagrant_run.sh repo.sh <boxname>` (you will be prompted
     for the signing passphrase)
  5. Upload the repo `./sync.sh`

By default the `vagrant_run.sh` script will run the provided command
on both 32 and 64-bit environments. Some packages may not require
arch-specific builds (e.g. solr, being a Java package) - if this is
the case specify the box you would like to build on:

    $ ./vagrant_run.sh test.sh lucid64
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

Import the public key:

    $ gpg --keyserver pgp.mit.edu --recv-keys D07E8C22
    $ gpg --export --armor D07E8C22 | apt-key add -

Then add the repo to your sources by adding the following line in the
file `/etc/apt/sources.d/tribesports.list`:

    deb http://packages.tribesports.com/ubuntu precise-tribesports main

(Adjust the Ubuntu release codename appropriately if you are using an
earlier version of Ubuntu).

Finally, update apt:

    $ sudo apt-get update

And install whatever packages you need.
