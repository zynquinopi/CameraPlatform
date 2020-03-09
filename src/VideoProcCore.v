module VideoProcCore (
	CLK,
	RST_N,
	XCLK,
	CamHsync,
	CamVsync,
	PCLK,
  CamData,
	VgaVsync,
	VgaHsync,
	SW0,
	SW1,
   VgaDataR,
   VgaDataG,
   VgaDataB	
); 

input		CLK, RST_N;
output	XCLK;
input	CamHsync;
input CamVsync;
input PCLK;
input [7:0]CamData;
output	VgaVsync;
output	VgaHsync;
input SW0;
input SW1;
output	[7:0] VgaDataR	;
output	[7:0] VgaDataG	;
output	[7:0] VgaDataB	;

wire CamHsync_EDGE, CamVsync_EDGE;
wire [9:0] LB_WR_ADDR;
wire [15:0] LB_WR_DATA;
wire LB_WR_N;
wire [8:0] VgaLineCount;
wire [9:0] VgaPixCount;
wire [15:0] buf_RGB;
wire [8:0] CamLineCount;
wire [15:0] CamPixCount4x;
wire VgaVisible, VgaVsync, VgaHsync, VgaHsync_edge, OddFrame;
wire [7:0] buf_r, buf_g, buf_b;

assign VgaDataR = (VgaVisible == 1 && ((OddFrame == 1 && SW0 == 0) || (OddFrame == 0 && SW1 == 0)))
                    ? buf_r : 8'h00;
assign VgaDataG = (VgaVisible == 1 && ((OddFrame == 1 && SW0 == 0) || (OddFrame == 0 && SW1 == 0)))
                    ? buf_g : 8'h00;
assign VgaDataB = (VgaVisible == 1 && ((OddFrame == 1 && SW0 == 0) || (OddFrame == 0 && SW1 == 0)))
                    ? buf_b : 8'h00;

assign buf_r = {buf_RGB[15 : 11], 3'b000};
assign buf_g = {buf_RGB[10 : 5], 2'b00};
assign buf_b = {buf_RGB[4 : 0], 3'b000};

assign XCLK = CamPixCount4x[0];

	LINEIN_CTRL LINEIN_CTRL_inst(
	.CLK(CLK),
	.RST_N(RST_N),
	.LB_WR_ADDR(LB_WR_ADDR),
	.LB_WR_DATA(LB_WR_DATA),
	.LB_WR_N(LB_WR_N),
	.VgaLineCount(VgaLineCount),
	.VgaPixCount(VgaPixCount),
	.buf_RGB(buf_RGB)
);

	CAM_CTRL CAM_CTRL_inst(
	.CLK(CLK),
	.RST_N(RST_N),
	.PCLK(PCLK),
	.CamHsync(CamHsync),
	.CamVsync(CamVsync),
	.CamData(CamData),
	.LB_WR_ADDR(LB_WR_ADDR),
	.LB_WR_DATA(LB_WR_DATA),
	.LB_WR_N(LB_WR_N),
	.CamHsync_EDGE(CamHsync_EDGE),
	.CamVsync_EDGE(CamVsync_EDGE),
	.CamLineCount(CamLineCount),
	.CamPixCount4x(CamPixCount4x)
);

	VGA_CTRL VGA_CTRL_inst (
	.CLK(CLK),
	.RST_N(RST_N),
	.CamHsync_EDGE(CamHsync_EDGE),
	.CamVsync_EDGE(CamVsync_EDGE),
	.VgaLineCount(VgaLineCount),
	.VgaPixCount(VgaPixCount),
	.VgaVisible(VgaVisible),
	.VgaVsync(VgaVsync),
	.VgaHsync(VgaHsync),
	.VgaHsync_edge(VgaHsync_edge),
	.OddFrame(OddFrame)
); 
endmodule