# Palette spec file: palette_spec.rb
#	aco = Palette::Aco.new(ARGV[0]).colors

require '../lib/palette.rb'

describe Palette do
  context "with ACO files" do
    it "returns an array of colors" do
      aco = Palette::Aco.new('samples/mypalette.aco')
      aco.colors.class.should == Array 
      aco.colors.length.should > 0
    end 
  end
end
