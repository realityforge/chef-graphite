Description
===========

[![Build Status](https://secure.travis-ci.org/realityforge/chef-graphite.png?branch=master)](http://travis-ci.org/realityforge/chef-graphite)

Installs and configures Graphite http://graphite.wikidot.com/

Requirements
============

* Ubuntu 10.04 (Lucid) - with default settings
* Ubuntu 11.10 (Oneiric) - change node['graphite']['python_version'] to "2.7"
* Should run on CentOS 5+, RedHat etc.

Attributes
==========

* `node['graphite']['web']['password']` sets the default password for graphite "root" user.

Usage
=====

`recipe[graphite]` should build a stand-alone Graphite installation.

Caveats
=======

Ships with two default schemas, stats.* (for Etsy's statsd) and a
catchall that matches anything. The catchall retains minutely data for
13 months, as in the default config. stats retains data every 10 seconds
for 6 hours, every minute for a week, and every 10 minutes for 5 years.
