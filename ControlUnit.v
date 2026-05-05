module ControlUnit (
    input [6:0] op,
    output reg RegWrite, ALUSrc, ALUSrc_pc, MemWrite, MemRead, Branch, Jump,
    output reg [1:0] ALUOp, ResultSrc,
    output reg [2:0] imm_sel
);

    always @(*) begin
        // Giá trị mặc định (tránh sinh ra Latch trên FPGA)
        RegWrite  = 1'b0;
        ALUSrc    = 1'b0;
        ALUSrc_pc = 1'b0;
        MemWrite  = 1'b0;
        MemRead   = 1'b0;
        Branch    = 1'b0;
        Jump      = 1'b0;
        ALUOp     = 2'b00;
        ResultSrc = 2'b00;
        imm_sel   = 3'b000;

        case(op)
            7'b0110011: begin // R-type (ADD, SUB, AND, OR...)
                RegWrite = 1'b1;
                ALUSrc   = 1'b0; // B lấy từ thanh ghi rs2
                ALUOp    = 2'b10;
            end

            7'b0010011: begin // I-type (ADDI, ORI, SLTI...)
                RegWrite = 1'b1;
                ALUSrc   = 1'b1; // B lấy từ Immediate
                ALUOp    = 2'b10;
                imm_sel  = 3'b001;
            end

            7'b0000011: begin // I-type Load (LW)
                RegWrite  = 1'b1;
                ALUSrc    = 1'b1; // Tính địa chỉ = rs1 + imm
                MemRead   = 1'b1;
                ResultSrc = 2'b01; // Kết quả lấy từ Data Memory
                imm_sel   = 3'b001;
            end

            7'b0100011: begin // S-type Store (SW)
                ALUSrc   = 1'b1; // Tính địa chỉ = rs1 + imm
                MemWrite = 1'b1;
                imm_sel  = 3'b010;
            end

            7'b1100011: begin // B-type Branch (BEQ, BNE...)
                // Địa chỉ nhánh đã được tính ở tầng ID. 
                // Ở đây chỉ cần báo cho Hazard Unit biết đây là lệnh Branch
                Branch  = 1'b1;
                imm_sel = 3'b011;
            end

            7'b1101111: begin // J-type JAL
                RegWrite  = 1'b1;
                Jump      = 1'b1;
                ResultSrc = 2'b10; // Lưu PC+4 vào rd
                imm_sel   = 3'b101;
            end

            7'b1100111: begin // I-type JALR
                RegWrite  = 1'b1;
                Jump      = 1'b1;
                ALUSrc    = 1'b1;  // Tính địa chỉ nhảy rs1 + imm ở ALU
                ResultSrc = 2'b10; // Lưu PC+4 vào rd
                imm_sel   = 3'b001;
            end

            7'b0110111: begin // U-type LUI
                RegWrite = 1'b1;
                ALUSrc   = 1'b1; // Đầu vào B là imm
                // Lưu ý: ALUControl cần hiểu ALUOp=00 là phép cộng.
                // Ở Top module, nếu input A của LUI không được đưa vào 0, LUI sẽ sai.
                // Tốt nhất ở MUX cấp ALU A, bạn nên có chế độ chọn 0 cho LUI.
                imm_sel  = 3'b100;
            end

            7'b0010111: begin // U-type AUIPC
                RegWrite  = 1'b1;
                ALUSrc    = 1'b1; // Đầu vào B là imm
                ALUSrc_pc = 1'b1; // MỚI: Chỉ AUIPC mới dùng PC ở đầu vào A của ALU
                imm_sel   = 3'b100;
            end

            default: begin
                // Giữ nguyên giá trị mặc định là 0
            end
        endcase
    end
endmodule