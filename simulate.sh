#!/bin/bash

clear

perl create_topology.pl > network4x4.arc && perl create_connections.pl network4x4.arc > connections.v && iverilog testbench.v && ./a.out
