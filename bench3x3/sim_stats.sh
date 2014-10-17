#!/bin/bash
clear

if [ "$1" = "-p" ]
then
    iverilog testbenchrr3x3_par.v
else
    iverilog testbenchrr3x3.v
fi



./a.out > stats.txt 
perl flit_stats.pl stats.txt 
