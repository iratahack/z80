        public  vsync

        section CODE_0
        ; Wait for VSYNC
vsync:
        ld      b, 0xf5                 ; PPI port B input
wait_vsync:
        in      a, (c)                  ; read PPI port B input
                                        ; (bit 0 = "1" if vsync is active,
                                        ;  or bit 0 = "0" if vsync is in-active)
        rra                             ; put bit 0 into carry flag
        jp      nc, wait_vsync          ; if carry not set, loop, otherwise continue

        ret
