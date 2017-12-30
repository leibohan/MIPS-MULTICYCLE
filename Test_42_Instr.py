f = open('Test_42_Instr.txt','r')
fw = open('Test_42_Instr_v.txt','w')
lis = f.readlines()
cnt = 0
for i in lis:
    num = '%d'%cnt
    ins = i[0:8]
    fw.write('	  IMem[' + num + "] = 32'h" + ins + ';\n')
    cnt = cnt+1
f.close()
fw.close()
