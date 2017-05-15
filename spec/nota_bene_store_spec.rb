# -*- coding: utf-8 -*-

require_relative 'spec_helper'

describe SwiftPoemsProject::GDrive::NotaBeneStore do

  describe '.excluded?' do

    context 'with a transcript excluded by ID' do
      let(:file) { double('File', :name => '420-519V', :size => 901) }

      it 'excludes transcripts by ID' do
        expect { described_class.excluded?(file) }.to raise_error("File 420-519V is excluded")
      end
    end

    context 'with a transcript' do
      let(:file) { double('File', :name => '006-HW37', :size => 901) }

      it 'excludes transcripts by source ID' do
        expect { described_class.excluded?(file, 'HW37') }.to raise_error("Source HW37 is excluded")
      end
    end
    
    context 'with a transcript' do
      let(:file) { double('File', :name => 'testfile.bak', :size => 901) }

      it 'excludes transcripts by suffix' do
        expect { described_class.excluded?(file) }.to raise_error("File testfile.bak is excluded by suffix")
      end
    end

    context 'with a transcript' do
      let(:file) { double('File', :name => '!W27test', :size => 901) }

      it 'excludes transcripts by prefix' do
        expect { described_class.excluded?(file) }.to raise_error("File !W27test is excluded by prefix")
      end
    end

    context 'with a transcript' do
      let(:file) { double('File', :name => '006-HW37', :size => 899) }

      it 'excludes transcripts by size' do
        expect { described_class.excluded?(file) }.to raise_error("File 006-HW37 is excluded by size")
      end
    end
  end
end
