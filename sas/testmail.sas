filename mail email "your.email@domain.com" subject="Testing Email Server";

data _null_;
  file mail;
  put 'Hello Patron!';
  put 'Just testing the email server from our project servers.';
run;
