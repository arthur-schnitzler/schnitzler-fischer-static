# /// script
# requires-python = ">=3.9"
# dependencies = [
#   "acdh-tei-pyutils",
#   "tqdm",
# ]
# ///

import glob
import os
import re
import json
from lxml import etree
from acdh_tei_pyutils.tei import TeiReader
from tqdm import tqdm

TEI_NS = {"tei": "http://www.tei-c.org/ns/1.0"}
_INVALID_XMLID = re.compile(rb'xml:id="(\d)')


class RecoveringReader:
    def __init__(self, path):
        with open(path, "rb") as f:
            content = _INVALID_XMLID.sub(rb'xml:id="sf_\1', f.read())
        self._root = etree.fromstring(content)

    def any_xpath(self, xpath):
        return self._root.xpath(xpath, namespaces=TEI_NS)


out_path = os.path.join("html", "js-data")
os.makedirs(out_path, exist_ok=True)

files = sorted(glob.glob("./data/editions/*.xml"))

out_file = os.path.join(out_path, "calendarData.js")
data = []
for x in tqdm(files, total=len(files)):
    item = {}
    head, tail = os.path.split(x)
    try:
        doc = TeiReader(x)
    except Exception:
        doc = RecoveringReader(x)
    try:
        item["name"] = doc.any_xpath('//tei:title/text()')[0]
    except IndexError:
        continue
    try:
        item["startDate"] = doc.any_xpath(
            "//tei:correspAction[@type='sent']/tei:date/@*[name()='when' or name()='notBefore' or name()='from']"
        )[0]
    except IndexError:
        continue
    try:
        item["tageszaehler"] = doc.any_xpath(
            "//tei:correspAction[@type='sent']/tei:date/@n"
        )[0]
        item["id"] = tail.replace(".xml", ".html")

        sent = '//tei:correspAction[@type="sent"]'
        recv = '//tei:correspAction[@type="received"]'
        is_schnitzler_sender = doc.any_xpath(
            f'{sent}//tei:persName[@ref="#pmb2121"]'
        )
        is_schnitzler_receiver = doc.any_xpath(
            f'{recv}//tei:persName[@ref="#pmb2121"]'
        )

        if is_schnitzler_sender:
            item["category"] = "as-sender"
            item["categoryLabel"] = "Von Schnitzler"
        elif is_schnitzler_receiver:
            item["category"] = "as-empf"
            item["categoryLabel"] = "Von Fischer"
        else:
            item["category"] = "umfeld"
            item["categoryLabel"] = "Von Dritten"

        try:
            sender = doc.any_xpath(f'{sent}//tei:persName/text()')
            receiver = doc.any_xpath(f'{recv}//tei:persName/text()')
            if sender and receiver:
                item["accessible_desc"] = (
                    f"Brief von {sender[0]} an {receiver[0]}"
                )
            elif sender:
                item["accessible_desc"] = f"Brief von {sender[0]}"
            elif receiver:
                item["accessible_desc"] = f"Brief an {receiver[0]}"
            else:
                item["accessible_desc"] = item["name"]
        except Exception:
            item["accessible_desc"] = item["name"]

        data.append(item)
    except IndexError:
        continue

print(f"writing calendar data to {out_file}")
with open(out_file, "w", encoding="utf8") as f:
    my_js_variable = (
        f"var calendarData = {json.dumps(data, ensure_ascii=False)}"
    )
    f.write(my_js_variable)
