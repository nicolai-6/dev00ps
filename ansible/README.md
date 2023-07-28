# Ansible host environment prerequisites
    # python venv
    python3 -m venv ansible_5.2.0
    source ansible_5.2.0/bin/activate
    python3 -m pip install --upgrade pip
    python3 -m pip install ansible==5.2.0

    # config
    export ANSIBLE_CONFIG=ansible/ansible.cfg

    # vault encrpyt
    ansible-vault encrypt_string --encrypt-vault-id vaultgh STRING