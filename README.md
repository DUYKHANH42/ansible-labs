# Ansible Labs - BookStore on AWS EC2

## Cau truc
- roles/docker/ - Role cai dat Docker
- roles/bookstore/ - Role deploy BookStore
- roles/backup/ - Role backup & recovery
- playbook-setup.yml - Cai moi truong
- playbook-deploy.yml - Deploy BookStore
- playbook-backup.yml - Backup database + EBS snapshot
- playbook-restore.yml - Restore tu S3
- backup-scripts/ - Scripts backup/restore

## Su dung
- Deploy: ansible-playbook playbook-deploy.yml
- Backup: ansible-playbook playbook-backup.yml
- Restore: ansible-playbook playbook-restore.yml

## Thong tin
- EC2: 13.228.219.111 (Amazon Linux 2023)
- S3 Backup: bookstore-backup-khanh
- Stack: ASP.NET Core 8.0 + Angular + SQL Server 2019
