/* INCLUDE ../../generated/output_format.ld */

OUTPUT_FORMAT("elf32-littleriscv")

ENTRY(_start)

__DYNAMIC = 0;

/* INCLUDE ../../generated/regions.ld */

MEMORY {
	vexriscv_debug : ORIGIN = 0xf00f0000, LENGTH = 0x00000100
	dff : ORIGIN = 0x00000000, LENGTH = 0x00000400
	dff2 : ORIGIN = 0x00000400, LENGTH = 0x00000200
	flash : ORIGIN = 0x10000000, LENGTH = 0x01000000
	mprj : ORIGIN = 0x30000000, LENGTH = 0x00100000
	mm : ORIGIN = 0x38000000, LENGTH = 0x00000200  /* 3800 0000 ~ 3800 01FF (00~01) */
	data : ORIGIN = 0x38000200, LENGTH = 0x00000200  /* 3800 0200 ~ 3800 03FF (10~11)*/
	/*gcc : ORIGIN = 0x38000300, LENGTH = 0x00000100   3800 0300 ~ 3800 03FF (11)*/
	/*mprjram : ORIGIN = 0x38000000, LENGTH = 0x00400000*/
	hk : ORIGIN = 0x26000000, LENGTH = 0x00100000
	csr : ORIGIN = 0xf0000000, LENGTH = 0x00010000
}

SECTIONS
{
	.text :
	{
		_ftext = .;
		/* Make sure crt0 files come first, and they, and the isr */
		/* don't get disposed of by greedy optimisation */
		*crt0*(.text)
		KEEP(*crt0*(.text))
		KEEP(*(.text.isr))

		/* *(.text .stub .text.* .gnu.linkonce.t.*) */
		_etext = .;
	} > flash

	.rodata :
	{
		. = ALIGN(8);
		_frodata = .;
		*(.rodata .rodata.* .gnu.linkonce.r.*)
		*(.rodata1)
		. = ALIGN(8);
		_erodata = .;
	} > flash

	.data :
	{
		. = ALIGN(8);
		_fdata = .;
		*(.data .data.* .gnu.linkonce.d.*)
		*(.data1)
		_gp = ALIGN(16);
		*(.sdata .sdata.* .gnu.linkonce.s.*)
		. = ALIGN(8);
		_edata = .;
	} > data AT > flash

	.bss :
	{
		. = ALIGN(8);
		_fbss = .;
		*(.dynsbss)
		*(.sbss .sbss.* .gnu.linkonce.sb.*)
		*(.scommon)
		*(.dynbss)
		*(.bss .bss.* .gnu.linkonce.b.*S)
		*(COMMON)
		. = ALIGN(8);
		_ebss = .;
		_end = .;
	} > data AT > flash

	.mprjram :
	{
		. = ALIGN(8);
		_fsram = .;
		 *libgcc.a:*(.text .text.*)

	} > mm AT > flash
	
	/*
	.gcc :
	{
		. = ALIGN(8);
		_fsram = .;
		*libgcc.a:*(.text .text.*)

	} > gcc AT > flash
	*/
}

PROVIDE(_fstack = ORIGIN(dff2) + LENGTH(dff2));

PROVIDE(_fdata_rom = LOADADDR(.data));
PROVIDE(_edata_rom = LOADADDR(.data) + SIZEOF(.data));

PROVIDE(_esram = ORIGIN(mm) + SIZEOF(.mprjram));
PROVIDE(_esram_rom = LOADADDR(.mprjram));
/*
PROVIDE(_esram = ORIGIN(gcc) + SIZEOF(.gcc));
PROVIDE(_esram_rom = LOADADDR(.gcc));
*/
