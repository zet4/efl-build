set -e

LIST="env_config/win_builds_64.list"
BASE_URL="http://win-builds.org/1.5.0/packages/windows_64/"

echo "Creating links..."
sudo ln -s $PWD/opt/windows_64 /opt/
echo "Creating links... done"

echo "Downloading packages into download..."
mkdir -p download
while read pkg; do
  if [ ! -f download/$pkg ]; then
    wget $BASE_URL$pkg -P download -nv
  fi
done < $LIST
echo "Downloading packages... done"

echo "Unpacking packages into opt..."
rm -rf opt
mkdir -p opt
while read pkg; do
if [[ ${pkg:0:1} == "#" ]] ;
then
  echo "Skipping $pkg"
else
  echo "Extraction $pkg"
  tar -xf download/$pkg -C opt
fi
done < $LIST
echo "Unpacking packages... done"
