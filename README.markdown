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
  * s3cmd installed on your local machine

You will also need the password for the signing key.

Workflow
--------

A Vagrantfile and provisioning script are provided to set up VMs to
build the packages. 32-bit and 64-bit VMs are provisioned and booted,
named precise{32,64}. To build a package, follow these steps:

  1. `$ ./fetch_repo` - Fetch existing packages from repo
  2. `$ vagrant up` - create, boot and provision the VMS
  3. `$ ./vagrant_run <package_script>` - Build your chosen package(s)
  4. `./vagrant_run build_repo <boxname>` Build the repo (you will be prompted
     for the signing passphrase)
  5. `./push_repo` - upload the repo to the S3 bucket

By default the `vagrant_run.sh` script will run the provided command
on both 32 and 64-bit environments. Some packages may not require
arch-specific builds (e.g. solr, being a Java package) - if this is
the case specify the box you would like to build on:

    $ ./vagrant_run runners/solr precise64

If you want to do this manually on some non-Vagrant-provisioned box for
`<%= reasons %>`, check out the `server_init.sh` script to get an idea
of the setup steps - really the only requirements are:

  1. ruby
  2. dpkg-dev
  3. fpm (a ruby gem)

New Packages
------------

Cargo-cult an existing script. Note that most of the scripts rely on
the source package's `make install` command responding to the `DESTDIR`
environment variable. This means you can configure the build with a
regular prefix (e.g. `/usr/local`) but then install the files to a clean
directory so that `fpm` can package them. If building a package that
does not respect DESTDIR, you may have to manually copy things into a
suitable location for `fpm` (see `redis.sh` for an example).

Packages are responsible for installing their own prerequisites - assume
that the script will be run as a user with password-free sudo access.

Package names are prefixed with `ts-` to clearly distinguish them from
official ubuntu packages.

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
