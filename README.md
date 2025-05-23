# ansible

Manage my ubuntu configuration

https://opensource.com/article/18/3/manage-workstation-ansible
https://docs.ansible.com/ansible/latest/modules/apt_module.html

## Install Ansible
sudo apt-get install software-properties-common  
sudo apt-add-repository ppa:ansible/ansible  
sudo apt-get update  
sudo apt-get install ansible  

## Execute a playbook file
sudo ansible-pull -U https://github.com/cerbaire/ansible.git  
ansible-playbook -i inventory playbooks/main.yaml  
ansible-playbook -i inventory.ini devops_setup.yml --ask-become-pass  
ansible-playbook -i inventory.ini molecule.yml --ask-become-pass
ansible all -m ping
ansible all -m command -a 'id'
ansible all -m ansible.builtin.setup

# Ansible Dev Setup for K3s, BuildKit, and Tilt

This Ansible project sets up a complete development environment on a single Linux host.

## Features:

-   K3s (without Docker daemon dependency), as a systemd service.
-   `kubectl` configured for a non-root user.
-   BuildKit as a systemd service, usable by the non-root user (via Unix socket).
-   Private Docker registry deployed in K3s (accessible via NodePort on `localhost`).
-   K3s configured to trust the local insecure registry.
-   Tilt installed, configured to use the standalone BuildKit daemon.
-   Sample Tilt project (Go by default) to demonstrate building with BuildKit, pushing to the local registry, and deploying to K3s.
-   Alternative sample projects for TypeScript, Python, C#, Rust, and Java are provided in the role files.
-   Installs `kubectl`, `helm`, `buildctl` (BuildKit client), and `git`.

## Prerequisites:

1.  **Target Host:** A Linux system with systemd (e.g., Ubuntu, Debian, Fedora, CentOS).
2.  **Ansible:** Installed on your control machine (can be the same as the target host).
3.  **User:** An existing non-root user on the target host for whom the environment will be configured (specified in `vars/main.yml`).
4.  **Sudo Access:** The Ansible play needs to run with `become: yes` to install packages and configure services.
5.  **Python:** Python 3 is usually required on the target host for Ansible modules. The playbook attempts to install `python3-pip`.

## Setup:

1.  **Clone this project (or create the files as described).**
2.  **Configure `inventory.ini`:**
    Set the target host. For running directly on the development machine:
    ```ini
    [dev_machine]
    localhost ansible_connection=local ansible_python_interpreter=/usr/bin/python3
    ```
    Or for a remote machine (ensure SSH access and Python 3):
    ```ini
    [dev_machine]
    your_dev_host ansible_user=your_ssh_user ansible_python_interpreter=/usr/bin/python3
    ```
3.  **Customize Variables (IMPORTANT):**
    Review and **edit `roles/k3s_dev_environment/vars/main.yml`**, especially to set your `dev_user`. You can also update tool versions.
    ```yaml
    # roles/k3s_dev_environment/vars/main.yml
    dev_user: "your_username" # <<< CHANGE THIS to your actual non-root username
    # ... other variables for tool versions, ports, etc.
    ```
4.  **Ensure Python and pip are installed on the target host:**
    E.g., on Debian/Ubuntu: `sudo apt update && sudo apt install -y python3 python3-pip`
    The playbook also tries to install `python3-pip` and the `kubernetes` Python library.

## Running the Playbook:

```bash
ansible-playbook -i inventory.ini playbook.yml -K
or add user to sudoers
/etc/sudoers.d/ansible
nicolas ALL=(ALL) NOPASSWD: ALL


After Running:
IMPORTANT: Log out and log back in for the non-root user (dev_user) for group changes (e.g., buildkit group) and environment variables (KUBECONFIG, BUILDKIT_HOST) to take full effect.
Verify K3s:
Bash

kubectl get nodes
kubectl get pods -A
Verify BuildKit: (As dev_user after re-login)
Bash

buildctl status
echo $BUILDKIT_HOST # Should show unix:///run/buildkit/buildkitd.sock
Verify Local Registry: The registry will be accessible at localhost:{{ registry_node_port }} (default 30500). You can try to push/pull an image to it using docker (if installed separately and configured for this insecure registry) or another tool. K3s itself will use it for pulling images.
Test Default Tilt Sample Project (Go): (As dev_user after re-login)
Bash

cd ~/tilt_sample_app # Or the path defined by 'tilt_sample_app_dir_base' and 'dev_user'
tilt up
Open your browser to http://localhost:8080 (port-forwarded by Tilt for the sample app) or the LoadBalancer IP shown by kubectl get svc tilt-sample-app-service. Tilt will build with BuildKit, push to localhost:30500, and deploy to K3s.