/* A 3-1 Mux
 *
 * Due to having extra selections, they're assigned as follows:
 * 0 - input 0
 * 1 - input 1
 * 2 - input 2
 * 3 - input 2
 *
 * wchen329@wisc.edu
 */
module mux_3_1(output selected_val, input val_0, input val_1, input val_2, input[1:0] select);
	
	// It'd be nice to be able to use a 4-1 mux...
	assign selected_val = select == 0 ? val_0 :
			       select == 1 ? val_1 :
			       select == 2 ? val_2 :
			       select == 3 ? val_2 : 0;
endmodule