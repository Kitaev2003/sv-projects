#!/bin/bash

mkdir -p build

yosys -D LEDS_NR=0 -p "read_verilog svLDL.v; synth_gowin -json build/svLDL.json"

nextpnr-himbaechel --json build/svLDL.json --write build/DumpsvLDL.json --device GW1NR-LV9QN88PC6/I5 --vopt family=GW1N-9C --vopt cst=svLDL.cst

gowin_pack -d GW1N-9C -o build/svLDL.fs build/DumpsvLDL.json

sudo openFPGALoader -b tangnano9k --detect build/svLDL.fs
sudo openFPGALoader -b tangnano9k build/svLDL.fs
