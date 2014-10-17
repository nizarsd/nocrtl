#!/bin/bash

clear

if [ "$1" = "-b" ]
then
    iverilog testbench4x4.v
else
    iverilog testbench4x4_rr.v
fi

./a.out > stats.txt 
perl flit_stats.pl stats.txt 
