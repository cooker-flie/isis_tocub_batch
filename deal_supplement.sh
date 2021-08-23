#!/bin/bash
# eg:deal_supplement [path1] [path2]
# Batch process .IMG into .cub,[path1] the file that saves the address ,[path2] output floder
# 增加了多线程及同名文件检查

echo "Start Time:"`  date "+ %y-%m-%d %H:%M:%S"` #start time
list=$(cat $1)		

# define some suffix
convertsuffix=.cub
calsuffix=_cal.cub


#--------并发队列----------
[ -e /tmp/fd1 ] || mkfifo /tmp/fd1  #创建有名管道
exec 3<>/tmp/fd1                    #创建文件描述符，以可读（<）可写（>）的方式关联管道文件，这时候文件描述符3就有了有名管道文件的所有特性
rm -rf /tmp/fd1                     #关联后的文件描述符拥有管道文件的所有特性,所以这时候管道文件可以删除，我们留下文件描述符来用就可以了
for ((i=1;i<=10;i++))
do
        echo >&3                   #&3代表引用文件描述符3，这条命令代表往管道里面放入了一个"令牌"
done


# -- get the number of total files -----
sum=0
for filename in $list
do
    let sum=sum+1
done
echo Processing file number:  $sum


# -- main loop
num=1
for filename in $list
do
read -u3  
{   
    echo $filename                               # get the original file name
    let num=num+1
    file1=${filename%.*}                       # get the file name without suffix
    file2=${file1##*/}                      # get the file name without suffix and prefix

    convert="$2/$file2$convertsuffix"    # get the file name with convert suffix
    naccal="$2/$file2$calsuffix" # get the file name with calibration suffix       
    

    if [ ! -e $2/$file2$convertsuffix ] 
    then	
    	lronac2isis from=$filename to=$convert
    	spiceinit from=$convert #web=yes
    	lronaccal from= $convert to=$naccal
    	lronacecho from=$naccal to=$convert   
    	rm $naccal 
    	
    	echo “====================================”
    fi
    echo “================= ${file1##*/} done ==================”
    echo >&3
}&
done
wait

echo "End Time:"`  date "+ %y-%m-%d %H:%M:%S"` #start time

exec 3<&-                       #关闭文件描述符的读
exec 3>&-                       #关闭文件描述符的写

