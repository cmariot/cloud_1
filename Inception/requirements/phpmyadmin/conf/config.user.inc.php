<!-- ServerName -->
$cfg['Servers'][$i]['ssl'] = true;
$cfg['Servers'][$i]['ssl_key'] = '/cert/privkey.pem';
$cfg['Servers'][$i]['ssl_cert'] = '/cert/fullchain.pem';
$cfg['Servers'][$i]['ssl_ca'] = '/cert/cert.pem';
$cfg['Servers'][$i]['ssl_ca_path'] = '/cert/cert.pem';
$cfg['Servers'][$i]['ssl_verify'] = true;
$cfg['Servers'][$i]['force_ssl'] = true;

