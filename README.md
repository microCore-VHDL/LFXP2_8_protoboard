# LFXP2_8_protoboard
microCore implemented on a very simple prototyping board with the LFXP2_8 FPGA

Its RS232 UART is used as a umbilical link connecting to the host system that runs the cross-compiler and interactive debugger.<BR>
Its row of 8 LEDs is used for signalling.<BR>
A fixed 250 usec interrupt can be used for interrupt performance assessment. See ./software/load.fs<BR>

![LFXP2_Platine_git](https://user-images.githubusercontent.com/77505995/105735374-e7b06500-5f33-11eb-8d16-3309039d84a7.jpg)
