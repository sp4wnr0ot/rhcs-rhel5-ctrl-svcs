#!/usr/bin/perl
#
# ###############################################################
#
# Description :  controlaDR.pl
# Author : Raul da Silva Leite
# Date : 13/09/2013
#
# ###############################################################

	if ( $#ARGV < 0 ) {
	print "\n***************************************************************** \n";
	print "\t   Para ativar o DR execute './ativa_cob.pl start'  \n";
	print "\t   Para encerrar o DR execute './ativa_cob.pl stop' \n";
	print "\n ***************************************************************** \n\n";
        }

	if ( $ARGV[0] eq "start" ) {
	&start;
	}

	if ( $ARGV[0] eq "stop" ) {
	&stop;
	}

sub start {
print "\nCarregando o DR...\n\n";
$aux=0;
@daemons=(cman,clvmd,gfs2);
	while ( $aux < @daemons ) {
	$dexec=`/sbin/service $daemons[$aux] start `;
	print ("\n$dexec");
	$aux++;
	}

print "\nMontando gfs2 filesystem : \n";
$mount_1=`mount -o locktable=CLUSTER_TEST2:lv_postgresql -t gfs2 /dev/VG_TEST/lv_postgresql /var/lib/pgsql`;
$mount_2=`mount -o locktable=CLUSTER_TEST2:lv_httpd -t gfs2 /dev/VG_TEST/lv_httpd /usr/local/httpd`;
print "\n$mount_1";
print "\n$mount_2";

$dexec_post=`/sbin/service postgresql start `;
print ("\n$dexec_post");

$dexec_eng=`/sbin/service httpd start `;
print ("\n$dexec_eng");


}

sub stop {
print "\nBaixando o DR...\n\n";
$aux=0;

@daemons=(httpd,postgresql,gfs2,clvmd,cman);

	while ( $aux < @daemons ) {
	$dexec=`/sbin/service $daemons[$aux] stop `;
	print ("\n $dexec");
	$aux++;
	}

}
