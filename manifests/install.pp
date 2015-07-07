# == Class sssd::install
#
class sssd::install {
  package { $sssd::sssd_package_name: ensure => present, }

  case $osfamily {
    'debian' : {
      package { libpam-sss: ensure => present, }

      package { libnss-sss: ensure => present, }

      package { libnss-ldap: ensure => present, }

      file_line { 'ldap_base_entry':
        path  => '/etc/ldap.conf',
        line  => 'base ${$ldap_dn}',
        match => '^base.*',
      }

      file_line { 'ldap_uri_entry':
        path  => '/etc/ldap.conf',
        line  => 'uri ${$ldap_uri}',
        match => '^uri.*',
      }
    }
    default  : {
    }
  }

  if $sssd::manage_idmap {
    package { $sssd::idmap_package_name: ensure => present, }
  }

  if $sssd::manage_authconfig {
    package { $sssd::authconfig_package_name: ensure => present, }
  }

  if $sssd::use_legacy_packages {
    package { $sssd::legacy_package_names: ensure => present, }
  }

}
