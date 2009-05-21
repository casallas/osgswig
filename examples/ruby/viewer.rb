#!/usr/bin/ruby

#
# Demonstation for Ruby
#

puts $LOAD_PATH


# extend the load path for wosg
$LOAD_PATH << '../../bin/ruby'


# include all necessary libs
require 'wosg'
require 'wosgDB'
require 'wosgProducer'

class Viewer

	def initialize()

    	# open a viewer
		@viewer = WosgProducer::Viewer.new

		# open
		@viewer.setUpViewer(WosgProducer::Viewer::STANDARD_SETTINGS)

		puts "Reading Data ... "

		n = WosgDB::readNodeFile("cow.osg")

		root = Wosg::Group.new()

		root.addChild(n)

		@viewer.setSceneData(root)

		puts "Show the Window ... "

		@viewer.realize()

	end

	def run()

		while !@viewer.done()

			@viewer.sync

			@viewer.update

			@viewer.frame

		end
	end

end

v = Viewer.new
v.run
