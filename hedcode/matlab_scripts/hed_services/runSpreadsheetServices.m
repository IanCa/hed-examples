%% Shows how to call hed-services to process a spreadsheet of event tags.
% 
%  Example 1: Validate valid spreadsheet file using schema version.
%
%  Example 2: Validate invalid spreadsheet file using HED URL.
%
%  Example 3: Convert valid spreadsheet file to long uploading HED schema.
%
%  Example 4: Convert valid spreadsheet file to short using HED version.
%
%% Setup requires a csrf_url and services_url. Must set header and options.
%host = 'http://127.0.0.1:5000';
host = 'https://hedtools.ucsd.edu/hed';
csrfUrl = [host '/services']; 
servicesUrl = [host '/services_submit'];
[cookie, csrftoken] = getSessionInfo(csrfUrl);
header = ["Content-Type" "application/json"; ...
          "Accept" "application/json"; 
          "X-CSRFToken" csrftoken; "Cookie" cookie];

options = weboptions('MediaType', 'application/json', 'Timeout', 120, ...
                     'HeaderFields', header);

%% Set the data used in the examples
spreadsheetText = fileread('../../data/spreadsheet_data/LKTEventCodesHED3.tsv');
spreadsheetTextInvalid = fileread('../../data/spreadsheet_data/LKTEventCodesHED2.tsv');
schemaText = fileread('../../data/schema_data/HED8.0.0.xml');
labelPrefix = 'Property/Informational-property/Label/';
descPrefix = 'Property/Informational-property/Description/';
schemaUrl =['https://raw.githubusercontent.com/hed-standard/' ...
             'hed-specification/master/hedxml/HED8.0.0.xml'];
         
%% Example 1: Validate valid spreadsheet file using schema version.
request1 = struct('service', 'spreadsheet_validate', ...
                  'schema_version', '8.0.0', ...
                  'spreadsheet_string', spreadsheetText, ...
                  'check_for_warnings', 'on', ...
                  'has_column_names', 'on', ...
                  'column_2_input', labelPrefix, ...
                  'column_2_check', 'on', ...
                  'column_5_input', '', ...
                  'column_5_check', 'on');
response1 = webwrite(servicesUrl, request1, options);
response1 = jsondecode(response1);
outputReport(response1, 'Example 1 validate a valid spreadsheet');

%% Example 2: Validate invalid spreadsheet file using HED URL.
request2 = struct('service', 'spreadsheet_validate', ...
                  'schema_url', schemaUrl, ...
                  'spreadsheet_string', spreadsheetTextInvalid, ...
                  'check_for_warnings', 'on', ...
                  'has_column_names', 'on', ...
                  'column_2_input', 'Event/Label/', ...
                  'column_2_check', 'on', ...
                  'column_5_input', '', ...
                  'column_5_check', 'on');
response2 = webwrite(servicesUrl, request2, options);
response2 = jsondecode(response2);
outputReport(response2, 'Example 2 validate an invalid spreadsheet');

%% Example 3: Convert valid spreadsheet file to long uploading HED schema.
request3 = struct('service', 'spreadsheet_to_long', ...
                  'schema_string', schemaText, ...
                  'spreadsheet_string', spreadsheetText, ...
                  'expand_defs', 'on', ...
                  'has_column_names', 'on', ...
                  'column_2_input', labelPrefix, ...
                  'column_2_check', 'on', ...
                  'column_4_input', descPrefix, ...
                  'column_4_check', 'on', ...
                  'column_5_input', '', ...
                  'column_5_check', 'on');
response3 = webwrite(servicesUrl, request3, options);
response3 = jsondecode(response3);
outputReport(response3, 'Example 3 convert a spreadsheet to long form');
results = response3.results;

%% Example 4: Convert valid spreadsheet file to short using uploaded HED.
request4 = struct('service', 'spreadsheet_to_short', ...
                  'schema_string', schemaText, ...
                  'spreadsheet_string', spreadsheetText, ...
                  'expand_defs', 'on', ...
                  'has_column_names', 'on', ...
                  'column_2_input', labelPrefix, ...
                  'column_2_check', 'on', ...
                  'column_4_input', descPrefix, ...
                  'column_4_check', 'on', ...
                  'column_5_input', '', ...
                  'column_5_check', 'on');
response4 = webwrite(servicesUrl, request4, options);
response4 = jsondecode(response4);
outputReport(response4, 'Example 4 convert a spreadsheet to short form');