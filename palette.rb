#!/usr/bin/env ruby

# Palette.rb : Returns an array or hash of a palette file.
# Written by Cameron Adamez under the BSD license.
# cameron [at] soycow <dot> org

module Palette
	class Aco

		attr_accessor :colors, :named_colors

		def initialize(file)
			@f = File.new(file)
		end

		def colors
			get_palette
		end

		def named_colors
			get_palette(true)
		end

private
		def get_palette(named=false)
			# thanks to http://www.nomodes.com/aco.html
			# First two bytes are "0001" (section one).
			# Second two bytes are the number of colors.
			# Then a 10 byte code of the following (RGB only):
			#	0000 rrrr gggg bbbb 0000
			@colors = []
			version = (@f.read(2)).unpack('c*').to_s
			num = (@f.read(2)).unpack('H*')[0].hex
			case version
				when "01"
				@f.seek(num * 10 + 8); pos = @f.pos
				if ( pos < File.size(@f)) && named 
					@f.seek 4
					@f.seek(num * 10 + 8)
					num.times do
						@colors << @f.read(10).unpack('xxH2xxH2H2').to_s
						len = (@f.read(4)).unpack('xxxU')[0]
						@colors << @f.read(len*2).unpack('xa' * len).to_s.rstrip
					end
					@colors = Hash[*@colors.flatten]
				else
					@f.seek 4
					num.times do 
						@colors << @f.read(10).unpack('xxH2xxH2H2').to_s
					end	
				end
				@f.rewind
			when "02"
				p "version 3"
			else
				p "unknown version"
			end
			return @colors
		end

	end

	class Gpl 
		# A text file. Easy peasy!
	end

	class Ai
		# Requires RDF parsing. Look for:
		# rdf:parseType="Resource"
		# xapG:swatchName (only for naming!)
		# xapG:red, xapG:green, xapG:blue
	end

	class Ase
		# looks like more slice n dice byte style
	end
end

if !ARGV[0].nil? && File.file?(ARGV[0])
	aco = Palette::Aco.new(ARGV[0]).colors
	p aco
	p aco.length
else
	puts "Usage: palette.rb filename.aco"
end
