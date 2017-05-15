# -*- coding: utf-8 -*-
module SwiftPoemsProject

  class NotaBeneNormalizer

    def self.normalize(poem)
      
      # Handles unencoded backspaces
      # See SPP-270
      # Combine with U+0323
      poem = poem.gsub /(.)«MDNM» ?08\./, "\\1\u0323«MDNM»"

      # Handles unencoded superscript
      # See SPP-272
      # poem = poem.gsub / ?08/, ""
      poem = poem.gsub(/ (?<!\d)08/, "") 

      poem = poem.gsub /«X4The\sEpitaph»/, ''

      poem = poem.gsub /«X4The\sEpitaph»/, ''
      poem = poem.gsub /«X2»/, ''
      
      # Substitutions for names: 18th century convention
      poem = poem.gsub /(\─)+»/, '\\1.»'
      
      poem = poem.gsub /«LD─\.?»/, "«LD »"
      poem = poem.gsub /«FC»«MDNM»/, "«FC»"
      poem = poem.gsub /«FL»_/, "_«FL»"

      poem = poem.gsub /\.»/, '..»'
      poem = poem.gsub /\)»/, ').»'
      poem = poem.gsub /\*»/, '*.»'
      poem = poem.gsub /\?»/, '?.»'
      poem = poem.gsub /`»/, '`.»'
      poem = poem.gsub /'»/, "'.»"
      poem = poem.gsub /!»/, "!.»"
      poem = poem.gsub /;»/, ";.»"
      poem = poem.gsub /,»/, ",.»"
      poem = poem.gsub /»\s»/, '» .»'
      poem = poem.gsub /\-»/, '-.»'
      
      poem = poem.gsub /H»/, "H.»"
      
      poem = poem.gsub /«MDbu»/, "«MDBU»"
      
      poem = poem.gsub /«ld »/, "«LD »"
      poem = poem.gsub /«LS»/, "«LD »"
      
      poem = poem.gsub /«MDUL»«FN1·/, "«FN1·«MDUL»"
      poem = poem.gsub /«MDUL»»«MDNM»/, "»"
      poem = poem.gsub /«FN1«MDUL»·/, '«FN1·«MDUL»'
      poem = poem.gsub /«FN1«MDNM»·/, '«FN1·'
      poem = poem.gsub /«FN1 /, '«FN1·'
      poem = poem.gsub /«FN1([0-9A-Z])/, '«FN1·\\1'
      poem = poem.gsub /«FN1\|·/, "«FN1·"
      poem = poem.gsub /«FN1\\/, "«FN1·\\"
      poem = poem.gsub(/#{Regexp.escape("«FN1──────")}/, "«FN1·──────")
      poem = poem.gsub /\\»/, "\\.»"
      poem = poem.gsub /\}«MDNM»3/, "}3"
      poem = poem.gsub /([\]\?\:a-z0-9])»/, '\\1.»'
      poem = poem.gsub /«MDRV»»/, '.»'
      poem = poem.gsub /«MDUL»»/, '.»'
      poem = poem.gsub /LD\s»/, 'LD»'
      poem = poem.gsub /.\s+»/, '.»'
      poem = poem.gsub /·»/, '.»'
      poem = poem.gsub /([[:lower:]])»/, '\\1.»'
    end
  end
end
