mkdir -p image
mkdir -p json

yosys -p "prep -top main; write_json json/main_module.json" svLDL.v
yosys -p "prep -top clk_div; write_json json/clk_div_module.json" svLDL.v
yosys -p "prep -top digits; write_json json/digits_module.json" svLDL.v
yosys -p "prep -top segment7; write_json json/segment7_module.json" svLDL.v

netlistsvg json/main_module.json -o image/main_module.svg
netlistsvg json/clk_div_module.json -o image/clk_div_module.svg
netlistsvg json/digits_module.json -o image/digits_module.svg
netlistsvg json/segment7_module.json -o image/segment7_module.svg
