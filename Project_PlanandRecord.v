/******2016/7/25 AM 10:36**************
A.core
B.memory system
C.interconnection network

A-1 reg1 of PC should be moved to reg2 of branch predicter, both reg1 and reg2 save PC here to obey cycle behavior.
A-2 submodule net link, I think it should be maintained in a easy way, good style naming.
A-3 optimize the ALU unit to implement multiple ALU ops via an addr.
A-4 same as A-1, I should move reg of pipeline to input register of SRAM blocks, such as INST cache SRAM, and DATA cache SRAM.
A-5 I should  implement regfile with a style: register input & non_reg for output.

B-1 rethink the cpusidecache ctrler and memsidecache ctrler, refer to hardware design pattern(HDP).
B-2 since we implement inst cache with sram, we need to rethink the microarchitecture of them.
B-3 check out if there is any deadlock or livelock inside memory system, refer to HDP.

C-1 we should consider multiple clock domain to improve performance, refer to some books.
C-2 how should I implement a deadlock free interconnecton network, rethink the algorithm, refer to computer network.

I should add core and memory document to project introduction.
******************************************/
