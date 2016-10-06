set -e

LIST="env_config/win_builds_64.list"
BASE_URL="http://win-builds.org/1.5.0/packages/windows_64/"

if [[ -f/opt/windows_64 && -L /opt/windows_64 ]] ;
then
  echo "Removing old link /opt/windows_64"
  sudo rm /opt/windows_64
fi
echo "Creating new link /opt/windows_64 -> $PWD/opt/windows_64"
sudo ln -s $PWD/opt/windows_64 /opt/
echo ""

echo "Downloading packages into ./download/"
mkdir -p download
while read pkg; do
  if [[ ! ${pkg:0:1} == "#" ]] ;
  then
    if [ ! -f download/$pkg ]; then
      wget $BASE_URL$pkg -P download -q
    fi
    echo "[+] $pkg"
  fi
done < $LIST
echo ""

echo "Unpacking packages into ./opt/"
rm -rf opt
mkdir -p opt
while read pkg; do
if [[ ! ${pkg:0:1} == "#" ]] ;
then
  tar -xf download/$pkg -C opt
  echo "[+] $pkg"
fi
done < $LIST
echo ""

echo "Setup finished"
