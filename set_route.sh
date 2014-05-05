


resolv="/etc/resolv.conf"

sudo echo -ne "\
nameserver 140.109.1.10 \n\
nameserver 140.109.20.250 \n\
search iis.sinica.edu.tw \n\
" > $resolv


/etc/init.d/networking restart

H1_0="140.109.18.167"
H1_1="10.1.0.1"
H2_0="10.1.0.2"
H2_1="10.1.1.1"
H3_0="10.1.1.2"
H3_1="10.1.2.1"
H4_0="10.1.2.2"
H4_1="10.1.3.1"
H5_0="10.1.3.2"

H1_H2="10.1.0.0"
H2_H3="10.1.1.0"
H3_H4="10.1.2.0"
H4_H5="10.1.3.0"

m24="255.255.255.0"

# route add default gw $H1_1
route add -net $H2_H3 netmask $m24 gw $H2_0
route add -net $H3_H4 netmask $m24 gw $H2_0
route add -net $H4_H5 netmask $m24 gw $H2_0
