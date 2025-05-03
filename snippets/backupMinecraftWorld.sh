#!/bin/bash

#=================================================================

SSH_PASSWORD=$SERVER_PASSWORD_RELLUEM94_DE
SSH_HOST=$SERVER_HOST_RELLUEM94_DE
SSH_USER=$SERVER_USER_RELLUEM94_DE
SSH_PORT=$SERVER_PORT_RELLUEM94_DE

MC_DIR=$SERVER_MINECRAFT_DIR_RELLUEM94_DE


#=================================================================



WORLD_NAME="${1:-world}"
WORLD_DIR="${MC_DIR}/${WORLD_NAME}"
ZIP_NAME="${WORLD_NAME}_backup_$(date +%Y%m%d_%H%M%S).zip"
REMOTE_ZIP_PATH="/tmp/${ZIP_NAME}"
LOCAL_BACKUP_DIR="${HOME}/bak/freebuild/${WORLD_NAME}"


#=================================================================


if [[ -z "${SSH_USER}" || -z "${SSH_HOST}" ]]; then
  echo "Error: SSH_USER or SSH_HOST not set!"
  exit 1
fi


mkdir -p "${LOCAL_BACKUP_DIR}" || { echo "Error: Could not create local backup directory ${LOCAL_BACKUP_DIR}!"; exit 1; }

echo "Zipping ${WORLD_NAME} on the server..."
sshpass -p "${SSH_PASSWORD}" ssh -o StrictHostKeyChecking=no -t "${SSH_USER}@${SSH_HOST}" "cd ${MC_DIR} && zip -q -r ${REMOTE_ZIP_PATH} ${WORLD_NAME}" || {
  echo "Error during zipping!"
  exit 1
}
echo "Zipping completed."

echo "Checking if ZIP file exists on server..."
sshpass -p "${SSH_PASSWORD}" ssh -o StrictHostKeyChecking=no -t "${SSH_USER}@${SSH_HOST}" "bash --noprofile --norc -c 'ls -l ${REMOTE_ZIP_PATH}'" || {
  echo "Error: ZIP file ${REMOTE_ZIP_PATH} not found on server!"
  exit 1
}

echo "Copying ${ZIP_NAME} to local host..."
sshpass -p "${SSH_PASSWORD}" scp -P "${SSH_PORT}" -o StrictHostKeyChecking=no "${SSH_USER}@${SSH_HOST}:${REMOTE_ZIP_PATH}" "${LOCAL_BACKUP_DIR}/${ZIP_NAME}" || {
  echo "Error copying ZIP file!"
  exit 1
}

echo "Deleting ${ZIP_NAME} on the server..."
sshpass -p "${SSH_PASSWORD}" ssh -o StrictHostKeyChecking=no -t "${SSH_USER}@${SSH_HOST}" "bash --noprofile --norc -c 'rm ${REMOTE_ZIP_PATH}'" || {
  echo "Error deleting ZIP file on server!"
  exit 1
}

echo "Backup successfully created and copied to ${LOCAL_BACKUP_DIR}/${ZIP_NAME}!"
