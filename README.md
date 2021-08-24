# isis_tocub_batch
Batch .IMG flies into .cub flies using isis 


关于使用isis批处理的一些操作的汇总与代码 
使用环境：可下载ISIS的liunx版本，GADL，ASP包及处理数据的支撑包等，批处理命令代码中注释有所需的包
## 1、TXT文件-相关命令行与原始脚本的描述
批处理命令及原始脚本云可运行于Liunx shell中

## 2、.sh文件优化过的代码文件
*deal_tocub*
eg:deal_tocub [path1][path2] <br>
Batch process .IMG into .cub,[path1] the file that saves the address ,[path2] output floder <br>
传入记录处理路径的path1，将处理完的文件保存至path2


*deal_tocub_parallel.sh*
eg:deal_tocub_parallel.sh [path1][path2] <br>
Added Parallel processing function,The number of parallelisms can be adjusted by modify the code
新增并行计算功能，可通过调整代码修改并行进程数

*deal_supplement.sh*
Added existing file check <br>
新增已有文件检查功能



