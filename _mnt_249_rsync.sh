#<mount nfs:249>
cd /mnt
rsync -avz --progress Downloads 249/_mnt_Downloads &
rsync -avz --progress user/Documents 249/_mnt_Documents &
rsync -avz --progress user/Pictures 249/_mnt_Pictures &
rsync -avz --progress user/Videos 249/_mnt_Videos &
#rsync -avz --progress user/VM/g64 249/_mnt_g64
