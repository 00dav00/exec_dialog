import json
import sys
import re
from pprint import pprint

jdata = sys.stdin.read()
json_data = json.loads(jdata)

# clean_data = re.sub('\s+','',jdata)
# json_data = json.loads(clean_data)


for item in json_data["options"]:
    print "caption:",item["caption"]
    print "command:",item["command"]

# print "caption:",json_data["options"][1]["caption"]
# print "command:",json_data["options"][1]["command"]
