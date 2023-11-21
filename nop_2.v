//no operation (audio through)
module nop_2 (
    input                MCLK,    // 12.288MHz
    input                RESET,

    //Data and Sync Signal(Input)
    input       [23:0]   DATA_LEFT_IN,     
    input       [23:0]   DATA_RIGHT_IN,
    input                SAMPLING_POINT_LEFT_IN,
    input                SAMPLING_POINT_RIGHT_IN,

    input	[0:0]	BTN,

    //Data and Sync Signal(Output)
    output  reg [23:0]   DATA_LEFT_OUT,
    output  reg [23:0]   DATA_RIGHT_OUT,
    output  reg          SAMPLING_POINT_LEFT_OUT,
    output  reg          SAMPLING_POINT_RIGHT_OUT
);

//Net Declaration
//wire              xxx_enable; // enable signal
wire                clk = MCLK;


//Register Declaration
reg   [7:0]         cnt256;         // 256 counter
//reg   [0:0]         BTN;            // botton
reg   [23:0]        data_reg_L;     // temporary storage
reg   [23:0]        data_reg_R;     // temporary storage


//Parameter Declaration 
//localparam        MAX = 10'dXXXX  // something max value

//256 counter
always @( posedge clk ) begin
    if ( RESET )
        cnt256 <= 8'h0;
    else
        cnt256 <= cnt256 + 8'h1;
end

//Input -> Register
always @( posedge clk ) begin
    if(SAMPLING_POINT_LEFT_IN)
        data_reg_L <= DATA_LEFT_IN;
    if(SAMPLING_POINT_RIGHT_IN)
        data_reg_R <= DATA_RIGHT_IN;
end

//Register -> Output
always @( posedge clk ) begin
    if(cnt256 == 8'hff && BTN) begin
        DATA_LEFT_OUT <= data_reg_L;
        SAMPLING_POINT_LEFT_OUT <= 1'b1;
    end
    else
        SAMPLING_POINT_LEFT_OUT <= 1'b0;    
    if(cnt256 == 8'h7f) begin
        DATA_RIGHT_OUT <= data_reg_R;
        SAMPLING_POINT_RIGHT_OUT <= 1'b1;
    end
    else
        SAMPLING_POINT_RIGHT_OUT <= 1'b0; 
end



endmodule
