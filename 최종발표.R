#패키지 설치
pkg <- c('readr', 'dplyr', 'magrittr','skimr','Hmisc','psych','ggplot2','GGally','gridExtra','doBy','corrplot','naniar','epiDisplay')
new_pkg <- pkg[!(pkg %in% rownames(installed.packages()))]
if (length(new_pkg)) install.packages(new_pkg, dependencies=TRUE)
suppressMessages(sapply(pkg, require, character.only = TRUE))

#파일 불러오기
h2019 <- read.csv(file = 'health2019.csv', header = TRUE, sep=',',stringsAsFactors=FALSE,strip.white=TRUE,na.strings=c('.','?','NA'))
#파일확인
str(h2019)

#필요없는 컬럼 지우기
h2019 <- h2019[-c(1,2,3,9,10,11,12,28,30,31,32,34)]
#영문으로 변수명 변경
col_n <- c('SEX','AGE','HEIGHT','WEIGHT','WAIST','BP_HIGH',
           'BP_LWST','BLDS','TOT_CHOLE','TRIGLYCERIDE','HDL_CHOLE',
           'LDL_CHOLE','HMG','OLIG_PROTE_CD','CREATININE','SGOT_AST',
           'SGPT_ALT','GAMMA_GTP','SMK_YN','DRK_YN','CRS_YN','TTR_YN')
colnames(h2019) <-col_n

#결측치확인
anyNA(h2019)#DF 결측치 유무
sapply(h2019, anyNA)#변수 결측치 유무
skim(h2019)#결측치 갯수 확인

#치석과 충치 빈도 확인 그리고 결측치 해결
table(h2019$TTR_YN)
table(h2019$CRS_YN)
1000000-sum(table(h2019$TTR_YN))

h2019$CRS_YN[is.na(h2019$CRS_YN)]<-0
h2019$TTR_YN[is.na(h2019$TTR_YN)]<-0

table(h2019$TTR_YN)
table(h2019$CRS_YN)

h2019$TTR_YN <- ifelse(h2019$TTR_YN==0,yes=0, no=1)
table(h2019$TTR_YN)

#음주 결측치 해결
table(h2019$DRK_YN)
h2019$DRK_YN[is.na(h2019$DRK_YN)]<-0
table(h2019$DRK_YN)

#결측치 중앙값으로 대체
table(h2019$SMK_YN)
SMK_YN_med <- h2019$SMK_YN %>% median(na.rm = TRUE) %>% print
h2019$SMK_YN[is.na(h2019$SMK_YN)] <- SMK_YN_med
table(h2019$SMK_YN)

table(h2019$OLIG_PROTE_CD)
OLIG_PROTE_CD_med <- h2019$OLIG_PROTE_CD %>% median(na.rm = TRUE) %>% print
h2019$OLIG_PROTE_CD[is.na(h2019$OLIG_PROTE_CD)] <- OLIG_PROTE_CD_med
table(h2019$OLIG_PROTE_CD)

#바이너리 변수 1로 변경
table(h2019$DRK_YN)
h2019$DRK_YN <- ifelse(h2019$DRK_YN == 1, 2, 1)
table(h2019$CRS_YN)
h2019$CRS_YN <- ifelse(h2019$CRS_YN == 1, 2, 1)
table(h2019$TTR_YN)
h2019$TTR_YN <- ifelse(h2019$TTR_YN == 1, 2, 1)

#허리둘레 
table(h2019$WAIST)
hist(h2019$WAIST)
h2019$WAIST <- ifelse(h2019$WAIST >= 222, NA, h2019$WAIST) #222이상 값 결측치로 변경
table(h2019$WAIST)
hist(h2019$WAIST)

#널값 제거
h2019 <-na.omit(h2019)
skim(h2019)

#DF복사
fac19 <- h2019

#데이터 값 변경하기
fac19$AGE<- ifelse(fac19$AGE==5,20,
       ifelse(fac19$AGE==6,25,
              ifelse(fac19$AGE==7,30,
                     ifelse(fac19$AGE==8,35,
                            ifelse(fac19$AGE==9,40,
                                   ifelse(fac19$AGE==10,45,
                                          ifelse(fac19$AGE==11,50,
                                                 ifelse(fac19$AGE==12,55,
                                                        ifelse(fac19$AGE==13,60,
                                                               ifelse(fac19$AGE==14,65,
                                                                      ifelse(fac19$AGE==15,70,
                                                                             ifelse(fac19$AGE==16,75,
                                                                                    ifelse(fac19$AGE==17,80,85)))))))))))))

table(fac19$AGE)

#나머지 범주화
fac19$BP_HIGH <- ifelse(fac19$BP_HIGH < 120, 1, 
       ifelse(fac19$BP_HIGH >= 120 & fac19$BP_HIGH<130, 2,
              ifelse(fac19$BP_HIGH >= 130 & fac19$BP_HIGH<140, 3,4)))
table(fac19$BP_HIGH)

fac19$BP_LWST <- ifelse(fac19$BP_LWST < 80, 1, 
       ifelse(fac19$BP_LWST >= 80 & fac19$BP_LWST < 90, 2,3))
table(fac19$BP_LWST)

fac19$BLDS <- ifelse(fac19$BLDS < 100, 1,
                     ifelse(fac19$BLDS >= 100 & fac19$BLDS < 126, 2,3))
table(fac19$BLDS)

fac19$TOT_CHOLE <- ifelse(fac19$TOT_CHOLE <= 240, 1, 2)
table(fac19$TOT_CHOLE)

fac19$TRIGLYCERIDE <- ifelse(fac19$TRIGLYCERIDE <= 200, 1, 2)
table(fac19$TRIGLYCERIDE)

fac19$LDL_CHOLE <- ifelse(fac19$LDL_CHOLE <= 130, 1, 2)
table(fac19$LDL_CHOLE)

fac19$CREATININE <- ifelse(fac19$CREATININE >= 0.8 & fac19$CREATININE <= 1.7, 1, 2)
table(fac19$CREATININE)

fac19$SGOT_AST <- ifelse(fac19$SGOT_AST <= 40, 1, 2)
table(fac19$SGOT_AST)

fac19$SGPT_ALT <- ifelse(fac19$SGPT_ALT <= 40, 1, 2)
table(fac19$SGPT_ALT)

fac19$HDL_CHOLE <- ifelse(fac19$SEX==1 & fac19$HDL_CHOLE >= 35 & fac19$HDL_CHOLE <=55, 1, 
                          ifelse(fac19$SEX==2 & fac19$HDL_CHOLE >= 45 & fac19$HDL_CHOLE <=65, 1, 2))
table(fac19$HDL_CHOLE)

fac19$HMG <- ifelse(fac19$SEX==1 & fac19$HMG >= 13 & fac19$HMG <=17, 1, 
                    ifelse(fac19$SEX==2 & fac19$HMG >= 12 & fac19$HMG <=16, 1, 2))
table(fac19$HMG)

fac19$GAMMA_GTP <- ifelse(fac19$SEX==1 & fac19$GAMMA_GTP >= 11 & fac19$GAMMA_GTP <=63, 1, 
                          ifelse(fac19$SEX==1 & fac19$GAMMA_GTP >= 8 & fac19$GAMMA_GTP <=35, 1, 2))
table(fac19$GAMMA_GTP)

#변수간 상관관계
round(cor(fac19),2)
corrplot(round(cor(fac19),2), method = 'pie')

#유의미한 변수들의 시각화 분석
tab1(fac19$SEX)
tab1(fac19$AGE)
tab1(fac19$HEIGHT)
tab1(fac19$WEIGHT)
tab1(fac19$BP_HIGH)
tab1(fac19$TOT_CHOLE)
tab1(fac19$CREATININE)
tab1(fac19$SGOT_AST)
tab1(fac19$GAMMA_GTP)
tab1(fac19$SMK_YN)
hist(fac19$WAIST)
tab1(fac19$BP_LWST)
tab1(fac19$LDL_CHOLE)
tab1(fac19$SGPT_ALT)

fac19tab <- fac19[c('SEX','AGE','HEIGHT','WEIGHT','BP_HIGH','TOT_CHOLE','CREATININE',
                    'SGOT_AST','GAMMA_GTP','SMK_YN','WAIST','BP_LWST','LDL_CHOLE',
                    'SGPT_ALT')]
corrplot.mixed(cor(fac19tab))

#입력 값
#성별 남자:1, 여자:2
#나이 20~24세:20 25~29세:25....
#신장 5단위, 176cm:175
#체중 5단위, 101kg:100
#흡연유무 안핀다1, 핀다2
var <- fac19 %>% 
        filter(SEX==1 & AGE==30 & HEIGHT==170 & WEIGHT==90 & SMK_YN==2)
var <- var[-c(1,2,3,4,19)]
#Median값이 해당되는 구간이며 Mean값으로 의심도를 파악 
#WAIST 허리둘레, 유일한 수치형 단위cm
#BP_HIGH 수축기 혈압, 정상수치:1, 주의혈압:2, 고혈압 전단계:3, 고혈압:4 
#BP_LWST 이완기 혈압, 정상수치:1, 고혈압 전단계:2, 고혈압:3
#BLDS 공복혈당, 정상수치:1, 공복혈당장애:2, 당뇨병:3 (당뇨병이란 인슐린 분비 부족이나 인슐린 저항성으로 인해 혈중에 있는 당분이 사용되지 못하고 증가된 상태를 말한다. 다양한 합병증이 발생하므로 합병증 예방이 주 치료 목표이다.)
#TOT_CHOLE 총콜레스테롤, 정상수치:1 비정상:2
#TRIGLYCERIDE 중성지방, 정상수치:1 비정상:2
#HDL_CHOLE HDL콜레스테롤, 정상수치:1 비정상:2
#LDL_CHOLE LDL콜레스테롤, 정상수치:1 비정상:2 (고지혈증이란 혈액 속에 콜레스테롤이나 중성지방이 정상보다 높이 증가된 상태를 말한다. 고지혈증 그 자체로는 증상을 일으키지 않지만 장기적으로 동맥경화증, 고혈압, 뇌혈관질환, 허혈성 심질환 등의 위험요인이 되기 때문에 적절한 치료가 필요하다.)
#HMG 혈색소, 정상수치:1 비정상:2 (신장질환 진단에 이용된다. 사구체나 세뇨관의 손상, 하부요로에 염증이나 출혈이 있으면 소변으로 단백이 유출된다.)
#OLIG_PROTE_CD 단백뇨, 정상수치:1 ±:2, +1:3, +2:4, +3:5, +4:6
#CREATININE 혈청크레아티닌, 정상수치:1 비정상:2 (혈청크레아티닌 수치의 증가는 급만성신부전, 급만성신장염, 신우신염, 요로폐쇄질환, 탈수증 등의 질환을 의심해 볼 수 있다. 혈청크레아티닌 수치의 감소는 요붕증, 근육위축 등의 질환을 의심해 볼 수 있다.)
#SGOT_AST 간기능, 정상수치:1 비정상:2
#SGPT_ALT 간기능,정상수치:1 비정상:2 (간세포내에 존재하는 효소로 세포가 파괴되면 혈액속으로 나오게 된다. 즉, 이 효소의 혈중농도가 높으면 간세포가 파괴되거나 손상되었음을 의미한다.)
#GAMMA_GTP 간기능,정상수치:1 비정상:2 (알코올에 특히 민감하게 반응하므로 알코올성 간질환의 지표로 이용된다.)
#DRK_YN 음주않음:1 음주함:2
#CRS_YN 충치없음:1 충치있음:2
#TTR_YN 치석없음:1 치석있음:2
summary(var)



#입력 값
#성별 남자:1, 여자:2
#나이 20~24세:20 25~29세:25....
#신장 5단위, 176cm:175
#체중 5단위, 101kg:100
#흡연유무 안핀다1, 핀다2
var <- fac19 %>% 
        filter(SEX==2 & AGE==60 & HEIGHT==155 & WEIGHT==50 & SMK_YN==1)
var <- var[-c(1,2,3,4,19)]
#Median값이 해당되는 구간이며 Mean값으로 의심도를 파악 
#WAIST 허리둘레, 유일한 수치형 단위cm
#BP_HIGH 수축기 혈압, 정상수치:1, 주의혈압:2, 고혈압 전단계:3, 고혈압:4 
#BP_LWST 이완기 혈압, 정상수치:1, 고혈압 전단계:2, 고혈압:3
#BLDS 공복혈당, 정상수치:1, 공복혈당장애:2, 당뇨병:3 (당뇨병이란 인슐린 분비 부족이나 인슐린 저항성으로 인해 혈중에 있는 당분이 사용되지 못하고 증가된 상태를 말한다. 다양한 합병증이 발생하므로 합병증 예방이 주 치료 목표이다.)
#TOT_CHOLE 총콜레스테롤, 정상수치:1 비정상:2
#TRIGLYCERIDE 중성지방, 정상수치:1 비정상:2
#HDL_CHOLE HDL콜레스테롤, 정상수치:1 비정상:2
#LDL_CHOLE LDL콜레스테롤, 정상수치:1 비정상:2 (고지혈증이란 혈액 속에 콜레스테롤이나 중성지방이 정상보다 높이 증가된 상태를 말한다. 고지혈증 그 자체로는 증상을 일으키지 않지만 장기적으로 동맥경화증, 고혈압, 뇌혈관질환, 허혈성 심질환 등의 위험요인이 되기 때문에 적절한 치료가 필요하다.)
#HMG 혈색소, 정상수치:1 비정상:2 (신장질환 진단에 이용된다. 사구체나 세뇨관의 손상, 하부요로에 염증이나 출혈이 있으면 소변으로 단백이 유출된다.)
#OLIG_PROTE_CD 단백뇨, 정상수치:1 ±:2, +1:3, +2:4, +3:5, +4:6
#CREATININE 혈청크레아티닌, 정상수치:1 비정상:2 (혈청크레아티닌 수치의 증가는 급만성신부전, 급만성신장염, 신우신염, 요로폐쇄질환, 탈수증 등의 질환을 의심해 볼 수 있다. 혈청크레아티닌 수치의 감소는 요붕증, 근육위축 등의 질환을 의심해 볼 수 있다.)
#SGOT_AST 간기능, 정상수치:1 비정상:2
#SGPT_ALT 간기능,정상수치:1 비정상:2 (간세포내에 존재하는 효소로 세포가 파괴되면 혈액속으로 나오게 된다. 즉, 이 효소의 혈중농도가 높으면 간세포가 파괴되거나 손상되었음을 의미한다.)
#GAMMA_GTP 간기능,정상수치:1 비정상:2 (알코올에 특히 민감하게 반응하므로 알코올성 간질환의 지표로 이용된다.)
#DRK_YN 음주않음:1 음주함:2
#CRS_YN 충치없음:1 충치있음:2
#TTR_YN 치석없음:1 치석있음:2
summary(var)

