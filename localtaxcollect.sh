#!/bin/bash
file=2014-before.txt
if [ $# -gt 1 ];then
	file=$1
fi

echo "处理文件: "$file
#统计营业额
cat $file |awk '{if($4=="建筑" || $4=="装饰" ||$4=="安装" ||$4=="其他工程作业"){a=$13/0.03; y[$1$5][0]=$1;y[$1$5][1]+=$13;y[$1$5][2]+=a;y[$1$5][3]=$5;}else{a=$13/0.05; y[$1$5][0]=$1;y[$1$5][1]+=$13;y[$1$5][2]+=a;y[$1$5][3]=$5;}}END{for(w in y)print w,y[w][0],y[w][1],y[w][2],y[w][3]}' > /tmp/tempfile.txt

#统计总用户数
cat /tmp/tempfile.txt |awk '{print $2}'|sort|uniq > /tmp/zongyonghu
zongyonghunum=`cat /tmp/zongyonghu|wc -l`
echo "用户合计: "$zongyonghunum
cat /tmp/zongyonghu |tr -t '\n' ' '> /tmp/strzongyonghu

#统计个体工商个数
cat /tmp/tempfile.txt |awk '{if($2 ~/01$/ || $2 ~/M0$/ || $2 ~/M1$/ || $2 ~/M2$/ || $2 ~/M3$/ ){print $2}}'|sort |uniq > /tmp/geti
getinum=`cat /tmp/geti |wc -l`
echo "个体工商户个数 :"$getinum
cat /tmp/geti |tr -t '\n' ' '> /tmp/strgeti

#统计非个体工商个数
cat /tmp/zongyonghu |awk 'BEGIN{"cat /tmp/strgeti" | getline geti}{if(index(geti,$0)<1)print $0}'|sort |uniq > /tmp/feigeti
feigetinum=`cat /tmp/feigeti |wc -l`
echo "非个体工商户个数 :"$feigetinum
cat /tmp/feigeti |tr -t '\n' ' '> /tmp/strfeigeti

#统计>=20000个体工商个数
cat /tmp/tempfile.txt |awk 'BEGIN{"cat /tmp/strgeti" | getline geti}{if(index(geti,$2)>0 && $4 >= 20000)print $2}'|sort |uniq > /tmp/getidayu
getidayu=`cat /tmp/getidayu|wc -l`
echo "大于等于20000个体工商户个数 :"$getidayu
cat /tmp/getidayu |tr -t '\n' ' '> /tmp/strgetidayu

#统计<20000个体工商个数
cat /tmp/geti |awk 'BEGIN{"cat /tmp/strgetidayu" | getline getidayu}{if(index(getidayu,$0)<1)print $0}'|sort |uniq > /tmp/getixiaoyu
getixiaoyu=`cat /tmp/getixiaoyu|wc -l`
echo "小于20000个体工商户个数 :"$getixiaoyu
cat /tmp/getixiaoyu |tr -t '\n' ' '> /tmp/strgetixiaoyu

#统计>20000个体非工商个数
cat /tmp/tempfile.txt |awk 'BEGIN{"cat /tmp/strfeigeti" | getline feigeti}{if(index(feigeti,$2)>0 && $4 > 20000)print $2}'|sort |uniq > /tmp/feigetidayu
feigetidayu=`cat /tmp/feigetidayu|wc -l`
echo "大于等于20000非个体工商户个数 :"$feigetidayu
cat /tmp/feigetidayu |tr -t '\n' ' '> /tmp/strfeigetidayu

#统计<=20000个体工商个数
cat /tmp/feigeti |awk 'BEGIN{"cat /tmp/strfeigetidayu" | getline feigetidayu}{if(index(feigetidayu,$0)<1)print $0}'|sort |uniq > /tmp/feigetixiaoyu
feigetixiaoyu=`cat /tmp/feigetixiaoyu|wc -l`
echo "小于20000非个体工商户个数 :"$feigetixiaoyu
cat /tmp/feigetixiaoyu |tr -t '\n' ' '> /tmp/strfeigetixiaoyu

#统计大于等于20000的个体工商免税额
#cat /tmp/tempfile.txt | awk 'BEGIN{"cat /tmp/strgetidayu" | getline s}{if(index(s,$2)>0){y+=$3;print $2,$3}}END{printf("大于等于20000的个体免税 %f\n",y)}' > /tmp/egetidayu
cat /tmp/tempfile.txt | awk 'BEGIN{"cat /tmp/strgetidayu" | getline s}{if(index(s,$2)>0){y+=$3}}END{printf("大于等于20000的个体免税 %f\n",y)}'
#统计小于20000的个体工商免税额
#cat /tmp/tempfile.txt | awk 'BEGIN{"cat /tmp/strgetixiaoyu" | getline s}{if(index(s,$2)>0){y+=$3;print $2,$3}}END{printf("小于20000的个体免税 %f\n",y)}' > /tmp/egetixiaoyu
cat /tmp/tempfile.txt | awk 'BEGIN{"cat /tmp/strgetixiaoyu" | getline s}{if(index(s,$2)>0){y+=$3}}END{printf("小于20000的个体免税 %f\n",y)}' 

#统计大于20000的非个体工商免税额
#cat /tmp/tempfile.txt | awk 'BEGIN{"cat /tmp/strfeigetidayu" | getline s}{if(index(s,$2)>0){y+=$3;print $2,$3}}END{printf("大于20000的非个体免税 %f\n",y)}' > /tmp/efeigetidayu
cat /tmp/tempfile.txt | awk 'BEGIN{"cat /tmp/strfeigetidayu" | getline s}{if(index(s,$2)>0){y+=$3}}END{printf("大于20000的非个体免税 %f\n",y)}'
#统计小于等于20000的非个体工商免税额
#cat /tmp/tempfile.txt | awk 'BEGIN{"cat /tmp/strfeigetixiaoyu" | getline s}{if(index(s,$2)>0){y+=$3;print $2,$3}}END{printf("小于等于20000的非个体免税 %f\n",y)}' > /tmp/efeigetixiaoyu
cat /tmp/tempfile.txt | awk 'BEGIN{"cat /tmp/strfeigetixiaoyu" | getline s}{if(index(s,$2)>0){y+=$3}}END{printf("小于等于20000的非个体免税 %f\n",y)}'



#cat /tmp/tempfile.txt |awk '{if( ~/01$/ ||  ~/M0$/ ||  ~/M1$/ ||  ~/M2$/ ||  ~/M3$/ ){if( < 20000)print }}'|sort |uniq|wc -l
