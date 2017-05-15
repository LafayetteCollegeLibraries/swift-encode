# -*- coding: utf-8 -*-

require_relative 'spec_helper'

describe SwiftPoemsProject::Encoder::TeiEncoder do

  let(:encoder) { described_class.new(File.join(File.dirname(__FILE__), '..', 'tmp', 'tei')) }

  describe '#encode' do
    it 'encodes Nota Bene files into valid XML Documents' do

      transcript_id = '686-579V'
      transcript_content = File.read( File.join( File.dirname(__FILE__), 'fixtures', 'nb', '686-579V' ))
      transcript_mtime = Date.new
      
      tei_xml = encoder.encode('686-', transcript_id, transcript_content.encode('utf-8','cp437'), transcript_mtime)
      
      tei_doc = Nokogiri::XML(tei_xml) { |config| config.strict }
    end

    it 'encodes all lines in the Nota Bene file into valid XML' do

      transcript_id = '686-33L9'
      transcript_content = File.read( File.join( File.dirname(__FILE__), 'fixtures', 'nb', '686-33L9' ))
      transcript_mtime = Date.new
      
      tei_xml = encoder.encode('686-', transcript_id, transcript_content.encode('utf-8','cp437'), transcript_mtime)
      tei_doc = Nokogiri::XML(tei_xml)
      
      tei_lines = tei_doc.xpath('//tei:div/tei:lg/tei:l', 'tei' => 'http://www.tei-c.org/ns/1.0')
      expect(tei_lines.length).to be(907)
    end
  end
end
