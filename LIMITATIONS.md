# nginx_simplecgi Limitations

This cookbook manages SimpleCGI dispatcher scripts for NGINX and uses OS packages for FastCGI support.

## Platform Support

The migrated resources require systemd and Chef Infra Client 16.0 or later. Legacy SysV init, runit, and upstart service management are no longer supported.

Primary tested platforms are:

* AlmaLinux 9
* Debian 12
* Ubuntu 24.04

The cookbook metadata still declares broader Linux family support where the required packages are available, but older EOL releases were removed from local and CI kitchen coverage.

## Package Availability

Debian and Ubuntu use:

* `libfcgi-perl`
* `libfcgi-procmanager-perl`
* `spawn-fcgi`
* `php-cgi`

RHEL-family platforms use:

* `perl-FCGI`
* `perl-FCGI-ProcManager`
* `php`

RHEL-family package availability depends on EPEL for the FastCGI packages, so the dispatcher resources include `yum-epel::default` on RHEL-family platforms when EPEL packages are required. EPEL 9 does not currently provide `spawn-fcgi`, so the PHP dispatcher is skipped on RHEL-family 9 and newer platforms.

## Source Installs

The cookbook does not compile FastCGI, PHP, Perl modules, or NGINX from source. Platforms without compatible package repositories require local repository mirroring or wrapper resources outside this cookbook.

## References

* Debian packages: <https://packages.debian.org/>
* Ubuntu packages: <https://packages.ubuntu.com/>
* Fedora/EPEL packages: <https://packages.fedoraproject.org/>
* Amazon Linux 2023 package support: <https://docs.aws.amazon.com/linux/al2023/release-notes/support-info-by-package.html>
