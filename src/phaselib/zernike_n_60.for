
c****************************************************************
	subroutine zernike_n(rho)
c****************************************************************

      implicit real*8(a-h,o-z)

      common/rnrnl/rn(0:60),rnl(0:60,-60:60)

      RN(0.)=1.
      RN(2.)=2.*RHO**2-1.
      RN(4.)=6.*RHO**4-6.*RHO**2+1.
      RN(6.)=20.*RHO**6-30.*RHO**4+12.*RHO**2-1.
      RN(8.)=70.*RHO**8-140.*RHO**6+90.*RHO**4-20.*RHO**2+
     . 1.
      RN(10.)=252.*RHO**10-630.*RHO**8+560.*RHO**6-210.*
     . RHO**4+30.*RHO**2-1.
      RN(12.)=924.*RHO**12-2772.*RHO**10+3150.*RHO**8-
     . 1680.*RHO**6+420.*RHO**4-42.*RHO**2+1.
      RN(14.)=3432.*RHO**14-12012.*RHO**12+16632.*RHO**10-
     . 11550.*RHO**8+4200.*RHO**6-756.*RHO**4+56.*RHO**2-1.
      RN(16.)=12870.*RHO**16-51480.*RHO**14+84084.*RHO**12
     . -72072.*RHO**10+34650.*RHO**8-9240.*RHO**6+1260.*
     . RHO**4-72.*RHO**2+1.
      RN(18.)=48620.*RHO**18-218790.*RHO**16+411840.*RHO**
     . 14-420420.*RHO**12+252252.*RHO**10-90090.*RHO**8+
     . 18480.*RHO**6-1980.*RHO**4+90.*RHO**2-1.
      RN(20.)=184756.*RHO**20-923780.*RHO**18+1969110.*RHO
     . **16-2333760.*RHO**14+1681680.*RHO**12-756756.*RHO
     . **10+210210.*RHO**8-34320.*RHO**6+2970.*RHO**4-110.
     . *RHO**2+1.
      RN(22.)=705432.*RHO**22-3879876.*RHO**20+9237800.*
     . RHO**18-12471030.*RHO**16+10501920.*RHO**14-
     . 5717712.*RHO**12+2018016.*RHO**10-450450.*RHO**8+
     . 60060.*RHO**6-4290.*RHO**4+132.*RHO**2-1.
      RN(24.)=2704156.*RHO**24-16224936.*RHO**22+42678636.
     . *RHO**20-64664600.*RHO**18+62355150.*RHO**16-
     . 39907296.*RHO**14+17153136.*RHO**12-4900896.*RHO**10
     . +900900.*RHO**8-100100.*RHO**6+6006.*RHO**4-156.*
     . RHO**2+1.
      RN(26.)=10400600.*RHO**26-67603900.*RHO**24+
     . 194699232.*RHO**22-327202876.*RHO**20+355655300.*RHO
     . **18-261891630.*RHO**16+133024320.*RHO**14-
     . 46558512.*RHO**12+11027016.*RHO**10-1701700.*RHO**8+
     . 160160.*RHO**6-8190.*RHO**4+182.*RHO**2-1.
      RN(28.)=40116600.*RHO**28-280816200.*RHO**26+
     . 878850700.*RHO**24-1622493600.*RHO**22+1963217256.*
     . RHO**20-1636014380.*RHO**18+960269310.*RHO**16-
     . 399072960.*RHO**14+116396280.*RHO**12-23279256.*RHO
     . **10+3063060.*RHO**8-247520.*RHO**6+10920.*RHO**4-
     . 210.*RHO**2+1.
      RN(30.)=155117520.*RHO**30-1163381400.*RHO**28+
     . 3931426800.*RHO**26-7909656300.*RHO**24+10546208400.
     . *RHO**22-9816086280.*RHO**20+6544057520.*RHO**18-
     . 3155170590.*RHO**16+1097450640.*RHO**14-271591320.*
     . RHO**12+46558512.*RHO**10-5290740.*RHO**8+371280.*
     . RHO**6-14280.*RHO**4+240.*RHO**2-1.
      RN(32.)=601080390.*RHO**32-4808643120.*RHO**30+
     . 17450721000.*RHO**28-38003792400.*RHO**26+
     . 55367594100.*RHO**24-56949525360.*RHO**22+
     . 42536373880.*RHO**20-23371634000.*RHO**18+
     . 9465511770.*RHO**16-2804596080.*RHO**14+597500904.*
     . RHO**12-88884432.*RHO**10+8817900.*RHO**8-542640.*
     . RHO**6+18360.*RHO**4-272.*RHO**2+1.
      RN(34.)=2333606220.*RHO**34-19835652870.*RHO**32+
     . 76938289920.*RHO**30-180324117000.*RHO**28+
     . 285028443000.*RHO**26-321132045780.*RHO**24+
     . 265764451680.*RHO**22-164068870680.*RHO**20+
     . 75957810500.*RHO**18-26293088250.*RHO**16+
     . 6731030592.*RHO**14-1249320072.*RHO**12+162954792.*
     . RHO**10-14244300.*RHO**8+775200.*RHO**6-23256.*RHO
     . **4+306.*RHO**2-1.
      RN(36.)=9075135300.*RHO**36-81676217700.*RHO**34+
     . 337206098790.*RHO**32-846321189120.*RHO**30+
     . 1442592936000.*RHO**28-1767176346600.*RHO**26+
     . 1605660228900.*RHO**24-1101024156960.*RHO**22+
     . 574241047380.*RHO**20-227873431500.*RHO**18+
     . 68362029450.*RHO**16-15297796800.*RHO**14+
     . 2498640144.*RHO**12-288304632.*RHO**10+22383900.*RHO
     . **8-1085280.*RHO**6+29070.*RHO**4-342.*RHO**2+1.
      RN(38.)=35345263800.*RHO**38-335780006100.*RHO**36+
     . 1470171918600.*RHO**34-3934071152550.*RHO**32+
     . 7193730107520.*RHO**30-9521113377600.*RHO**28+
     . 9424940515200.*RHO**26-7110781013700.*RHO**24+
     . 4128840588600.*RHO**22-1850332263780.*RHO**20+
     . 638045608200.*RHO**18-167797708650.*RHO**16+
     . 33145226400.*RHO**14-4805077200.*RHO**12+494236512.*
     . RHO**10-34321980.*RHO**8+1492260.*RHO**6-35910.*RHO
     . **4+380.*RHO**2-1.
      RN(40.)=137846528820.*RHO**40-1378465288200.*RHO**38
     . +6379820115900.*RHO**36-18132120329400.*RHO**34+
     . 35406640372950.*RHO**32-50356110752640.*RHO**30+
     . 53952975806400.*RHO**28-44431862428800.*RHO**26+
     . 28443124054800.*RHO**24-14221562027400.*RHO**22+
     . 5550996791340.*RHO**20-1682120239800.*RHO**18+
     . 391527986850.*RHO**16-68840085600.*RHO**14+
     . 8923714800.*RHO**12-823727520.*RHO**10+51482970.*RHO
     . **8-2018940.*RHO**6+43890.*RHO**4-420.*RHO**2+1.
      RN(42.)=538257874440.*RHO**42-5651707681620.*RHO**40
     . +27569305764000.*RHO**38-82937661506700.*RHO**36+
     . 172255143129300.*RHO**34-262009138759830.*RHO**32+
     . 302136664515840.*RHO**30-269764879032000.*RHO**28+
     . 188835415322400.*RHO**26-104291454867600.*RHO**24+
     . 45508998487680.*RHO**22-15643718230140.*RHO**20+
     . 4205300599500.*RHO**18-873408586050.*RHO**16+
     . 137680171200.*RHO**14-16062686640.*RHO**12+
     . 1338557220.*RHO**10-75710250.*RHO**8+2691920.*RHO**6
     . -53130.*RHO**4+462.*RHO**2-1.
      RN(44.)=2104098963720.*RHO**44-23145088600920.*RHO**
     . 42+118685861314020.*RHO**40-376780512108000.*RHO**
     . 38+829376615067000.*RHO**36-1343590116408540.*RHO**
     . 34+1659391212145590.*RHO**32-1597008083869440.*RHO
     . **30+1213941955644000.*RHO**28-734359948476000.*RHO
     . **26+354590946549840.*RHO**24-136526995463040.*RHO
     . **22+41716581947040.*RHO**20-10028024506500.*RHO**
     . 18+1871589827250.*RHO**16-266181664320.*RHO**14+
     . 28109701620.*RHO**12-2125943820.*RHO**10+109359250.*
     . RHO**8-3542000.*RHO**6+63756.*RHO**4-506.*RHO**2+1.
      RN(46.)=8233430727600.*RHO**46-94684453367400.*RHO**
     . 44+509191949220240.*RHO**42-1701164012167620.*RHO**
     . 40+3956195377134000.*RHO**38-6800888243549400.*RHO
     . **36+8957267442723600.*RHO**34-9245179610525430.*
     . RHO**32+7585788398379840.*RHO**30-4990650262092000.
     . *RHO**28+2643695814513600.*RHO**26-
     . 1128243920840400.*RHO**24+386826487145280.*RHO**22-
     . 105895938788640.*RHO**20+22921198872000.*RHO**18-
     . 3867952309650.*RHO**16+499090620600.*RHO**14-
     . 47951843940.*RHO**12+3307023720.*RHO**10-155405250.*
     . RHO**8+4604600.*RHO**6-75900.*RHO**4+552.*RHO**2-1.
      RN(48.)=32247603683100.*RHO**48-386971244197200.*RHO
     . **46+2177742427450200.*RHO**44-7637879238303600.*
     . RHO**42+18712804133843820.*RHO**40-
     . 34023280243352400.*RHO**38+47606217704845800.*RHO**
     . 36-52463995021666800.*RHO**34+46225898052627150.*
     . RHO**32-32871749726312640.*RHO**30+
     . 18964470995949600.*RHO**28-8892431376091200.*RHO**26
     . +3384731762521200.*RHO**24-1041455926929600.*RHO**
     . 22+257175851343840.*RHO**20-50426637518400.*RHO**18
     . +7735904619300.*RHO**16-910106425800.*RHO**14+
     . 79919739900.*RHO**12-5047562520.*RHO**10+217567350.*
     . RHO**8-5920200.*RHO**6+89700.*RHO**4-600.*RHO**2+1.
      RN(50.)=126410606437752.*RHO**50-1580132580471900.*
     . RHO**48+9287309860732800.*RHO**46-
     . 34117964696719800.*RHO**44+87835611240491400.*RHO**
     . 42-168415237204594380.*RHO**40+249504055117917600.*
     . RHO**38-292438194472624200.*RHO**36+
     . 275435973863750700.*RHO**34-210584646684190350.*RHO
     . **32+131486998905250560.*RHO**30-67237669894730400.
     . *RHO**28+28159366024288800.*RHO**26-
     . 9633467324098800.*RHO**24+2678029526390400.*RHO**22-
     . 600076986468960.*RHO**20+107156604726600.*RHO**18-
     . 15016756025700.*RHO**16+1617966979200.*RHO**14-
     . 130395365100.*RHO**12+7571343780.*RHO**10-300450150.
     . *RHO**8+7534800.*RHO**6-105300.*RHO**4+650.*RHO**2-
     . 1.
      RN(52.)=495918532948104.*RHO**52-6446940928325352.*
     . RHO**50+39503314511797500.*RHO**48-
     . 151692727725302400.*RHO**46+409415576360637600.*RHO
     . **44-825654745660619160.*RHO**42+
     . 1291183485235223580.*RHO**40-1603954640043756000.*
     . RHO**38+1608410069599433100.*RHO**36-
     . 1315971875126808900.*RHO**34+884455516073599470.*RHO
     . **32-490087905010479360.*RHO**30+
     . 224125566315768000.*RHO**28-84478098072866400.*RHO**
     . 26+26147982736839600.*RHO**24-6605806165096320.*RHO
     . **22+1350173219555160.*RHO**20-220616539143000.*RHO
     . **18+28364983604100.*RHO**16-2810153174400.*RHO**14
     . +208632584160.*RHO**12-11176745580.*RHO**10+
     . 409704750.*RHO**8-9500400.*RHO**6+122850.*RHO**4-
     . 702.*RHO**2+1.
      RN(54.)=1946939425648112.*RHO**54-26283682246249512.
     . *RHO**52+167620464136459152.*RHO**50-
     . 671556346700557500.*RHO**48+1896159096566280000.*RHO
     . **46-4012272648334248480.*RHO**44+
     . 6605237965284953280.*RHO**42-8669374829436501180.*
     . RHO**40+9222739180251597000.*RHO**38-
     . 8042050347997165500.*RHO**36+5790276250557959160.*
     . RHO**34-3457417017378616110.*RHO**32+
     . 1715307667536677760.*RHO**30-706857555303576000.*RHO
     . **28+241365994493904000.*RHO**26-67984755115782960.
     . *RHO**24+15688789642103760.*RHO**22-
     . 2938612301384760.*RHO**20+441233078286000.*RHO**18-
     . 52251285586500.*RHO**16+4777260396480.*RHO**14-
     . 327851203680.*RHO**12+16257084480.*RHO**10-
     . 552210750.*RHO**8+11875500.*RHO**6-142506.*RHO**4+
     . 756.*RHO**2-1.
      RN(56.)=7648690600760440.*RHO**56-
     . 107081668410646160.*RHO**54+709659420648736824.*RHO
     . **52-2961294866410778352.*RHO**50+
     . 8730232507107247500.*RHO**48-19340822784976056000.*
     . RHO**46+33435605402785404000.*RHO**44-
     . 46236665756994672960.*RHO**42+52016248976619007080.*
     . RHO**40-48163193496869451000.*RHO**38+
     . 36993431600786961300.*RHO**36-23687493752282560200.*
     . RHO**34+12677195730388259070.*RHO**32-
     . 5673709977236703360.*RHO**30+2120572665910728000.*
     . RHO**28-659733718283337600.*RHO**26+
     . 169961887789457400.*RHO**24-35991929178943920.*RHO**
     . 22+6203737080701160.*RHO**20-859243362978000.*RHO**
     . 18+94052314055700.*RHO**16-7962100660800.*RHO**14+
     . 506679132960.*RHO**12-23325382080.*RHO**10+
     . 736281000.*RHO**8-14725620.*RHO**6+164430.*RHO**4-
     . 812.*RHO**2+1.
      RN(58.)=30067266499541040.*RHO**58-
     . 435975364243345080.*RHO**56+2998286715498092480.*RHO
     . **54-13010422711893508440.*RHO**52+
     . 39977480696545507752.*RHO**50-92540464575336823500.*
     . RHO**48+167620464136459152000.*RHO**46-
     . 243602267934579372000.*RHO**44+
     . 288979160981216706000.*RHO**42-
     . 283199577761592371880.*RHO**40+
     . 231183328784973364800.*RHO**38-
     . 158062844112453380100.*RHO**36+90802059383749814100.
     . *RHO**34-43882600605190127550.*RHO**32+
     . 17831659928458210560.*RHO**30-6078974975610753600.*
     . RHO**28+1731801010493761200.*RHO**26-
     . 409908082315750200.*RHO**24+79982064842097600.*RHO**
     . 22-12733986639333960.*RHO**20+1632562389658200.*RHO
     . **18-165711220002900.*RHO**16+13028891990400.*RHO**
     . 14-771033463200.*RHO**12+33044291280.*RHO**10-
     . 971890920.*RHO**8+18123840.*RHO**6-188790.*RHO**4+
     . 870.*RHO**2-1.
      ANS1=1270934280.*RHO**8-22151360.*RHO**6+215760.*RHO
     . **4-930.*RHO**2+1.
      RN(60.)=118264581564861424.*RHO**60-
     . 1773968723472921360.*RHO**58+12643285563057007320.*
     . RHO**56-56967447594463757120.*RHO**54+
     . 182145917966509118160.*RHO**52-
     . 439752287662000585272.*RHO**50+
     . 832864181178031411500.*RHO**48-
     . 1269126371318905008000.*RHO**46+
     . 1583414741574765918000.*RHO**44-
     . 1637548578893561334000.*RHO**42+
     . 1415997888807961859400.*RHO**40-
     . 1029816646405790443200.*RHO**38+
     . 632251376449813520400.*RHO**36-
     . 328284368541249327900.*RHO**34+
     . 144185687702767561950.*RHO**32-53494979785374631680.
     . *RHO**30+16717181182929572400.*RHO**28-
     . 4380437850072454800.*RHO**26+956452192070083800.*RHO
     . **24-172592876764526400.*RHO**22+25467973278667920.
     . *RHO**20-3031901580793800.*RHO**18+286228470914100.
     . *RHO**16-20959521897600.*RHO**14+1156550194800.*RHO
     . **12-46262007792.*RHO**10+ANS1

	return
	end
