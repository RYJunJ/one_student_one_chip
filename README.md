# One Student One Chip 一生一芯
## About the Project
Launched by Professor Yungang Bao from Institute of Computing Technology, Chinese Academy of Sciences (ICT, CAS)

This open project instructs students to build their own RISC-V system, including application, OS, processor and SoC. The project will also guide students to conduct physical design for the RISC-V chips and then tape out.

[Official Website: https://ysyx.oscc.cc/](https://ysyx.oscc.cc/)

## What I learnt from the Project
### How to debug large-scale projects
#### Use the "Differential Testing" idea to target the abstraction layer where the bug is located
In large projects, because there are too many abstraction layers, when faced with a bug, it is difficult to determine which abstraction layer the bug actually arises from. 
> For example, in a computer system, hardware bugs can manifest in both the operating system and user software.  

Therefore, only by first locating the abstraction layer where the bug is located, we can proceed to the next step of more detailed debugging.  
**Differential Testing** is a concept I was first introduced to in algorithmic competitions.  
In an algorithmic competition, **Differential Testing** is to run a potentially buggy version of what we are implementing and an inefficient, but definitely correct version in sequence, and compare the results of the two runs, and when we encounter a difference in the results of the two runs, it means that we have found a bug.  
**Differential Testing** is also used in this project, where I have added different Differential Testing support for different abstraction layers: 
 - Navy Library (APP runtime library): Replace Navy library with Linux native library, to compare whether the APP can run correctly under the support of Navy library, so as to determine whether the bug occurs in this abstraction layer.
 - OS & OS libraries: Replace NanOS-lite, libos, Newlib with Linux system calls and glibc to compare and test if the bug occurs in OS layer.
 - RISC-V CPU: use `Spike`, the RISC-V ISA Simulator, to comparatively test our CPU implementation to determine if the bug is in the hardware layer.

#### Debugging is all about state tracking
After locating the abstraction layer where the bug is located, we need to debug at the specific abstraction layer, but in most abstraction layers, there is no mature debugger like `gdb`.   So, we need to understand the essence of debugging, and then design our own debuggers for different layers.  
I think debugging is all about tracking state, just like the finite-state automaton.  
At different layers, the specific references to "state" will vary:
| Abstraction layer | state |
| ----- | --- |
| File System | Names, parameters and return values for each open and close of the file |
| System Call | Name, parameters and return value of each system call |
| Algorithm | Values of key variables |
| RISC-V CPU | 32 general-purpose register values |  


So, when debugging the CPU, we designed `SDB` (short for Simple DeBugger) to print the values of 32 general purpose registers.  
When debugging system calls, we also designed our own debugger: `strace`, which is used to print all system call logs.  
And when debugging algorithms, the `gdb` is often used, also with the purpose of tracking changes in a few key variables.
### How to efficiently develop large projects
#### Program tools to optimize development efficiency
Solve development pain points with programming tools.  
In the One Student One Chip project, I have Implemented a variety of tools to optimize development efficiency:
 - Implemented `sdb` (Simple DeBugger) to allow me to step into every instructions of the RISC-V ISA, as well as print the values of arbitrary registers and memory locations.
 - Implemented `mtrace` to record each memory access instruction, and the address to be accessed.
 - Implemented `ftrace` to log each function call and return in the assembly program.
 - Implemented `dtrace` to log the access of devices.
 - Added support for Differential Testing, using `Spike` as the correct implementation for the RV64IM CPU to compare against my CPU implementation.
Without the support of these tools, my development cycle would be significantly extended.

## Presentation
### Batch Processing Support
#### Switching between applications is supported using the terminal
![Terminal Support](https://github.com/RYJunJ/one_student_one_chip/blob/main/img-folder/01.png)
### Type `/bin/bird` to launch Flappy Bird
![terminal Flappy Bird](https://github.com/RYJunJ/one_student_one_chip/blob/main/img-folder/02.png)
![Flappy Bird](https://github.com/RYJunJ/one_student_one_chip/blob/main/img-folder/03.png)
### Exit and Switch to another APP
Type `q` to EXIT any APP.
Type `/bin/nslider` to launch the slider APP. **Batch Processing Support**
![Nslider1](https://github.com/RYJunJ/one_student_one_chip/blob/main/img-folder/04.png)
![Nslider2](https://github.com/RYJunJ/one_student_one_chip/blob/main/img-folder/05.png)
### Switch to PAL 仙剑奇侠传
![PAL1](https://github.com/RYJunJ/one_student_one_chip/blob/main/img-folder/06.png)
![PAL2](https://github.com/RYJunJ/one_student_one_chip/blob/main/img-folder/07.png)
![PAL3](https://github.com/RYJunJ/one_student_one_chip/blob/main/img-folder/08.png)


