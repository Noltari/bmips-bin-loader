OUTPUT_ARCH(mips)
SECTIONS {
	.data.bin : {
		_bin_data_start = .;
		*(.data)
		_bin_data_end = .;
	}
}
