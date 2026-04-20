Make executable
chmod +x /home/sh/internet/check_internet.sh



Add cron job
crontab -e

Add:

*/5 * * * * /home/sh/internet/check_internet.sh
