#!/usr/bin/env ruby

# Palette.rb : Returns an array or hash of a palette file.
# Written by Cameron Adamez under the BSD license.
# cameron [at] soycow <dot> org

module Palette

	class Palette
		attr_accessor :colors, :named_colors

		def initialize(file)
			@f = File.new(file)
		end
	end

	class Aco < Palette
		def colors
			get_palette
		end

		private
=begin
		def set_colorspace
			colorspace = { '00' => :RGB, '01' => :HSB, '02' => :CMYK, '07' => :Lab, '08' => :Grey, '09' => :WCMYK }
			unpacker = { :RGB => 'xxH2xxH2H2', :HSB => '', :CMYK => '', :Lab => '', :Grey => '', :WCMYK => '', }
			pos = @f.pos
			@f.read(2).unpack('H2')[0]
			
			@f.pos = pos
		end
=end
		def get_palette
			# thanks to http://www.nomodes.com/aco.html
			@colors = []
			#RGBColorEntry = Struct.new(:name, :red, :green, :blue)
			#CMYKColorEntry = Struct.new(:name, :cyan, :magenta, :yellow, :black)
			version = (@f.read(2)).unpack('c*').to_s
			num = (@f.read(2)).unpack('H*')[0].hex
			#set_colorspace # We're assuming that the file has only one color type.
			p version
			if version == "02" || (version == "01" && has_names(num))
				# check to see if it can get names instead.
				p "you can get the names!!"
			else
				# just return the colors.
				p "you can only get colors, sorry"
			end

=begin
			case version
				when "01"
					@f.seek 4
					num.times do	
						col = @f.read(10).unpack('H2H2H2H2H2H2H2H2H2H2')
						p col
						@colors << col.to_s
					end	
				when "02"
					@f.seek 4
					@f.seek(num * 10 + 8)
					num.times do
						@colors << @f.read(10).unpack('H2H2H2H2H2H2H2H2H2H2').to_s
						len = (@f.read(4)).unpack('xxxU')[0]
						@colors << @f.read(len*2).unpack('xa' * len).to_s.rstrip
					end
					@colors = Hash[*@colors.flatten]
			else
				p "unknown version"
			end
			@f.rewind
=end
			return @colors
		end

		def has_names(entries)
			return true if (@f.seek(entries * 10 + 8); @f.pos < File.size(@f))
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
	p aco[0..10]
	p aco.length
else
	puts "Usage: palette.rb filename.aco"
end
