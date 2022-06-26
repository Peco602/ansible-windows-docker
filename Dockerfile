FROM mcr.microsoft.com/windows/servercore:1809

LABEL name="Ansible Windows Container"
LABEL description="This container is a Windows container designed to run Ansible."
LABEL maintainer="Peco602 <giovanni1.pecoraro@protonmail.com>"

RUN @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
RUN choco install -y cygwin mingw

RUN curl https://raw.githubusercontent.com/transcode-open/apt-cyg/master/apt-cyg -o apt-cyg
RUN /tools/cygwin/bin/install apt-cyg /bin
RUN del apt-cyg

WORKDIR "/tools/cygwin"
RUN cygwinsetup.exe -q -P wget

WORKDIR "/tools/cygwin/bin"

SHELL ["bash.exe", "--login", "-c"]
ENV CYGWIN="winsymlinks"
RUN "apt-cyg install git gmp binutils curl gcc-core libffi-devel libgmp-devel make nano openssh openssl openssl-devel sshpass python3 python3-devel libssl-devel python39-cryptography krb5-debuginfo krb5-doc krb5-k5tls krb5-pkinit krb5-samples krb5-server krb5-server-ldap krb5-workstation libgssapi_krb5_2 libgssrpc4 libk5crypto3 libkadm5clnt_mit11 libkadm5srv_mit11 libkdb5_8 libkrad0 libkrb5-devel libkrb5_3 libkrb5support0"
RUN "pip3 install ansible mitogen ansible-lint jmespath 'pywinrm>=0.3.0' pywinrm[kerberos] pykerberos"
RUN "rm -rf /.cache/pip"
RUN "mkdir /ansible && mkdir -p /etc/ansible"

SHELL ["bash.exe", "--login", "-i"]
CMD ["bash.exe", "--login", "-i"]
