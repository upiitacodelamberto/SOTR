#___ test_fopen.s __________________________________________________________
#
        .include "include.asm"

        .globl main
main:
        _print hallo            # Print title
        _open bestand mode      # Open the file 'dummy.dummy'
        cmp $0,%eax             # Success?
        je file_error           # No, Print error message
        _close %eax             # Yes, Close file
        _print bestaat          # Print text 'exist'
        jmp einde               # End of prg.
file_error:
        _print bestaat_niet     # Print text 'doesn't exist'
einde:
        ret                     # The End ;-)

hallo:
 .string "Test Linux Program ;-) \n"
bestaat:
 .string "The file dummy.dummy exists..."
bestaat_niet:
 .string "The file dummy.dummy doesn't exist..."
bestand:
 .string "dummy.dummy"
mode:
 .string "r"

.END
