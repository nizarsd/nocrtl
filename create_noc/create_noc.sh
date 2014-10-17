#!/bin/bash

clear

perl create_topology.pl > network.arc && perl create_connections.pl network.arc > connections.v
