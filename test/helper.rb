require 'rubygems'
require 'minitest/autorun'
require 'minitest/pride'
require 'rack/mock'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rack_clicky'
