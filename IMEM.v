module IMEM (
    input [31:0] PC_Out,
    output [31:0] instruction
);
    reg [31:0] imem [0:255]; 
    integer k;

    // Khối initial chạy 1 lần duy nhất khi cấu hình FPGA
    initial begin
        // 1. Khởi tạo toàn bộ bộ nhớ bằng 0 (để tránh rác dữ liệu)
        for (k = 0; k < 256; k = k + 1) begin 
            imem[k] = 32'b0;  
        end
        
        // 2. Gán cứng chương trình của bạn vào các dòng đầu tiên
        imem[0] = 32'b00000000000000000000000000000000;        // nop
        imem[1] = 32'b0100000_00011_01000_000_00101_0110011;   // sub x5, x8, x3
        imem[2] = 32'b000000000010_10101_000_10110_0010011;    // addi x22, x21, 2
        imem[3] = 32'b000000001111_00010_010_01000_0000011;    // lw x8, 15(x2)
        imem[4] = 32'b0000000_01110_00110_010_01100_0100011;   // sw x14, 12(x6)   
        imem[5] = 32'b0_000000_01001_01001_000_0110_0_1100011; // beq x9, x9, 12
    end 

    // Đọc lệnh (Bỏ qua 2 bit cuối của PC vì mỗi word cách nhau 4 byte)
    assign instruction = imem[PC_Out[31:2]];

endmodule