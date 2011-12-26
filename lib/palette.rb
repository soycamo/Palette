# Palette.rb : Returns an array or hash of a palette file.
# Written by Cameron Adamez under the BSD license.
# cameron [at] soycow <dot> org

module Palette

	class Palette
		attr_reader :colors, :named_colors

		def initialize(file)
			@f = File.new(file)
		end
	end

	class Aco < Palette
		def colors
			get_palette
		end

		private
		def get_palette
			# thanks to http://www.nomodes.com/aco.html
			@colors = []
			#RGBColorEntry = Struct.new(:name, :red, :green, :blue)
			#CMYKColorEntry = Struct.new(:name, :cyan, :magenta, :yellow, :black)
			version = (@f.read(2)).unpack('xc')[0]
			num = (@f.read(2)).unpack('H*')[0].hex
			# We're assuming that the file has only one color type.
			cs = colorspace
			#if version == 2 || (version == 1 && has_names?(num))
				# check to see if it can get names instead.
			#	p "you can get the names!!"
			#else
				# just return the colors.
				@f.seek 4
					num.times do	
						col = @f.read(10).unpack(cs)
						p col
						@colors << col.to_s
					end	
			#end

=begin
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

		def has_names?(entries)
			return true if (@f.seek(entries * 10 + 8); @f.pos < File.size(@f))
		end

		def colorspace
			# This is a little redundant but being kept as a comment.
			# The user might want to know the actual name of the colorspace.
			#c_space = { 0 => :RGB, 1 => :HSB, 2 => :CMYK, 7 => :Lab, 8 => :Grey, 9 => :WCMYK }
			colorspace = { 0 => 'xxH2xxH2H2'} #:HSB => '', :CMYK => '', :Lab => '', :Grey => '', :WCMYK => '' }
			colorspace.default = 'H2H2H2H2H2H2H2H2H2H2'
			pos = @f.pos
			cs = colorspace[@f.read(2).unpack('xc')[0]].to_s
			@f.pos = pos
			return cs
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

=begin
if !ARGV[0].nil? && File.file?(ARGV[0])
	aco = Palette::Aco.new(ARGV[0]).colors
	p aco[0..10]
	p aco.length
else
	puts "Usage: palette.rb filename.aco"
end
=end
