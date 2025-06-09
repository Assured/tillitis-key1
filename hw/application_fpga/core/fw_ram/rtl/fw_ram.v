//======================================================================
//
// fw_ram.v
// --------
// A 512 x 32 RAM (2048 bytes) for use by the FW. The memory has
// support for mode based access control.
//
// Author: Joachim Strombergson
// Copyright (C) 2022 - Tillitis AB
// SPDX-License-Identifier: GPL-2.0-only
//
//======================================================================

`default_nettype none

module fw_ram (
    input wire clk,
    input wire reset_n,

    input wire app_mode,

    input  wire          cs,
    input  wire [ 3 : 0] we,
    input  wire [ 9 : 0] address,
    input  wire [31 : 0] write_data,
    output wire [31 : 0] read_data,
    output wire          ready
);

  // 2048 * 4 = 8 kByte
  localparam NUM_MEM_WORDS = 2048;


  //----------------------------------------------------------------
  // Registers and wires.
  //----------------------------------------------------------------
  reg           ready_reg;
  wire          app_mode_cs;

  reg [31 : 0] ram_mem[0 : (NUM_MEM_WORDS - 1)];


  //----------------------------------------------------------------
  // Concurrent assignment of ports.
  //----------------------------------------------------------------
  assign read_data   = ram_mem[address];
  assign ready       = ready_reg;
  assign app_mode_cs = cs && ~app_mode;

  //----------------------------------------------------------------
  // reg_update
  //----------------------------------------------------------------
  always @(posedge clk) begin : reg_update
    if (!reset_n) begin
      ready_reg <= 1'h0;
    end
    else begin
      ready_reg <= cs;
    end

      if (cs & we) begin
	ram_mem[address] <= write_data;
      end
  end

endmodule  // fw_ram

//======================================================================
// EOF fw_ram.v
//======================================================================
