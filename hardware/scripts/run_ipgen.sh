#! /usr/bin/env sh

#Clean old data
rm -f ip_gen.qsf
rm -f ip_gen.qpf
rm -f ip_gen.qsys
rm -rf ip_gen
rm -rf qdb
rm -rf ip
rm -rf generated_files

#generate the ip_gen.qsys
qsys-script --script=ip_gen.tcl
#generate HDL file
qsys-generate ip_gen.qsys --synthesis=VERILOG

#Generate Ethernet
rm -rf ethernet
mkdir ethernet
cp eth.tcl ethernet/
cd ethernet
qsys-script --script=eth.tcl
#generate example design
qsys-generate ip_gen_alt_ehipc2_0.ip -example-design
cd ip_gen_alt_ehipc2_0_example_design/alt_ehipc2_0_example_design/hardware_test_design/common/
qsys-generate reset_ip.ip --synthesis=VERILOG
qsys-generate alt_ehipc2_jtag_avalon.ip --synthesis=VERILOG
qsys-generate alt_ehipc2_sys_pll.ip --synthesis=VERILOG
qsys-generate probe8.ip --synthesis=VERILOG
qsys-generate reset_ip.ip --synthesis=VERILOG
cd ../../../../../


##Generate PCIe
rm -rf pcie
mkdir pcie
cp pcie_example_design.tcl pcie/
cd pcie
qsys-script --script=pcie_example_design.tcl
qsys-generate pcie_example_design.qsys --synthesis=VERILOG
cd ..
#Replace Generic_component
cp src/generic_component_0.v ./pcie/pcie_example_design/generic_component_0/synth/

#manipulate the IP files
./manipulate.py

