#!/bin/bash
clear

if [ "$1" = "-p" ]
  then
    iverilog testbenchrr3x3_par.v
elif [ "$1" = "-a" ]
  then
      iverilog testbench_async.v
else 
iverilog testbenchrr3x3.v
fi



./a.out > stats.txt 
perl flit_stats.pl stats.txt 
