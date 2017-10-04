I found this "httpd.pl" on a clients VPS located in their wp-content/plugins folder while working tech support at a data center. The untouched version is located in this repository as [httpd.pl](https://github.com/dostoevskylabs/OSINT/blob/master/httpd.pl/httpd.pl) -- I decided to start looking into what it did because 2,000 lines of perl is highly suspicious. The fact it also looks like a legitimate httpd and was running along-side apache was also pretty interesting.

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

view-source:http://www.mujweb.cz/avon-lady/webiny/ <-- stuff hidden here
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
    
> Brickwall hit, need to do more recon, and perhaps take a really in-depth look at the httpd.pl file?
