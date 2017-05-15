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
      '420-519V'
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
