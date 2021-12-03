# 🔑 ssh from Windows to Linux with Yubikey authentication

## Intro
There's heaps of links online with this but many are using organisation specific pki certs and gpg.
This is a simple scenario - you have a yubico yubikey like the 5NFC and want to use it to authenticate
and ssh session from Windows client (server or desktop) to a Linux server at the far end. I presume it'll
work in princple for FreeBSD and other *nix like systems. Although Windows does include sshd by default now,
it does not currently (Nov21) have a new enough version of openssh included. We need 8.2+ for smart key support.

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

Here's a way to get that in powershell:
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
