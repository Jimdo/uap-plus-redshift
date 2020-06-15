# UAPPlus-Redshift
Redshift python library for user agent detection.
- Built from [ua_parser_plus](!https://github.com/edmodo/ua_parser_plus)

## Usage
```sql
CREATE OR REPLACE LIBRARY ua_parser_plus
LANGUAGE plpythonu 
FROM 'https://github.com/nihhaar/uapplus-redshift/releases/download/latest/uapplus-redshift.zip'
CREDENTIALS '<CREDENTIALS>';

CREATE OR REPLACE FUNCTION udf.f_ua_device_brand(ua VARCHAR(MAX)) RETURNS VARCHAR(MAX) IMMUTABLE as $$
  if ua is None or ua == '': return None
  from ua_parser_plus.user_agent_parser import Parse;
  import json
  if 'device' in Parse(ua):
    if 'brand' in Parse(ua)['device']:
        return json.dumps(Parse(ua)['device']['brand'])
  return None
$$ LANGUAGE plpythonu;

CREATE OR REPLACE FUNCTION udf.f_ua_device_model(ua VARCHAR(MAX)) RETURNS VARCHAR(MAX) IMMUTABLE as $$
  if ua is None or ua == '': return None
  from ua_parser_plus.user_agent_parser import Parse;
  import json
  if 'device' in Parse(ua):
    if 'brand' in Parse(ua)['device']:
        return json.dumps(Parse(ua)['device']['model'])
  return None
$$ LANGUAGE plpythonu;

CREATE OR REPLACE FUNCTION udf.f_ua_device_browser(ua VARCHAR(MAX)) RETURNS VARCHAR(MAX) IMMUTABLE as $$
  if ua is None or ua == '': return None
  from ua_parser_plus.user_agent_parser import Parse;
  import json
  if 'device' in Parse(ua):
    if 'brand' in Parse(ua)['device']:
        return json.dumps(Parse(ua)['device']['browser'])
  return None
$$ LANGUAGE plpythonu;

CREATE OR REPLACE FUNCTION udf.f_ua_device_family(ua VARCHAR(MAX)) RETURNS VARCHAR(MAX) IMMUTABLE as $$
  if ua is None or ua == '': return None
  from ua_parser_plus.user_agent_parser import Parse;
  import json
  if 'device' in Parse(ua):
    if 'brand' in Parse(ua)['device']:
        return json.dumps(Parse(ua)['device']['family'])
  return None
$$ LANGUAGE plpythonu;
```

UDFs are very slow, so you should minimize the number of calls to it. For example, the above UDFs can be merged into a single UDF using json_extract:
```sql
CREATE OR REPLACE FUNCTION udf.f_ua_device_json(ua VARCHAR(MAX)) RETURNS VARCHAR(MAX) IMMUTABLE as $$
  if ua is None or ua == '': return None
  from ua_parser_plus.user_agent_parser import Parse;
  import json
  if 'device' in Parse(ua):
    return json.dumps(Parse(ua)['device'])
  return None
$$ LANGUAGE plpythonu;

WITH
udf_subquery as (
    SELECT
     id
    ,udf.f_ua_device_json(params) as udf_json_result
    FROM table
)
SELECT
    id
    ,json_extract_path_text(udf_json_result, 'key1') as col1
    ,json_extract_path_text(udf_json_result, 'key2') as col2
FROM udf_subquery;
```


## ua_parser_plus
An enhanced version of the python implementation of the UA Parser (https://github.com/ua-parser, formerly https://github.com/tobie/ua-parser). The plus version allows processing case insensitive user agent strings.

##Installing

In the top-level directory run:
```
python setup.py develop
```

##Getting Started

### retrieve data on a user-agent string
```
>>> import ua_parser_plus.user_agent_parser
>>> import pprint
>>> pp = pprint.PrettyPrinter(indent=4)
>>> ua_string = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.104 Safari/537.36'
>>> parsed_string = ua_parser_plus.user_agent_parser.Parse(ua_string)
>>> pp.pprint(parsed_string)
{   'device': {   'brand': None, 'family': 'Other', 'model': None},
    'os': {   'family': 'Mac OS X',
              'major': '10',
              'minor': '9',
              'patch': '4',
              'patch_minor': None},
    'string': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.104 Safari/537.36',
    'user_agent': {   'family': 'Chrome',
                      'major': '41',
                      'minor': '0',
                      'patch': '2272'}}
```


### extract browser data from user-agent string

```
>>> import ua_parser_plus.user_agent_parser
>>> import pprint
>>> pp = pprint.PrettyPrinter(indent=4)
>>> ua_string = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.104 Safari/537.36'
>>> parsed_string = ua_parser_plus.user_agent_parser.ParseUserAgent(ua_string)
>>> pp.pprint(parsed_string)
 {   'family': 'Chrome', 
	 'major': '41', 
	 'minor': '0', 
	 'patch': '2272'}
```

### extract OS information from user-agent string

```
>>> import ua_parser_plus.user_agent_parser
>>> import pprint
>>> pp = pprint.PrettyPrinter(indent=4)
>>> ua_string = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.104 Safari/537.36'
>>> parsed_string = ua_parser_plus.user_agent_parser.ParseOS(ua_string)
>>> pp.pprint(parsed_string)
{   'family': 'Mac OS X',
    'major': '10',
    'minor': '9',
    'patch': '4',
    'patch_minor': None}
```

### extract Device information from user-agent string


```
>>> import ua_parser_plus.user_agent_parser
>>> import pprint
>>> pp = pprint.PrettyPrinter(indent=4)
>>> ua_string = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.104 Safari/537.36'
>>> parsed_string = ua_parser_plus.user_agent_parser.ParseDevice(ua_string)
>>> pp.pprint(parsed_string)
{   'brand': None, 
	'family': 'Other', 
	'model': None}
```


## Copyright

Copyright 2008 Google Inc. See ua_parser/LICENSE for more information 

