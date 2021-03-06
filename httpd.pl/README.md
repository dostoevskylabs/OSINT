I found this "httpd.pl" on a clients VPS located in their wp-content/plugins folder while working tech support at a data center. The untouched version is located in this repository as [httpd.pl](https://github.com/dostoevskylabs/OSINT/blob/master/httpd.pl/httpd.pl) -- I decided to start looking into what it did because 2,000 lines of perl is highly suspicious. The fact it also looks like a legitimate httpd and was running along-side apache was also pretty interesting.

> People affected by this suspicious perl script
*  https://www.google.com/search?q="httpd.pl"+backdoor

First thing I did was google something I figured could be used as a signature: "Jm73uZ" from the httpd.pl file

first trace found in http://www.mifi.ru/-strange-/

An empty directory stored on a .ru domain and it seems to be an unencrypted version of the httpd.pl found on the clients machine.

> http://www.mifi.ru/-strange-/awcrtxtu.cgi <--- russian

Upon checking out the actual website we can see:
```bash
Дистанционные курсы для школьников 6-11 классов
по математике, физике, химии, русскому языку
```
Which translates to:
```bash
Distance courses for schoolchildren of 6-11 grades on mathematics...Russian language
```
Seems kind of strange to be on a website for a school, especially not being a university.

> Now some googling for various signatures identified found these samples (I have stored copies of them in /samples/):
```
http://users.telenet.be/daveymonster/images/ae.php
http://centro-michels.org/paginas/_vti_cnf/mgvb2kbc.php?id=1032361
http://users.telenet.be/daveymonster/
http://users.telenet.be/daveymonster/bsexlq.php
http://users.telenet.be/daveymonster/hy.html
http://users.telenet.be/daveymonster/index.php
http://users.telenet.be/daveymonster/halloween/
http://mujweb.cz/nezmari/i.php
http://mujweb.cz/nezmari/
http://mujweb.cz/nezmari/dsvigu.php <-- again testing for code exec with <?php echo "Jm73uZ";?> 
http://mujweb.cz/zusm/gqcsimvu.php
http://mujweb.cz/zusm/
http://mujweb.cz/zusm/svatky.js
http://mujweb.cz/zusm/index1styre.htm
http://mujweb.cz/zusm/always11/  <-- the name "always11" appears in the external servers below
http://mujweb.cz/zusm/always11/others/
http://mujweb.cz/zusm/always11/others/cost94php
http://mujweb.cz/zusm/always11/others/err404.php
http://mujweb.cz/zusm/always11/squad/
http://mujweb.cz/zusm/always11/squad/slowly/
http://mujweb.cz/zusm/always11/squad/slowly/assistance.js
http://www.mujweb.cz/avon-lady/images/ehm.php
http://www.mujweb.cz/avon-lady/
http://www.mujweb.cz/avon-lady/ok.html
http://www.mujweb.cz/avon-lady/r.php
http://www.mujweb.cz/avon-lady/v.php <-- again testing for code exec with <?php echo "Jm73uZ";?> 
http://usf.speleo.free.fr/drpdsn.cgi <-- Comments in French this time, still to the same email
http://usf.speleo.free.fr/ <-- Some ISP in france?
http://lespotagersnatures.free.fr/ilrm.php

https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=2&cad=rja&uact=8&ved=0ahUKEwiVkNnVhtfWAhUB5iYKHT6tD3MQIAgxMAE&url=http%3A%2F%2Fwebcache.googleusercontent.com%2Fsearch%3Fq%3Dcache%3AVu6Sh7c7nqAJ%3Awww.iwantwireless.ca%2Fsimplecms%2Fapp%2Fweb%2Fupload%2Ftinymce-source%2Fgaler.php.accdb%253Ffilesrc%253D%2F%2Ftmp%2Fhttpd.pl%2526path%253D%2F%2Ftmp%2B%26cd%3D2%26hl%3Den%26ct%3Dclnk%26gl%3Dus%26client%3Dubuntu&usg=AOvVaw0_1aNx_fe3jXwYj6RTxKrg <-- cache of a backdoor using this

view-source:http://www.mujweb.cz/avon-lady/webiny/ <-- stuff hidden here
```
> Found a google cache of a backdoor which reveals a name that may or may not be relevant `Et04`
```
http://www.iwantwireless.ca/simplecms/app/web/upload/tinymce-source/galer.php.accdb?filesrc=//tmp/httpd.pl&path=//tmp
```
![Backdoor_001](https://i.imgur.com/0BKD9tU.png)
*  Seems to be in the wild a lot: https://www.google.com/search?q=et04+backdoor
*  May not be directly related to the et04 backdoor, it's possible the cache example was just to stage httpd.pl
*  Samples of Et04
```
http://www.yeos.com.sg/imagestore/userfiles/file/ScreenSavers/SM.phtml
http://iccis.untar.ac.id/download/proceeding/default.php?path=//proc/self/root/sys/class/tty/tty54/subsystem/console/subsystem/tty17/subsystem/tty21/subsystem/tty10/subsystem/tty50/subsystem/tty9/subsystem/tty16/subsystem/tty55
http://webcache.googleusercontent.com/search?q=cache:CjB5j6rwYogJ:www.iwantwireless.ca/simplecms/app/web/upload/tinymce-source/galer.php.accdb%3Ffilesrc%3D/home/sites/www.iwantwireless.ca/web/simplecms/app/web/upload/tinymce-source/back.pl%26path%3D/home/sites/www.iwantwireless.ca/web/simplecms/app/web/upload/tinymce-source+&cd=3&hl=en&ct=clnk&gl=us
```
*  The last sample reveals a handle: ManSyk3z -- however we still dont' know if they are conected
> ManSyk3z
*  This handle may not be the author of the malware but in at least one instance it was used in conjunction with a reverse shell developed by them.
```
https://www.youtube.com/channel/UCL1blnQRv_Li5dUXkpaswBw
https://www.facebook.com/mafias3c/
```
> E-Mail is the same on each sample regardless of language the comments for the malware are in
```bash
ryglman@yahoo.com
```
> External Servers Found (all dead now):
```bash
http://mbcobretti.com/hydra.php
http://94.244.80.14/users.txt
http://awrinc.net/style/images/go.php?sid=1
http://srisaibalaji.com/aspnet_client/mypassword.php
http://sadmeanother12.ru/img/header.php?ftd=4755726&path=%7calways11%7cothers%7c&sys=UN&wrk=22
```
> mbcobretti.com
```bash
Last known IP: 87.98.239.4 / Poland / OVH
```
1.  https://herdprotect.com/ip-address-87.98.239.4.aspx
  * Some information on the OVH server, part of cluster003
2.  https://cymon.io/87.98.239.4
  * Timeline shows there are 74 entries for this IP address.
    ![Timeline 001](https://i.imgur.com/eyWrKvv.png)
  * 4 Months ago we can see our suspect mbcobretti.com identified
    ![Timeline 002](https://i.imgur.com/6OA6YIb.png)
3.  https://otx.alienvault.com/indicator/ip/87.98.239.4/
  * Now that we know this is definitely the staging server lets investigate
    ![Domains](https://i.imgur.com/IE2TP0i.png)
    [associated_domains.txt](https://github.com/dostoevskylabs/OSINT/blob/master/httpd.pl/associated_domains.txt)
  * Let's look at some suspicious URLs reported
    ![Suspicious_001](https://i.imgur.com/8psjn9f.png)
    ![Suspicious_002](https://i.imgur.com/WEKP3nH.png)
  * Now to identify specific files, here you can see some of the iframe's from the /samples/ folder
    ![Samples_001](https://i.imgur.com/c15sXTW.png)
  * This looks interesting it's a tar.gz file
    ![Samples_002](https://i.imgur.com/a7clATR.png)
  * Investigating this link we find a username `getronst`
    ![Recon_001](https://i.imgur.com/pzhVO9M.png)
    
> Thanks to a friend who is amazing with Malware reverse engineering [fs0c131y](https://twitter.com/fs0c131y) I was informed the malware sample is a sophisticated perl backdoor/spam daemon that builds its own ELF executables called mumblehard more on it here:
*  https://www.welivesecurity.com/2015/04/29/unboxing-linuxmumblehard-muttering-spam-servers/
