//======================================================================
//
// ram.v
// -----
// Simple clocked RAM created by a simple array.
// Should map to EBRs in the FPGA.
//======================================================================

`default_nettype none

module ram (
    input wire           clk,
    input wire           reset_n,

    input wire [14 : 0] ram_addr_rand,
    input wire [31 : 0] ram_data_rand,

    input  wire          cs,
    input  wire [ 3 : 0] we,
    input  wire [15 : 0] address,
    input  wire [31 : 0] write_data,
    output wire [31 : 0] read_data,
    output wire          ready
);


  //----------------------------------------------------------------
  // Local parameters to define mem size
  //----------------------------------------------------------------
  // 12288 * 4 = 48 kByte
  localparam NUM_MEM_WORDS = 32768;


  //----------------------------------------------------------------
  // Registers and wires.
  //----------------------------------------------------------------
  reg          ready_reg;

  reg [31 : 0] ram_mem[0 : (NUM_MEM_WORDS - 1)];


  //----------------------------------------------------------------
  // Concurrent assignment of ports.
  //----------------------------------------------------------------
  assign read_data = ram_mem[address[14 : 0]];
  assign ready     = ready_reg;


  //----------------------------------------------------------------
  // reg_update
  //
  // Posedge triggered with synchronous, active low reset.
  // This simply creates a one cycle access latency to match
  // the latency of the spram blocks.
  //----------------------------------------------------------------
  always @(posedge clk) begin : reg_update
    if (!reset_n) begin
      ready_reg <= 1'h0;
    end
    else begin
      ready_reg <= cs;

      if (cs & we) begin
	ram_mem[address[14 : 0]] <= write_data;
      end
    end
  end

endmodule  // ram

//======================================================================
// EOF ram.v
//======================================================================
