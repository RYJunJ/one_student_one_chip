# One Student One Chip 一生一芯
## About the Project
Launched by Professor Yungang Bao from Institute of Computing Technology, Chinese Academy of Sciences (ICT, CAS)

This open custom project instructs students to build their own RISC-V system, including application, OS, processor and SoC. The project will also guide students to conduct physical design for the RISC-V chips and then tape out.

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
After locating the abstraction layer where the bug is located, we need to debug at the specific abstraction layer, but in most abstraction layers, there is no mature debugger like `gdb`. So, we need to understand the essence of debugging, and then design our own debuggers for different layers.  
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


### Chinese Version Below
#### 使用Differential Testing思想锁定BUG所在的抽象层
在大型项目中，由于有太多抽象层，面对一个BUG时，我们很难判断这个BUG究竟产生于哪一个抽象层。
> 比如：在计算机系统中，硬件上的BUG，在OS和用户软件上都会有体现。
 
所以，只有先定位BUG所在的抽象层，我们才能进行下一步的更细节的debug。
对拍是我在算法竞赛中接触到的概念，核心思想是将 有可能有BUG的实现 和 一定正确的实现 做比较。  
在算法竞赛中，对拍是：将一个我们正在实现的，可能有潜在BUG的版本 与 一个低效，但是一定正确的版本依次运行，比较两者运行结果的不同，当遇到有差异的运行结果时，便意味着我们找到了BUG。  
在一生一芯项目中也有对拍思想的应用，我们为不同的抽象层添加了不同的对拍的支持：  
 - Navy Library (APP需要的运行时库): 用Linux native的库代替Navy库, 以比较测试APP是否能在Navy库的支撑下正确运行，从而判断BUG是否发生在本抽象层.
 - OS & OS库：用Linux系统调用和glibc来替换NanOS-lite, libos, Newlib，以比较测试BUG是否出现在OS层
 - RISC-V CPU：用`Spike`, the RISC-V ISA Simulator，来比较测试我们的CPU实现是否有问题，从而判断BUG是否产生在硬件层

#### DEBUG的本质是状态追踪
锁定BUG所在抽象层后，我们需要在不同的抽象层去DEBUG。但是，在大多数抽象层，并不存在gdb这种成熟的DEBUG工具。所以，我们需要理解DEBUG的本质，然后自己设计DEBUG工具。  
我认为，DEBUG的本质就是在追踪状态，正如状态机模型一样。  
在不同的抽象层，这个具体“状态”的指代也有所不同：
| 抽象层 | 状态 |
| ----- | --- |
| 文件系统 | 每一次打开和关闭文件的名字，参数和返回值 |
| 系统调用 | 每一次系统调用的名字，参数和返回值 |
| 算法 | 关键变量的值 |
| CPU | 32个通用寄存器的值 |  


所以，在debug CPU时，我们设计了`SDB`(Simple DeBugger的简称)，用来打印32个通用寄存器的值。  
在调试系统调用功能时，我们也设计了自己的debugger：`strace`，用来打印所有的系统调用记录。
而在调试算法时，往往会采用最简单的`gdb`，目的也是为了跟踪少数几个关键变量的变化情况。
### 如何高效开发大型项目
#### 编写工具优化开发效率
在开发大型项目的过程中通过编写工具来解决“恼人”的地方。  
在一生一芯中，我编写了各种各样的工具来优化开发效率：
 - 编写`sdb` (Simple DeBugger)使我能单步执行`RISC-V ISA`的每一条语句，同时还能打印任意寄存器和内存位置的值
 - 编写`mtrace`，以记录每一条访存指令，以及访存地址
 - 编写`ftrace`，记录每一次汇编程序中的函数调用和返回
 - 编写`dtrace`，记录设备访问的踪迹
 - 添加`Differential Testing` 的支持，将`Spike`作为`RV64IM CPU`的正确实现，来比对我的CPU实现
如果没有这些工具的支持，我的开发周期将会大大延长

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


