![Test](https://github.com/Peco602/ansible-windows-docker/actions/workflows/test.yml/badge.svg)

# Ansible Windows Docker image

Run Ansible in a Windows container.

*Why?*

Ansible can only be installed on Linux, but you may have constraints to run it from a Windows box. 

## Build the image

```ps1
docker build -t ansible-windows:ltsc2022 .
```

## Run the container

Perform a simple `ping` module test on `localhost`:
```ps1
docker run -ti ansible-windows:ltsc2022 bash --login -c "ansible localhost -m ping"
```

Mount the `ansible` folder containing:
- `ansible.cfg`: Ansible default configuration
- `hosts`: Test hosts inventory
- `playbook.yml`: Test Ansible playbook 
and execute the `ansible-playbook` command:
```ps1
docker run --rm  --mount type="bind",source="$PWD\ansible",target="c:/tools/cygwin/etc/ansible" ansible-windows:ltsc2022 bash --login -c "ansible-playbook /etc/ansible/playbook.yml -i /etc/ansible/hosts"
```

Mount the `ansible` folder and run the container interactively:
```ps1
docker run --rm --mount type="bind",source="$PWD\ansible",target="c:/tools/cygwin/etc/ansible" -ti ansible-windows:ltsc2022 bash --login -i
```

## DockerHub

- [peco602/ansible-windows-docker](https://hub.docker.com/r/peco602/ansible-windows-docker)


## Bibliography

- https://github.com/dcfield/ansible_on_windows
- https://everythingshouldbevirtual.com/automation/ansible-using-ansible-on-windows-via-cygwin/
- https://blog.stephane-robert.info/post/installer-ansible-cygwin/
