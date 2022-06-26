docker login -u peco602
docker tag ansible-windows:ltsc2022 peco602/ansible-windows-docker:latest
docker push peco602/ansible-windows-docker:latest