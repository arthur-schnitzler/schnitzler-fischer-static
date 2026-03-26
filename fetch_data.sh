# bin/bash

echo "fetching transkriptions from data_repo"
rm -rf data/
curl -LO https://github.com/arthur-schnitzler/schnitzler-fischer-data/archive/refs/heads/main.zip
unzip main

mv ./schnitzler-fischer-data-main/data/ .

rm main.zip
rm -rf ./schnitzler-fischer-data-main

echo "fetch imprint"
./shellscripts/dl_imprint.sh

# get schnitzler-chronik-data

# Download XML files from GitHub repository
rm -rf chronik-data
mkdir -p chronik-data
git clone --depth 1 --filter=blob:none --sparse https://github.com/arthur-schnitzler/schnitzler-chronik-data.git temp-chronik
cd temp-chronik
git sparse-checkout set editions/data
cd ..
find temp-chronik/editions/data -name "*.xml" -exec cp {} chronik-data/ \;
rm -rf temp-chronik

echo "creating calendar data"
uv run pyscripts/make_calendar_data.py

echo "adding mentions to indices"
uv run pyscripts/add_mentions.py
