# -*- coding: utf-8 -*-

require_relative 'spec_helper'

describe SwiftPoemsProject::NotaBene::Document do

  describe '.new' do

    it 'parses Nota Bene text content' do
      nota_bene_content = File.read(File.join(File.dirname(__FILE__), 'fixtures', 'nb', '686-579V'))
      nota_bene = described_class.new(content: nota_bene_content.encode('utf-8','cp437'))
    end
    
    it 'parses Nota Bene text content' do
      nota_bene = described_class.new(file_path: File.join(File.dirname(__FILE__), 'fixtures', 'nb', '686-579V'))
    end
  end
end
