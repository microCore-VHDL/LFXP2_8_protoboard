# LFXP2_8_protoboard
microCore implemented on a very simple prototyping board with the LFXP2_8 FPGA

Its RS232 UART is used as a umbilical link connecting to the host system that runs the cross-compiler and interactive debugger.
Its row of 8 LEDs is used for signalling.
A fixed 250 usec interrupt can be used for interrupt performance assessment. See ./software/load.fs
