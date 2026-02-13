use d1;
select * from personal_deets;

SELECT full_name, TRIM(full_name) AS trimmed_name
FROM personal_deets;

SELECT
LTRIM(full_name) AS left_trim,
RTRIM(full_name) AS right_trim
FROM personal_deets;

SELECT email,
LOWER(email) AS lower_email,
UPPER(address) AS upper_address
FROM personal_deets;

SELECT notes,
REPLACE(REPLACE(REPLACE(notes,'@',''),'#',''),'*','') AS clean_notes
FROM personal_deets;

SELECT email,
REGEXP_REPLACE(email, '[^a-zA-Z0-9@._]', '') AS clean_email
FROM personal_deets;

SELECT phone,
REGEXP_REPLACE(phone, '[^0-9]', '') AS digits_only
FROM personal_deets;

SELECT 
SUBSTRING(REGEXP_REPLACE(phone,'[^0-9]',''), -10) AS last_10_digits
FROM personal_deets;

SELECT
LEFT(full_name,5) AS left_part,
RIGHT(email,10) AS right_part
FROM personal_deets;

SELECT
SUBSTRING_INDEX(email,'@',1) AS username,
SUBSTRING_INDEX(email,'@',-1) AS domain
FROM personal_deets;

SELECT email,
INSTR(email,'@') AS at_position,
LOCATE('@',email) AS locate_at
FROM personal_deets;

SELECT LPAD(id,4,'0') AS padded_id
FROM personal_deets;

SELECT
CONCAT(TRIM(full_name),' - ', LOWER(email)) AS combined
FROM personal_deets;

SELECT full_name,
CHAR_LENGTH(full_name) AS char_length
FROM personal_deets;

SELECT full_name,
LENGTH(full_name) FROM personal_deets;

SELECT notes,
COALESCE(notes,'No Notes Available') AS notes_status
FROM personal_deets;

SELECT full_name,
ASCII(LEFT(TRIM(full_name),1)) AS ascii_value
FROM personal_deets;

SELECT full_name, REVERSE(full_name) FROM personal_deets;


SELECT 
CONCAT(
UPPER(LEFT(clean_name,1)),
LOWER(SUBSTRING((clean_name),2))
  ) AS proper_name
FROM(
SELECT REGEXP_REPLACE(
REGEXP_REPLACE(TRIM(full_name), '[^a-zA-Z ]', ''),
'[[:space:]]+', ' ') 
as clean_name 
FROM personal_deets)t;

SELECT email,
LOWER(
  REGEXP_REPLACE(                                   -- remove double dots
    REGEXP_REPLACE(                                 -- only one @
      REGEXP_REPLACE(                               -- remove spaces
        REGEXP_REPLACE(                             -- keep valid chars
          REGEXP_REPLACE(                           -- fix (at) and #
            TRIM(email),
            '\\(at\\)|#', '@'
          ),
          '[^a-zA-Z0-9@._]', ''
        ),
        '[[:space:]]+', ''
      ),
      '@{2,}', '@'
    ),
    '\\.{2,}', '.'
  )) AS clean_email
FROM personal_deets;

