# One Student One Chip 一生一芯
## About the Project
Launched by Professor Yungang Bao from Institute of Computing Technology, Chinese Academy of Sciences (ICT, CAS)

This open custom project instructs students to build their own RISC-V system, including application, OS, processor and SoC. The project will also guide students to conduct physical design for the RISC-V chips and then tape out.

[Official Website: https://ysyx.oscc.cc/](https://ysyx.oscc.cc/)

## What I learnt from the Project
### 如何调试大型工程
#### 使用“对拍”思想锁定BUG所在的抽象层
对拍是我在算法竞赛中接触到的概念，核心思想是将 有可能有BUG的实现 和 一定正确的实现 做比较。  
在算法竞赛中，对拍是：将一个我们正在实现的，可能有潜在BUG的版本 与 一个低效，但是一定正确的版本依次运行，比较两者运行结果的不同，当遇到有差异的运行结果时，便意味着我们找到了BUG。  
在一生一芯项目中也有对拍思想的应用，我们为不同的抽象层添加了不同的对拍的支持：  
 - Navy中的native: 用Navy中的库替代Linux native的库, 测试游戏是否能在Navy库的支撑下正确运行.

#### DEBUG的本质是状态追踪
## Presentation
### Batch Processing Support
#### Switching between applications is supported using the terminal
![Terminal Support](https://github.com/RYJunJ/one_student_one_chip/blob/main/img-folder/01.png)
### Type '/bin/bird' to launch Flappy Bird
![terminal Flappy Bird](https://github.com/RYJunJ/one_student_one_chip/blob/main/img-folder/02.png)
![Flappy Bird](https://github.com/RYJunJ/one_student_one_chip/blob/main/img-folder/03.png)
### Exit and Switch to another APP
Type 'q' to EXIT any APP.
Type '/bin/nslider' to launch the slider APP. **Batch Processing Support**
![Nslider1](https://github.com/RYJunJ/one_student_one_chip/blob/main/img-folder/04.png)
![Nslider2](https://github.com/RYJunJ/one_student_one_chip/blob/main/img-folder/05.png)
### Switch to PAL 仙剑奇侠传
![PAL1](https://github.com/RYJunJ/one_student_one_chip/blob/main/img-folder/06.png)
![PAL2](https://github.com/RYJunJ/one_student_one_chip/blob/main/img-folder/07.png)
![PAL3](https://github.com/RYJunJ/one_student_one_chip/blob/main/img-folder/08.png)


