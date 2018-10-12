.data
	numbers:
		.space 20	#5�����֣�ÿ������ռ��4���ֽ�
	space_sig:
		.asciiz " "
	input_hint:
		.asciiz "Please input 5 numbers one by one, press enter to input next:\n"
	finish_hint:
		.asciiz "\nAfter sort,the result is: "
.text
main:
	la $t1,numbers	   #t1�Ĵ����洢����������׵�ַ
	add $t3,$zero,$t1	  #t3�Ĵ����洢������ָ��ǰ��ַ��һ��ʼָ������׵�ַ
	
	addi $t4,$zero,0   #t4�Ĵ���λ����������ʼֵΪ0
	la $a0,input_hint
	li $v0,4
	syscall		#ϵͳ���ã������ʾ���
	
	inputNumbers:
		li $v0,5
		syscall		#ϵͳ���ã�����һ������
		sw $v0,0($t3)
		addi $t3,$t3,4 	  #��ַ+4���洢��һ������
		addi $t4,$t4,1	  #��������һ�������Ѿ���õ����ָ���
		slti $s1,$t4,5	  #��t4С��5��s1Ϊ1������Ϊ0
		bnez $s1,inputNumbers 		#һ��t4>=5������ѭ�������������������	
		la $a0,finish_hint
		li $v0,4
		syscall		#ϵͳ���ã������ʾ���

		addi $t5,$zero,0	#�Ĵ���t5Ϊi����ʼֵΪ0
	sort_loop:
		slti $s3,$t5,5		#��iС��5��s3Ϊ1������Ϊ0
		beqz $s3,out_sort	#��i>=5���������ѭ��
		subi $t6,$t5,1	#�Ĵ���t6Ϊj����ʼֵΪi-1
	inner_loop:
		slti $s2,$t6,0 		#��jС��0��s2Ϊ1������Ϊ0
		bnez $s2,out_inner	#��jС��0�������ڲ�ѭ��
	
		sll $t3,$t6,2	
		add $t3,$t3,$t1	 	#ʹָ��ָ��j*4��λ��
		lw $t7,0($t3)
		lw $t8,4($t3)
		ble $t7,$t8,exchange_out	#��[j]<=[j+1],������������
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
		syscall		#ϵͳ���ã���ӡһ��int����
		
		la $a0,space_sig
		li $v0,4
		syscall		#ϵͳ���ã���ӡ����
		
		addi $t3,$t3,4
		addi $t4,$t4,1	#��������һ�������Ѿ���ӡ�����ָ���
		slti $s1,$t4,5	#��t4С��5��s1Ϊ1������Ϊ0
		bnez $s1,print_numbers	#һ��t4>=5������ѭ�������������������
	exit:
		li $v0,10
		syscall		#ϵͳ���ã��˳�����
