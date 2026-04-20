Make executable:

chmod +x /home/sh/internet/check_internet.sh



Add cron job:

crontab -e

Add:

*/20 * * * * /home/sh/internet/check_internet.sh
