# -*- coding: utf-8 -*-

require_relative 'spec_helper'

describe SwiftPoemsProject::Transcript do

  describe '.new' do

    it 'parses Nota Bene text content' do
      nota_bene_content = File.read(File.join(File.dirname(__FILE__), 'fixtures', 'nb', '686-579V'))
      nota_bene = SwiftPoemsProject::NotaBene::Document.new(content: nota_bene_content.encode('utf-8','cp437'))

      transcript = described_class.new(nota_bene, 'reading')
    end
  end
end
