#!/bin/bash

#clear

if [ "$1" = "-bl" ] # Baseline (fixed priority and all ports are serial)
then
    iverilog testbench4x4.v
elif [ "$1" = "-clean" ]
then
      find ./ -name '*~' | xargs rm 
      find ./ -name '*.out' | xargs rm 
      find ./ -name '*.vcd' | xargs rm 
      find ./ -name 'stats.txt' | xargs rm 

elif [ "$1" = "-rr" ] # Round-robin arbitration
then
    iverilog testbench4x4_rr.v
fi 

if [ "$1" != "-clean" ]
then
	./a.out > stats.txt 
	perl flit_stats.pl stats.txt 
fi

