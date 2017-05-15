#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'nokogiri'
require 'open-uri'
require 'logger'

require_relative 'swift_poems_project/tei'
require_relative 'swift_poems_project/nota_bene'
require_relative 'swift_poems_project/g_drive'
require_relative 'swift_poems_project/encoder'

require_relative 'swift_poems_project/transcript'
require_relative 'swift_poems_project/element'
require_relative 'swift_poems_project/header'
require_relative 'swift_poems_project/heading'
require_relative 'swift_poems_project/title_set'
require_relative 'swift_poems_project/body'

module SwiftPoemsProject
  # Constants

  # Types of documents
  POEM = 'poem'
  LETTER = 'letter'

  # Modes for encoding
  READING = 'reading'
  COLLATION = 'collation'

  XML_CHAR_REFS = {
    '&' => '&amp;',
    '"' => '&quot;',
    "'" => '&apos;',
    '<' => '&lt;',
    '>' => '&gt;',
  }

  # The XML TEI namespace
  TEI_NS = {'tei' => 'http://www.tei-c.org/ns/1.0'}

  POEM_ID_PATTERN = /^[0-9A-Z\!\-#\$\·]{8}\s+/

  ID_ESCAPE_CHARS = {
    '!' => '0021',
    '#' => '0023',
    '$' => '0024',
    '%' => '0025',
    '@' => '0040'
  }

  class Footer < Element
  end
end
