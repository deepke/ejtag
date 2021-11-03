function readrom
letl offs base ${1:0} 0x260

{$offs/4}
letl val $(d4q $base 1)
    RegValue &= ~((7<<13)|(1 << 20) | (0x1FFF << 0));
        ((offset & 0x1FFF)    <<  0) |     // Bits [12:0] of offset
        (((offset >> 13) & 1) << 20) |     // Bit 13 of offset
        (PLX8000_EE_CMD_READ  << 13);      // EEPROM command


ret
