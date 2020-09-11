cd /tmp
rm -rf imp_hunter 2>/dev/null
git clone https://github.com/tfournet/imp_hunter
cd imp_hunter
sh setup.sh >/dev/null 2&>1
cd /
rm -rf /tmp/imp_hunter

