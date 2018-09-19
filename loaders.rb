#!/usr/bin/ruby

require 'net/http'
require 'uri'
require 'optparse'
require 'ostruct'
require 'socket'
require 'timeout'
require 'fileutils'
require 'colorize'
require 'open-uri'
require	'json'
require 'rubygems'
require 'digest/md5'
require 'benchmark'
require 'thread'
require 'mongo'

require './lib/url_validation'
require './lib/ip_validation'
require './lib/logs'
require './lib/mongodb_connect'

require './lib/exploit_initialize'
require './lib/phpmyadmin_scanner'
require './lib/wp_plugin_scanner'
require './lib/cpanel_bruteforce'
require	'./lib/benchmarks_record'
require './lib/github_dorker'
require './lib/port_scanner'
require './lib/md5_decrypter'
require './lib/reverse_ip'
require './lib/get_proxy'
require './lib/google_dork'
require './lib/wp_bruteforce'
require './lib/wp_dictionary'
require './lib/bypass_login'
require './lib/url_scapper'