require_relative "g_drive/g_drive_service"
require_relative "g_drive/nota_bene_store"

module SwiftPoemsProject
  module GDrive

    EXCLUDED_TRANSCRIPTS = [
      'J0311801',
      'J0311851',
      'J0311871',
      'J03155H1',
      '!W61500B',
      '147-315B',
      '147-210I',
      '147-122Z',
      '244-201I',
      '419B720L',
      '673A338H',
      '162-953Y',
      '531M500B',
      '553-1951',
      '250-20L8',
      '!W2893L9',
      '!W2793XO',
      '250-20L8',
      '!W2893XO',
      '!W2795L4',
      '!W2793L9',
      '!W2892D1',
      '!W2792D1',
      '!W2792L4',
      'Z75930KE',
      '!W2892L4',
      '!W2894L6',
      '!W2895L4',
      '!W2794L6',
      'P00638X5',
      'X73C914L',
      'Z789814B',
      'P02710M2',
      '825-530V',
      '420-519V',
      'PRINTER4',
      'CASEDIDD',
      'QUOTTEST',
      'LOCATION',
      'INSTALL1',
      'TAIL.EXE',
      'UNSTACK1',
      'GF-ADVTS',
      'NUVRIANT',
      'NOTABENE',
      'PRINTER1',
      'MATH.KBD',
      'ORIG.KBD',
      'INSTALL2',
      'PRINTER3',
      'CONVERT2',
      'WORD.OVR',
      'CONVERT1',
      'PRINTER2',
      'PRINTER0',
      'TEXTBASE',
      'MAIN.DCT',
      'HIDIDDLY',
      'SUPERDOT',
      'FILENAME',
      'WFBG.SYN',
      'DICT.SPL',
      'OMIT.LST',
      'FAIRLOCA',
      'FAULKNER',
      'CASELES2',
      'CASELES1',
      'FAULFAIR',
      'TODOLIST',
      'TS-GRIFF',
      'FILELIST',
      'CASELES3',
      'CASELES4',
      'CASELES5',
      'CHECKING',
      'SPPINTRO'
    ]

    EXCLUDED_SOURCES = [
      '4DOS750',
      'BIBLS',
      'CASE',
      'DESCRIBE',
      'EDIT',
      'FAIRBROT',
      'FAULKNER',
      'HW37',
      'INSTALL',
      'INV',
      'MSSOURCE',
      'NB',
      'NEWDOS',
      'POEMCOLL',
      'PRSOURCE',
      'STEMMAS',
      'TEI-SAMP',
      'VDOS',
      'XML-TEST'
    ]

    EXCLUDED_SUFFIXES = [
      '.bak',
      '.tmp',
      '.xls',
      '.doc',
      '.pdf',
      '.dct',
      '.ovr',
      '.exe',
      '.kbd',
      '.syn',
      '.spl',
      '.lst',
      '.999',
      '.com',
      '.hlp',
      '.nb3',
      '.pdf'
    ]

    EXCLUDED_PREFIXES = [
      'tocheck',
      'tochk',
      'readme',
      'another',
      'proof',
      '!W27',
      '!W28',
      'Dosbox'
    ]

    MIN_FILE_SIZE = 900
  end
end
