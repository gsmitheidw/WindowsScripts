# 🔑 ssh from Windows to Linux with Yubikey authentication

## Intro
There's heaps of links online with this but many are using organisation specific pki certs and/or using gpg.
This is a simple scenario - no gpg etc. You have a yubico yubikey like the 5NFC and want to use it to authenticate
an ssh session from Windows client (server or desktop) to a Linux server at the far end. 

I presume it'll work in princple for Linux/FreeBSD/etc systems, the concept is exactly the same.
Although Windows does include sshd by default now, it does not currently (Nov21) have a new enough version 
of openssh included. We need 8.2+ for smart key support, less than that simply will not work. You may need
to go outside of your package manager's available version. I've read that OpenBSD 8.1 includes SK support,
but that's unusual. Debian Bullseye (11) has 8.2 support. 
If git is installed (which comes with git bash) on Windows it is likely to include a newer version of ssh client
greater than 8.2 for the client side - thats what we need to use. So far it's not supported in putty/kitty/etc.
Support for FIDO/U2F keys is pretty bare in general at the moment (Dec 2021): 
https://en.wikipedia.org/wiki/Comparison_of_SSH_clients#Authentication_key_algorithms

When setting this up, I recommend you have physical access (or virtual console access to the VM) as root, just in
case you lock yourself out of the system. 

## Client Pre-Requisites
Firstly launch git bash shell escalated via right click on the shortcut. It **MUST** be run escalated to Administrator
or it just won't have access to the yubikey device!
Then once you have the supported ssh version installed you can generate a key pair:

~~~
ssh-keygen -t ed25519-sk
~~~

Note the "-sk" on the end of that, that's important, the sk refers to Security Key which indicates
U2F/FIDO support. I prefer ed25519 over ecdsa for performance. 
Copy the contents of ~/.ssh/id_ed25519_sk.pub for inclusion in your authorized_keys on the server. 

## Setup

Server side do the following as root:
~~~
apt install libpam-yubico
~~~
The following set in **/etc/ssh/sshd_config**
~~~
PubkeyAuthentication yes
PasswordAuthentication no
UsePAM yes
ChallengeResponseAuthentication yes
AuthenticationMethods publickey,keyboard-interactive:pam
~~~
Then [as a regular user] create **~/.yubico/authorized_yubikeys** and
put in a single line with username:*<token-id>* where *<token-id>* is the first
12 characters of the response of pressing the button on the yubikey (in notepad or equivalent)
The full thing is 44 characters, but you just need the first 12 of those.

Here's a way to get that in powershell on the client side:
~~~
$YubiToken = Read-Host -Prompt 'Press Yubikey Button, then return'
$YubiToken.SubString(0,12) | Set-Clipboard
~~~


### Get an API key:
https://upgrade.yubico.com/getapikey/
That'll give you a *&lt;Client ID>*	and a *&lt;Secret key>* - make a note of those two
and in the server edit **/etc/pam.d/sshd**  and at the top fill in this line:

~~~
auth  required  pam_yubico.so id=<Client ID> key=<Secret Key> debug
~~~

## Testing it out:
ssh to the server and you'll get:
*Confirm user presence for key ED25519-SK SHA256:<bunch of characters>*

#### 🟡Press the button on your yubikey
and should get back the response:
*User presence confirmed*
Then be logged in sucessfully
  
## Android:
I have also tested it with [Termux](https://wiki.termux.com/wiki/Main_Page) on Android both with USB On-The-Go and
NFC but sadly does not work pick up the Yubikey on the terminal for ssh-keygen, it may work with a rooted device
with more hardware permissions than default user. 
