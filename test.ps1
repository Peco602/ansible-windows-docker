${NETWORK_NAME}="ansible_test_net"
${TARGET_IMAGE_NAME}="peco602/winrm-windows-docker:1809"
${ANSIBLE_IMAGE_NAME}="ansible-windows:1809"

function Show-Info($message) {
    Write-Host " [+] ${message}" -ForegroundColor green
}

Show-Info "Building docker image"
docker build -t ${ANSIBLE_IMAGE_NAME} .

Show-Info "Running target containers"
docker network create ${NETWORK_NAME} --driver=nat --subnet="192.168.100.1/24"
for ($i = 2 ; $i -le 3; $i++) {
    docker run --network=${NETWORK_NAME} --ip="192.168.100.$i" -d ${TARGET_IMAGE_NAME}
}

Show-Info "Collecting data"
docker run --rm --network=${NETWORK_NAME} --mount type="bind",source="$PWD\ansible",target="c:/tools/cygwin/etc/ansible" ${ANSIBLE_IMAGE_NAME} bash --login -c "ansible-playbook /etc/ansible/playbook.yml -i /etc/ansible/hosts"

Show-Info "Cleaning up"
docker rm $(docker network inspect ${NETWORK_NAME} --format='{{range $id, $_ := .Containers}}{{println $id}}{{end}}') --force
docker network rm ${NETWORK_NAME}

[Console]::ResetColor()