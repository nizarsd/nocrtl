# horizontal channels between routers 0 and 1
rr,0,1,1,3
rr,1,0,3,1
# horizontal channels between routers 1 and 2
rr,1,2,1,3
rr,2,1,3,1
# horizontal channels between routers 3 and 4
rr,3,4,1,3
rr,4,3,3,1
# horizontal channels between routers 4 and 5
rr,4,5,1,3
rr,5,4,3,1
# horizontal channels between routers 6 and 7
rr,6,7,1,3
rr,7,6,3,1
# horizontal channels between routers 7 and 8
rr,7,8,1,3
rr,8,7,3,1
# vertical channels between routers 0 and 3
rr,0,3,2,0
rr,3,0,0,2
# vertical channels between routers 1 and 4
rr,1,4,2,0
rr,4,1,0,2
# vertical channels between routers 2 and 5
rr,2,5,2,0
rr,5,2,0,2
# vertical channels between routers 3 and 6
rr,3,6,2,0
rr,6,3,0,2
# vertical channels between routers 4 and 7
rr,4,7,2,0
rr,7,4,0,2
# vertical channels between routers 5 and 8
rr,5,8,2,0
rr,8,5,0,2
# north terminator
tx,0,0
rx,0,0
# south terminator
tx,6,2
rx,6,2
# north terminator
tx,1,0
rx,1,0
# south terminator
tx,7,2
rx,7,2
# north terminator
tx,2,0
rx,2,0
# south terminator
tx,8,2
rx,8,2
# west terminator
tx,0,3
rx,0,3
# east terminator
tx,2,1
rx,2,1
# west terminator
tx,3,3
rx,3,3
# east terminator
tx,5,1
rx,5,1
# west terminator
tx,6,3
rx,6,3
# east terminator
tx,8,1
rx,8,1
#source
sr,0,0,4
#sink
rs,0,4,0
#source
sr,1,1,4
#sink
rs,1,4,1
#source
sr,2,2,4
#sink
rs,2,4,2
#source
sr,3,3,4
#sink
rs,3,4,3
#source
sr,4,4,4
#sink
rs,4,4,4
#source
sr,5,5,4
#sink
rs,5,4,5
#source
sr,6,6,4
#sink
rs,6,4,6
#source
sr,7,7,4
#sink
rs,7,4,7
#source
sr,8,8,4
#sink
rs,8,4,8
