#!/bin/bash
# ============================
# BookStore Database Restore
# ============================

S3_BUCKET="bookstore-backup-khanh"
RESTORE_DIR="/home/ec2-user/backups/db"

# Neu khong truyen tham so, lay backup moi nhat
if [ -z "$1" ]; then
  echo "=== Tim backup moi nhat tren S3 ==="
  BACKUP_FILE=$(aws s3 ls s3://${S3_BUCKET}/db/ --recursive | sort | tail -1 | awk '{print $4}')
  BACKUP_NAME=$(basename ${BACKUP_FILE})
else
  BACKUP_NAME="$1"
fi

echo "=== Restore tu: ${BACKUP_NAME} ==="

mkdir -p ${RESTORE_DIR}

echo "=== [1/4] Download backup tu S3 ==="
aws s3 cp s3://${S3_BUCKET}/db/${BACKUP_NAME} ${RESTORE_DIR}/${BACKUP_NAME}

echo "=== [2/4] Copy vao container ==="
docker exec bookstore-database-1 mkdir -p /var/opt/mssql/backup
docker cp ${RESTORE_DIR}/${BACKUP_NAME} bookstore-database-1:/var/opt/mssql/backup/${BACKUP_NAME}

echo "=== [3/4] Tat ket noi hien tai ==="
docker exec bookstore-database-1 /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'BookStore@Str0ng!' -C \
  -Q "ALTER DATABASE [BookStoreDb] SET SINGLE_USER WITH ROLLBACK IMMEDIATE"

echo "=== [4/4] Restore database ==="
docker exec bookstore-database-1 /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'BookStore@Str0ng!' -C \
  -Q "RESTORE DATABASE [BookStoreDb] FROM DISK = N'/var/opt/mssql/backup/${BACKUP_NAME}' WITH REPLACE"

docker exec bookstore-database-1 /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'BookStore@Str0ng!' -C \
  -Q "ALTER DATABASE [BookStoreDb] SET MULTI_USER"

echo "✅ Restore hoan tat tu: ${BACKUP_NAME}"
