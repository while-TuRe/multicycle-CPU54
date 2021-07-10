# multicycle-CPU54
同济大学计算机组成原理课程课设，多周期实现的54条MIPS指令CPU
详情请见：https://blog.csdn.net/a_vegetable/article/details/118419345
ps:jalr指令为过oj采用先读再写，实际操作先写在读更为合理且能节省一个周期时间。CPU54中的各模块和always@应分为两个文件更合理，always@模块为Controller
