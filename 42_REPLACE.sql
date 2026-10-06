-- REPPLACE : Replaces specific charcater with a new character

-- Remove dahses - from a phone numbers
SELECT 
'123-456-7890' phone_number,
REPLACE('123-456-7890','-','') clean_phone_num

-- Replace file extension from txt to csv
SELECT 
'reports.txt' AS old_filename,
REPLACE('reports.txt','.txt','.csv') AS new_filename