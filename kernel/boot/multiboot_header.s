.section .multiboot_header, "a"
.balign 16

.set MB2_MAGIC, 0xE85250D6
.set MB2_ARCH,  0x00000000 # 0 = i386
.set MB2_HEADER_LEN, header_end - header_start

header_start:
  .long MB2_MAGIC
  .long MB2_ARCH
  .long MB2_HEADER_LEN
  .long -(MB2_MAGIC + MB2_ARCH + MB2_HEADER_LEN) # checksum
  # TAG: END
  .short 0 # type = 0 (end)
  .short 0 # flags = 0
  .long 8 # size = 8
  
  .balign 8

header_end:
