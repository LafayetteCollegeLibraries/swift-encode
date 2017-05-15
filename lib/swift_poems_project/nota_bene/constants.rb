# coding: utf-8

module SwiftPoemsProject
  module NotaBene

          # Regular expression for extracting poem ID's
#  POEM_ID_PATTERN = /[0-9A-Z\!\-]{8}\s{3}\d+\s/

  DECORATOR_PATTERN = /«MD[SUNMD]{2}»\*(«MDNM»)?/
  
  NB_EMPTY_LINE = '_'

  # Nota Bene toke maps
  NB_TERNARY_TOKEN_TEI_MAP = {

    '«MDRV»' => {

      :secondary => {

        '«MDSD»' => { 'hi' => { 'rend' => 'small-caps' } }
      },

      :terminal => { '«MDNM»' => { 'hi' => { 'rend' => 'display-initial' } }
        
      }
    },

    '«MDBU»' => {

      :secondary => { '«MDUL»' => { 'hi' => { 'rend' => 'black-letter' } }
      },

      :terminal => { '«MDNM»' => { 'hi' => { 'rend' => 'black-letter' } }
      }
    },

    '«MDSD»' => {

      :secondary => {

        '«MDUL»' => { 'hi' => { 'rend' => 'italics' } }
      },
      :terminal => {

        '«MDNM»' => { 'hi' => { 'rend' => 'small-caps' } }
      },
    },

    '«MDUL»' => {

      :secondary => {
        '«FC»' => { 'hi' => { 'rend' => 'underlined' } },
        '«MDBO»' => { 'hi' => { 'rend' => 'underlined' } },
        '«MDSD»' => { 'hi' => { 'rend' => 'small-caps' } },
      },

      :terminal => { '«MDNM»' => { 'head' => { } } }
    },

    
    '«MDSU»' => {

      :secondary => {

        '«MDBU»' => { 'hi' => { 'rend' => 'superscript' } },
        '«MDUL»' => { 'hi' => { 'rend' => 'italics' } }
      },

      :terminal => { '«MDNM»' => { 'hi' => { 'rend' => 'black-letter' } }
        
      }
    },
  }
    NB_ASCII_SEQS = {
    /\\ae\\/ => 'æ',
    /\\AE\\/ => 'Æ',
    /\\oe\\/ => 'œ',
    /\\OE\\/ => 'Œ',
    /``/ => '“',
    /''/ => '”',
    /─/ => '─'
  }

  NB_MODECODES = {

    '«MDUL»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'italics' } },
      '«MDBO»' => { 'hi' => { 'rend' => 'black-letter' } },
      '«MDUL»' => { 'hi' => { 'rend' => 'italics' } },
      '«MDBR»' => { 'hi' => { 'rend' => 'small-caps-italic' } },
    },
    
    '«MDBO»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'black-letter' } }
    },
    
    # "These Guidelines make no binding recommendations for the values of the rend attribute; the characteristics of visual presentation vary too much from text to text and the decision to record or ignore individual characteristics varies too much from project to project. Some potentially useful conventions are noted from time to time at appropriate points in the Guidelines. The values of the rend attribute are a set of sequence-indeterminate individual tokens separated by whitespace."
    # http://www.tei-c.org/release/doc/tei-p5-doc/en/html/ref-att.global.html#tei_att.rend

    '«MDBR»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'small-caps-italic' } }
    },

    '«MDBU»' => {
        #'«MDNM»' => { 'hi' => { 'rend' => 'bold underline' } }
        # NOTE: This is not within the standard TEI (?)
        # (Formerly "special-state")
      '«MDNM»' => { 'hi' => { 'rend' => 'display-initial-italic' } },
      '«MDUL»' => { 'hi' => { 'rend' => 'italics' } }
    },

    '«MDDN»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'strikethrough' } }
    },
    
    '«MDRV»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'display-initial' } },
      '«MDUL»' => { 'hi' => { 'rend' => 'italics' } }
    },

    '«MDSD»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'small-caps' } }
    },

    # Source:
    '«MDSU»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'superscript' } },
      '«MDBU»' => { 'hi' => { 'rend' => 'display-initial-italic' } }
    },

    # Extended modecodes
    '«MDBS»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'large-writing' } }
    },
    '«MDBT»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'large-writing-underlined' } }
    },
    '«MDUM»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'underlined' } }
    },
    '«MDUP»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'underlined-double' } }
    },
    '«MDUR»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'red-ink' } }
    },
    '«MDUS»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'red-ink-large' } }
    },
    '«MDUN»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'printed-writing' } }
    },
    '«MDUO»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'printed-writing-underlined' } }
    },
    '«MDSR»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'superscript-italic' } }
    },
    '«MDRO»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'display-initial-black-letter' } }
    },
    '«MDBP»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'fraktur' } }
    },
    '«MDBQ»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'fraktur-large' } }
    },
    '«MDBV»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'undefined' } }
    },
  }

  NB_MARKUP_TEI_MAP = {

    '«DECORATOR»' => {
      '«/DECORATOR»' => { 'unclear' => { 'reason' => 'illegible' } }
    },

    '«MDUL»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'italics' } },
      '«MDBO»' => { 'hi' => { 'rend' => 'black-letter' } },
      '«MDUL»' => { 'hi' => { 'rend' => 'italics' } },
      '«MDBR»' => { 'hi' => { 'rend' => 'small-caps-italic' } },
    },
    
    '«MDBO»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'black-letter' } }
    },
    
    # "These Guidelines make no binding recommendations for the values of the rend attribute; the characteristics of visual presentation vary too much from text to text and the decision to record or ignore individual characteristics varies too much from project to project. Some potentially useful conventions are noted from time to time at appropriate points in the Guidelines. The values of the rend attribute are a set of sequence-indeterminate individual tokens separated by whitespace."
    # http://www.tei-c.org/release/doc/tei-p5-doc/en/html/ref-att.global.html#tei_att.rend

    '«MDBR»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'small-caps-italic' } }
    },

    '«MDBU»' => {
        #'«MDNM»' => { 'hi' => { 'rend' => 'bold underline' } }
        # NOTE: This is not within the standard TEI (?)
        # (Formerly "special-state")
      '«MDNM»' => { 'hi' => { 'rend' => 'display-initial-italic' } },
      '«MDUL»' => { 'hi' => { 'rend' => 'italics' } }
    },

    '«MDDN»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'strikethrough' } }
    },
    
    '«MDRV»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'display-initial' } },
      '«MDUL»' => { 'hi' => { 'rend' => 'italics' } }
    },

    '«MDSD»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'small-caps' } }
    },

    # Source:
    '«MDSU»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'superscript' } },
      '«MDBU»' => { 'hi' => { 'rend' => 'display-initial-italic' } }
    },

    # Extended modecodes
    '«MDBS»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'large-writing' } }
    },
    '«MDBT»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'large-writing-underlined' } }
    },
    '«MDUM»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'underlined' } }
    },
    '«MDUP»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'underlined-double' } }
    },
    '«MDUR»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'red-ink' } }
    },
    '«MDUS»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'red-ink-large' } }
    },
    '«MDUN»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'printed-writing' } }
    },
    '«MDUO»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'printed-writing-underlined' } }
    },
    '«MDSR»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'superscript-italic' } }
    },
    '«MDRO»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'display-initial-black-letter' } }
    },
    '«MDBP»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'fraktur' } }
    },
    '«MDBQ»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'fraktur-large' } }
    },
    '«MDBV»' => {
      '«MDNM»' => { 'hi' => { 'rend' => 'undefined' } }
    },

    # For footnotes
    '«FN1·' => {
      '»' => { 'note' => { 'place' => 'foot' } },
      '.»' => { 'note' => { 'place' => 'foot' } },
      '──────»' => { 'note' => { 'place' => 'foot' } }
    },

    # Additional footnotes
    '«FN1' => {
      '»' => { 'note' => { 'place' => 'foot' } },
      '.»' => { 'note' => { 'place' => 'foot' } }
    },

    # Additional footnotes
    '«FN1«MDNM»' => {
      '»' => { 'note' => { 'place' => 'foot' } }
    },

    # For deltas
    # The begin-center (FC, FL) delta
#    '«FC»' => {
      
#      '«MDNM»' => { 'note' => { 'rend' => "align(center)" } }
#    },

    # The end-of-center (FL, FL) delta
#    '«FL»' => {      
#      '«MDNM»' => { 'note' => { 'rend' => "flush left" } },
#    },
    
    # The flush right (FR, FL) delta
#    '«FR»' => {
      
#      '«FL»' => { 'note' => { 'rend' => "flush right" } }
#    },
    
    # <gap>
    'om' => {
      '.' => { 'gap' => {} }
    },
  }

  # This hash is for Nota Bene tokens which encompass a single line (i. e. they are terminated by a newline character rather than another token)
  NB_SINGLE_TOKEN_TEI_MAP = {

    # The flush right (LD) delta
    '«LD»' => {
      
      'note' => { 'rend' => "flush right" }
    },
    '«LD »' => {
      
      'note' => { 'rend' => "flush right" }
    },
    
    # Footnotes encompassing an entire line
    '«FN1·»' => {
      
      'note' => { 'place' => 'foot' }
    },

    '«UNCLEAR»' => {

      'unclear' => { 'reason' => 'illegible' }
    },

    '«FL»' => {

      'note' => { 'rend' => "flush left" }
    },

    '«FC»' => {
      
      'note' => { 'rend' => "align(center)" }
    },

    # The flush right (FR, FL) delta
    '«FR»' => {
      
      'note' => { 'rend' => "flush right" }
    },

    'om.' => {
      'gap' => {}
    },

    '^' => {
      'lb' => {}
    },

    NB_EMPTY_LINE => { }
  }

  NB_DELTA_FLUSH_TEI_MAP = {

    '«LD»' => {
      
      'rend' => "flush right"
    },

    '«FL»' => {

      'rend' => "flush left"
    },

    '«FC»' => {
      
      'rend' => "align(center)"
    },

    '«FR»' => {
      
      'rend' => "flush right"
    },
  }

  NB_DELTA_ATTRIB_TEI_MAP = {

    '«LD»' => {
      
      'rend' => "flush right"
    },

    '«FL»' => {

      'rend' => "flush left"
    },

    '«FC»' => {
      
      'rend' => "align(center)"
    },

    '«FR»' => {
      
      'rend' => "flush right"
    },
  }

  NB_CHAR_TOKEN_MAP = {
      
    /\\ae\\/ => 'æ',
    /\\AE\\/ => 'Æ',
    /\\oe\\/ => 'œ',
    /\\OE\\/ => 'Œ',
    /``/ => '“',
    /''/ => '”',
#    /(?<!«MDNM»|«FN1)·/ => ' ',
    /─ / => '─'    
  }

  NB_BLOCK_LITERAL_PATTERNS = [
    /(«MDSU»\*\*?«MDSD»\*)+«MDSU»\*«MDNM»\*?/,
    /#{Regexp.escape("«MDSD»*«MDNM»*«MDSD»*«MDNM»*«MDSD»*«MDNM»*«MDSD»*«MDNM»*«MDSD»*«MDUL»")}/,
    /#{Regexp.escape("«MDNM»*«MDSD»*«MDNM»*«MDSD»*«MDNM»*«MDSD»*«MDNM»*«MDSD»*«MDNM»*")}/,
    /#{Regexp.escape("«MDSU»*«MDSD»*«MDSU»*«MDSD»*«MDSU»*«MDSD»*«MDSU»*«MDSD»*«MDSU»*«MDSD»*«MDSU»*«MDSD»*«MDSU»*«MDSD»*«MDSU»*«MDSD»*«MDSU»*«MDSD»*«MDSU»*«MDSD»**«MDSU»*«MDSD»*«MDSU»*«MDSD»*«MDSU»*«MDSD»*«MDSU»*")}/,
  ]

  EXTENDED_MODECODES = {
    '≈«MDBO»' => '«MDBS»', # large writing
    '¿«MDBO»' => '«MDBT»', # large underlined writing
    '≈«MDUL»' => '«MDUM»', # underlining
    '¿«MDUL»' => '«MDUR»', # red ink
    '¿«MDRV»' => '«MDUS»', # red ink large writing
    '■«MDSD»' => '«MDUP»', # double underlined
    '≈«MDSD»' => '«MDUN»', # printed writing
    '¿«MDSD»' => '«MDUO»', # printed underlined writing
    '≈«MDSU»' => '«MDSR»', # italic superscript
    '■«MDBU»' => '«MDRO»', # black letter display initial
    '■«MDBO»' => '«MDBP»', # Fraktur
    '■«MDBR»' => '«MDBQ»', # large Fraktur
    '≈«MDBU»' => '«MDBV»', # special state to be further defined
  }

  end
end
