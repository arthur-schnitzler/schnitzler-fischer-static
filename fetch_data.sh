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

echo "creating calendar data"
uv run pyscripts/make_calendar_data.py
