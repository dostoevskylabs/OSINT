I found this on a clients VPS located in their wp-content/plugins folder while working tech support at a data center. I decided to start looking into what it did because 2,000 lines of perl is highly suspicious. The fact it also looks like a legitimate httpd and was running along-side apache was also pretty interesting.

First thing I did was google something I figured could be used as a signature: "Jm73uZ" from the httpd.pl file

first trace found in http://www.mifi.ru/-strange-/

An empty directory stored on a .ru domain already raises some red flags and it seems to be an unencrypted version of the httpd.pl found on the clients machine.

http://www.mifi.ru/-strange-/awcrtxtu.cgi <--- russian

Upon checking out the actual website we can see:
Дистанционные курсы для школьников 6-11 классов
по математике, физике, химии, русскому языку

Distance courses for schoolchildren of 6-11 grades on mathematics, physics, chemistry, Russian language

Seems kind of strange to be on a website for a school, especially not being a university.

Within the unencrypted version found on this server we can see an E-Mail "ryglman@yahoo.com"

Plemininary googlign of this resulted in some hits:
http://users.telenet.be/daveymonster/images/ae.php
Jm73uZ
#cb7c9f#
http://centro-michels.org/paginas/_vti_cnf/mgvb2kbc.php?id=1032361
hgt5y54ytr
ryglman@yahoo.com
http://users.telenet.be/daveymonster/
This is an empty directory, in it we see:
http://users.telenet.be/daveymonster/bsexlq.php
<?php echo "Jm73uZ";?> 
http://users.telenet.be/daveymonster/hy.html
holy shit.
http://users.telenet.be/daveymonster/index.php
This redirects to this:
http://awrinc.net/style/images/go.php?sid=1
http://users.telenet.be/daveymonster/halloween/
http://srisaibalaji.com/aspnet_client/mypassword.php
http://mujweb.cz/nezmari/i.php
Jm73uZ
jdeumog
ryglman@yahoo.com
http://mujweb.cz/nezmari/
http://mujweb.cz/nezmari/dsvigu.php
<?php echo "Jm73uZ";?>
It's beginning to look like this is how he tests for his code execution
http://mujweb.cz/zusm/gqcsimvu.php
Jm73uZ
http://mbcobretti.com/hydra.php
jdeumog
ryglman@yahoo.com
http://mujweb.cz/zusm/
http://mujweb.cz/zusm/svatky.js
http://94.244.80.14/users.txt
http://mujweb.cz/zusm/index1styre.htm
more what?
http://mujweb.cz/zusm/always11/
What have we stumbled upon here?
http://mujweb.cz/zusm/always11/others/
http://mujweb.cz/zusm/always11/others/cost94php
http://mujweb.cz/zusm/always11/others/err404.php
http://mbcobretti.com/hydra.php
http://mujweb.cz/zusm/always11/squad/
http://mujweb.cz/zusm/always11/squad/slowly/
http://mujweb.cz/zusm/always11/squad/slowly/assistance.js
http://www.mujweb.cz/avon-lady/images/ehm.php
Jm73uZ
hgt5y54ytr
ryglman@yahoo.com
http://www.mujweb.cz/avon-lady/
http://www.mujweb.cz/avon-lady/ok.html
this shit again
http://www.mujweb.cz/avon-lady/r.php
again jdeumog
http://www.mujweb.cz/avon-lady/v.php
again <?php echo "Jm73uZ";?> 
view-source:http://www.mujweb.cz/avon-lady/webiny/
weirdness
http://usf.speleo.free.fr/drpdsn.cgi
Comments in French
Jm73uZ
ryglman@yahoo.com
http://usf.speleo.free.fr/
Some ISP in france?
http://lespotagersnatures.free.fr/ilrm.php
jkovdowqo
Jm73uZ
ryglman@yahoo.com

External Servers
http://mbcobretti.com/hydra.php
http://94.244.80.14/users.txt
http://awrinc.net/style/images/go.php?sid=1
http://srisaibalaji.com/aspnet_client/mypassword.php
http://sadmeanother12.ru/img/header.php?ftd=4755726&path=%7calways11%7cothers%7c&sys=UN&wrk=22

This gives us some more signatures to widen our search

still the Jm73uZ keeps showing up in each of them even when everything else changes, could this be the name of the hacker?

Well lets start searching some of these signatures:
