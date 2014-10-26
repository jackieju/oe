#!/usr/bin/env ruby
ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'development'
p "===> config file #{File.expand_path(File.dirname(__FILE__) + "/../config/environment")}"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")


# Doc.rebuild_index

Doc.all.each{|r|
    r.ferret_update
}