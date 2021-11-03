getpc()
{
pcsample=$(ejtag_debug_usb jtagregs d8q 20 1)
pc=$(printf "0x%x" $(($pcsample>>1)))
echo $pc
}

getpc
