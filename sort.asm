.data
	numbers:
		.space 20	#5个数字，每个数字占用4个字节
	space_sig:
		.asciiz " "
	input_hint:
		.asciiz "Please input 5 numbers one by one, press enter to input next:\n"
	finish_hint:
		.asciiz "\nAfter sort,the result is: "
.text
main:
	la $t1,numbers	   #t1寄存器存储数字数组的首地址
	add $t3,$zero,$t1	  #t3寄存器存储的数字指向当前地址，一开始指向的是首地址
	
	addi $t4,$zero,0   #t4寄存器位计数器，初始值为0
	la $a0,input_hint
	li $v0,4
	syscall		#系统调用，输出提示语句
	
	inputNumbers:
		li $v0,5
		syscall		#系统调用，输入一个数字
		sw $v0,0($t3)
		addi $t3,$t3,4 	  #地址+4，存储下一个数字
		addi $t4,$t4,1	  #计数器加一，代表已经存好的数字个数
		slti $s1,$t4,5	  #当t4小于5，s1为1，否则为0
		bnez $s1,inputNumbers 		#一旦t4>=5，跳出循环，否则继续输入数字	
		la $a0,finish_hint
		li $v0,4
		syscall		#系统调用，输出提示语句

		addi $t5,$zero,0	#寄存器t5为i，初始值为0
	sort_loop:
		slti $s3,$t5,5		#当i小于5，s3为1，否则为0
		beqz $s3,out_sort	#当i>=5，跳出外层循环
		subi $t6,$t5,1	#寄存器t6为j，初始值为i-1
	inner_loop:
		slti $s2,$t6,0 		#当j小于0，s2为1，否则为0
		bnez $s2,out_inner	#当j小于0，跳出内层循环
	
		sll $t3,$t6,2	
		add $t3,$t3,$t1	 	#使指针指向j*4的位置
		lw $t7,0($t3)
		lw $t8,4($t3)
		ble $t7,$t8,exchange_out	#当[j]<=[j+1],跳过交换步骤
		sw $t7,4($t3)
		sw $t8,0($t3)
	exchange_out:
		subi $t6,$t6,1		#j--
		j inner_loop
	out_inner:
		addi $t5,$t5,1		#i++
		j sort_loop
	
	out_sort:

		addi $t3,$t1,0
		addi $t4,$zero,0
	print_numbers:
		lw $a0,0($t3)
		li $v0,1
		syscall		#系统调用，打印一个int数据
		
		la $a0,space_sig
		li $v0,4
		syscall		#系统调用，打印符号
		
		addi $t3,$t3,4
		addi $t4,$t4,1	#计数器加一，代表已经打印的数字个数
		slti $s1,$t4,5	#当t4小于5，s1为1，否则为0
		bnez $s1,print_numbers	#一旦t4>=5，跳出循环，否则继续输入数字
	exit:
		li $v0,10
		syscall		#系统调用，退出程序
