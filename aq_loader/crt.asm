  IFNDEF    CRT_ORG_BANK_0
        defc    CRT_ORG_BANK_0=$0000
  ENDIF

  IFNDEF    CRT_ORG_BANK_1
        defc    CRT_ORG_BANK_1=$4000
  ENDIF

  IFNDEF    CRT_ORG_BANK_2
        defc    CRT_ORG_BANK_2=$8000
  ENDIF

  IFNDEF    CRT_ORG_BANK_3
        defc    CRT_ORG_BANK_3=$c000
  ENDIF

  IFDEF CRT_ORG_BANK_0
        SECTION BANK_0
        org     CRT_ORG_BANK_0
        SECTION VECTORS
        SECTION CODE_0
        SECTION RODATA_0
        SECTION DATA_0
        SECTION BSS_0
        SECTION HEAP_0
  ENDIF

  IFDEF CRT_ORG_BANK_1
        SECTION BANK_1
        org     CRT_ORG_BANK_1
        SECTION CODE_1
        SECTION RODATA_1
        SECTION DATA_1
        SECTION BSS_1
        SECTION HEAP_1
  ENDIF

  IFDEF CRT_ORG_BANK_2
        SECTION BANK_2
        org     CRT_ORG_BANK_2
        SECTION CODE_2
        SECTION RODATA_2
        SECTION DATA_2
        SECTION BSS_2
        SECTION HEAP_2
  ENDIF

  IFDEF CRT_ORG_BANK_3
        SECTION BANK_3
        org     CRT_ORG_BANK_3
        SECTION CODE_3
        SECTION RODATA_3
        SECTION DATA_3
        SECTION BSS_3
        SECTION HEAP_3
  ENDIF

