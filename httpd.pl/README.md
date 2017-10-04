I found this "httpd.pl" on a clients VPS located in their wp-content/plugins folder while working tech support at a data center. The untouched version is located in this repository as httpd.pl -- I decided to start looking into what it did because 2,000 lines of perl is highly suspicious. The fact it also looks like a legitimate httpd and was running along-side apache was also pretty interesting.

First thing I did was google something I figured could be used as a signature: "Jm73uZ" from the httpd.pl file

first trace found in http://www.mifi.ru/-strange-/

An empty directory stored on a .ru domain and it seems to be an unencrypted version of the httpd.pl found on the clients machine.

http://www.mifi.ru/-strange-/awcrtxtu.cgi <--- russian

Upon checking out the actual website we can see:
```bash
Дистанционные курсы для школьников 6-11 классов
по математике, физике, химии, русскому языку
```

Which translates to:
```bash
Distance courses for schoolchildren of 6-11 grades on mathematics, physics, chemistry, Russian language
```
Seems kind of strange to be on a website for a school, especially not being a university.

Within the unencrypted version found on this server we can see an E-Mail "ryglman@yahoo.com"

Now some googling results in this information:
```bash
Signatures found:
Jm73uZ
jdeumog
hgt5y54ytr
jkovdowqo
#cb7c9f#
```
```bash
Emails found:
ryglman@yahoo.com
```
```bash
External Servers Found (all dead now):
http://mbcobretti.com/hydra.php
http://94.244.80.14/users.txt
http://awrinc.net/style/images/go.php?sid=1
http://srisaibalaji.com/aspnet_client/mypassword.php
http://sadmeanother12.ru/img/header.php?ftd=4755726&path=%7calways11%7cothers%7c&sys=UN&wrk=22
```
Sources (I have made copies of this in the /samples/ directory):
```bash
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
http://mujweb.cz/zusm/always11/  <-- the name always11 appears in the external servers above
http://mujweb.cz/zusm/always11/others/
http://mujweb.cz/zusm/always11/others/cost94php
http://mujweb.cz/zusm/always11/others/err404.php
http://mbcobretti.com/hydra.php
http://mujweb.cz/zusm/always11/squad/
http://mujweb.cz/zusm/always11/squad/slowly/
http://mujweb.cz/zusm/always11/squad/slowly/assistance.js
http://www.mujweb.cz/avon-lady/images/ehm.php
http://www.mujweb.cz/avon-lady/
http://www.mujweb.cz/avon-lady/ok.html
http://www.mujweb.cz/avon-lady/r.php
http://www.mujweb.cz/avon-lady/v.php <-- again testing for code exec with <?php echo "Jm73uZ";?> 
view-source:http://www.mujweb.cz/avon-lady/webiny/ <-- stuff hidden here
http://usf.speleo.free.fr/drpdsn.cgi <-- Comments in French this time, still to the same email
http://usf.speleo.free.fr/ <-- Some ISP in france?
http://lespotagersnatures.free.fr/ilrm.php
```

