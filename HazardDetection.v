module HazardDetectionUnit (
    input [4:0] rs1_ID, rs2_ID, rd_EX, rd_MEM,
    input MemRead_EX, RegWrite_EX, RegWrite_MEM,
	 input branch_taken_ID, Branch_ID, Jump_ID,
    output reg stall, flush_ID, flush_EX
);
    always @(*) begin
			// Mặc định không stall, không flush
        stall = 1'b0;
        flush_ID = 1'b0;
        flush_EX = 1'b0;
		  
        // Load-use hazard
        if (MemRead_EX && ((rd_EX == rs1_ID) || (rd_EX == rs2_ID)) && (rd_EX != 0)) begin
            stall = 1'b1;
            flush_ID = 1'b0;
            flush_EX = 1'b1;
        end
		  
		  // Branch Data Hazard - Dữ liệu đang ở tầng EX (MỚI)
        else if (Branch_ID && RegWrite_EX && (rd_EX != 0) && ((rd_EX == rs1_ID) || (rd_EX == rs2_ID))) begin
            stall = 1'b1;     // Phải đợi lệnh ở EX tính xong
            flush_EX = 1'b1;  // Chèn NOP xuống EX
			end
			
			// Branch Data Hazard - Dữ liệu đang ở tầng MEM (MỚI)
        else if (Branch_ID && RegWrite_MEM && (rd_MEM != 0) && ((rd_MEM == rs1_ID) || (rd_MEM == rs2_ID))) begin
            stall = 1'b1;     // Phải đợi lệnh ở MEM ghi xong
            flush_EX = 1'b1;
			end
			
        // Control hazard (branch/jump taken)
        else if ((Branch_ID && branch_taken_ID) || Jump_ID) begin
            stall = 1'b0;
            flush_ID = 1'b1;
            flush_EX = 1'b1;
        end
        else begin
            stall = 1'b0;
            flush_ID = 1'b0;
            flush_EX = 1'b0;
        end
    end
endmodule
